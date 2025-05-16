import 'package:location/location.dart';

Future<bool> checkLocationPerm() async {
  Location location = Location();

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return false;
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return false;
  }

  return true;
}

Future<LocationData?> getCurrentLocation() async {
  Location location = Location();

  bool hasPerm = await checkLocationPerm();
  if (hasPerm) {
    LocationData locationData = await location.getLocation();
    print(
        'Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');
    return locationData;
  } else {
    return null;
  }
}
