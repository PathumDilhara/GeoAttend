import 'dart:math';

import '../models/position_data.dart';

class LocationService{

  // get current location
  Future<PositionData> getCurrentLocation()async{
    return PositionData(latitude: getValue(), longitude: getValue());
  }

  // random
  double getValue(){
    final random = Random();

    double min = 10.0;
    double max = 200.0;

    double value = min + random.nextDouble() * (max - min);
    return value;
  }
}