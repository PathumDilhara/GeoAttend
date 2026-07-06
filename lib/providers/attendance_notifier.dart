import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/enums/att_enum.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:uuid/uuid.dart';

class AttendanceNotifier extends Notifier<List<AttendanceModel>> {
  @override
  List<AttendanceModel> build() {
    return [];
  }

  List<AttendanceModel> get recentThree =>
      state.reversed.take(3).toList();

  // Check In
  void checkIn({
    required String employeeName,
    required double latitude,
    required double longitude
}) {
    final record = AttendanceModel(
      id: Uuid().v4(),
      employeeName: employeeName,
      type: AttendanceTypeEnum.checkIn,
      date: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );

    state = [...state, record];
  }

  // Check Out
  void checkOut({
    required String employeeName,
    required double latitude,
    required double longitude
}) {
    final record = AttendanceModel(
      id: Uuid().v4(),
      employeeName: employeeName,
      type: AttendanceTypeEnum.checkOut,
      date: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );

    state = [...state, record];
  }
}
