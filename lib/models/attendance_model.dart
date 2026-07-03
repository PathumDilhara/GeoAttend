class AttendanceModel {
  final String type;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  AttendanceModel({
    required this.type,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });
}
