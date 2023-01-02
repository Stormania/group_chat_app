import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:group_chat_app/src/presentation/containers/user_container.dart';
import 'package:group_chat_app/src/presentation/containers/user_location_container.dart';
import 'package:group_chat_app/src/presentation/containers/users_container.dart';
import 'package:latlong2/latlong.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  late Store<AppState> _store;

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _store
      ..dispatch(const GetLocation.start())
      ..dispatch(const ListenForLocations.start())
      ..dispatch(const ListenForUsers.start());
  }

  @override
  void dispose() {
    _store
      ..dispatch(const ListenForLocations.done())
      ..dispatch(const ListenForUsers.start());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserLocationsContainer(
      builder: (BuildContext context, List<UserLocation> locations) {
        return UserContainer(
          builder: (BuildContext context, AppUser? user) {
            final UserLocation? currentUserLocation =
                locations.firstWhereOrNull((UserLocation location) => location.uid == user?.uid);

            return Scaffold(
              appBar: AppBar(
                title: Text("${user!.displayName}'s Profile"),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    icon: const Icon(Icons.account_circle_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(const Logout());
                    },
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
              body: currentUserLocation == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: <Widget>[
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: LatLng(
                              currentUserLocation.lat,
                              currentUserLocation.lng,
                            ),
                            zoom: 8,
                          ),
                          children: <Widget>[
                            TileLayer(
                              urlTemplate:
                                  'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/512/{z}/{x}/{y}@2x?access_token={access_token}',
                              additionalOptions: const <String, String>{
                                'access_token':
                                    'pk.eyJ1Ijoic3Rvcm1hbmlhIiwiYSI6ImNsY2RwMXRndjBrZWMzdW4xMGx5NXpnYjgifQ.he9qYonaWgC_Rz4B-ZOfHQ',
                              },
                            ),
                            UsersContainer(
                              builder: (BuildContext context, List<AppUser> users) {
                                return MarkerLayer(
                                  markers: <Marker>[
                                    for (final UserLocation location in locations)
                                      Marker(
                                        point: LatLng(location.lat, location.lng),
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              final AppUser? locationUser =
                                                  users.firstWhereOrNull((AppUser user) => user.uid == location.uid);
                                              if (locationUser == null) {
                                                return;
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text(locationUser.displayName)));
                                            },
                                            child: Icon(
                                              Icons.location_pin,
                                              color: location.uid == user.uid ? Colors.blue : Colors.red,
                                            ),
                                          );
                                        },
                                      )
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                        SafeArea(
                          child: Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    _mapController.zoom;
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}
