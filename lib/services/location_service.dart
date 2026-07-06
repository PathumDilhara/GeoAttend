import 'dart:math';

import 'package:geolocator/geolocator.dart';

import '../models/position_data.dart';

class LocationService {
  Future<PositionData> getCurrentLocation() async {
    try {
      print("### Location info getting");

      bool granted = await permissionHandler();

      if (!granted) return PositionData.empty();

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return PositionData(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return PositionData(latitude: getValue(), longitude: getValue());
    }
  }

  // Permission handler
  Future<bool> permissionHandler() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print("Location services are disabled");
      // throw Exception('Location services are disabled.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // throw Exception('Location permission denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // throw Exception('Location permission permanently denied.');
      return false;
    }

    return true;
  }

  // random
  double getValue() {
    final random = Random();

    double min = 10.0;
    double max = 200.0;

    double value = min + random.nextDouble() * (max - min);
    return value;
  }

  // get current location
  // Future<PositionData> getCurrentLocation() async {
  //   return PositionData(latitude: getValue(), longitude: getValue());
  // }
}
