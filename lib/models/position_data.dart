class PositionData {
  final double latitude;
  final double longitude;

  PositionData({required this.latitude, required this.longitude});

  factory PositionData.empty(){
    return PositionData(latitude: 0.0, longitude: 0.0);
  }
}
