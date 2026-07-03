import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/providers/attendance_notifier.dart';

final attendanceProvider =
    NotifierProvider<AttendanceNotifier, List<AttendanceModel>>(
      AttendanceNotifier.new,
    );

final currentTimeProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    yield DateTime.now();
    await Future.delayed(Duration(seconds: 1));
  }
});
