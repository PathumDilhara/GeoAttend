import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/models/attendance_model.dart';

class AttendanceNotifier extends Notifier<List<AttendanceModel>> {
  @override
  List<AttendanceModel> build() {
    return [];
  }

  List<AttendanceModel> get recentThree =>
      state.reversed.take(3).toList();

  // Check In
  void checkIn() {
    final record = AttendanceModel(
      type: "Check In",
      dateTime: DateTime.now(),
      latitude: 6.9271,
      longitude: 79.8612,
    );

    state = [...state, record];
  }

  // Check Out
  void checkOut() {
    final record = AttendanceModel(
      type: "Check Out",
      dateTime: DateTime.now(),
      latitude: 6.9271,
      longitude: 79.8612,
    );

    state = [...state, record];
  }
}
