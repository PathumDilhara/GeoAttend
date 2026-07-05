// import 'package:geo_attend/enums/att_enum.dart';
//
// import '../models/attendance_model.dart';
//
// class StatusService{
//
//   AttendanceTypeEnum getCurrentStatus(List<AttendanceModel> records){
//     if (records.isEmpty) {
//       return AttendanceTypeEnum.checkOut; // default state
//     }
//
//     final last = records.last;
//
//     if (last.type == AttendanceTypeEnum.checkIn) {
//       return AttendanceTypeEnum.checkIn;
//     } else {
//       return AttendanceTypeEnum.checkOut;
//     }
//   }
// }