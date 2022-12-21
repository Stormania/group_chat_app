import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:location/location.dart';

class LocationApi {
  const LocationApi({required this.location, required this.firestore});

  final Location location;
  final FirebaseFirestore firestore;

  Future<UserLocation?> getLocation(String uid) async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
      permission = await location.requestPermission();

      if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
        return null;
      }
    }

    final LocationData result = await location.getLocation();
    final UserLocation userLocation = UserLocation(lat: result.latitude ?? 0.0, lng: result.longitude ?? 0.0, uid: uid);
    await firestore.collection('locations').doc(uid).set(userLocation.toJson());
    return userLocation;
  }
}
