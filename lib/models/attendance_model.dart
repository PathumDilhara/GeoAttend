import 'package:geo_attend/enums/att_enum.dart';

class AttendanceModel {
  final String id;
  final String employeeName;
  final AttendanceTypeEnum type;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  AttendanceModel({
    required this.id,
    required this.employeeName,
    required this.type,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });
}
