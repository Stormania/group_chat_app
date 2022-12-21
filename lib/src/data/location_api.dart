import 'package:group_chat_app/src/models/index.dart';
import 'package:location/location.dart';

class LocationApi {
  const LocationApi({required this.location});

  final Location location;

  Future<UserLocation?> getLocation() async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
      permission = await location.requestPermission();

      if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
        return null;
      }
    }

    final LocationData result = await location.getLocation();

    return UserLocation(lat: result.latitude ?? 0.0, long: result.longitude ?? 0.0);
  }
}
