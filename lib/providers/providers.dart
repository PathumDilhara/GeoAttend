import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/models/position_data.dart';
import 'package:geo_attend/models/user_model.dart';
import 'package:geo_attend/providers/attendance_notifier.dart';
import 'package:geo_attend/services/location_service.dart';
import 'package:geo_attend/services/user_service.dart';

import '../enums/att_enum.dart';


// List of all records
final attendanceListProvider =
    NotifierProvider<AttendanceNotifier, List<AttendanceModel>>(
      AttendanceNotifier.new,
    );


// Check In / Out
final currentStateProvider = Provider<AttendanceTypeEnum>((ref) {
  final records = ref.watch(attendanceListProvider);

  if (records.isEmpty) {
    return AttendanceTypeEnum.pending;
  }

  final last = records.last;
  return last.type == AttendanceTypeEnum.checkIn
      ? AttendanceTypeEnum.checkIn
      : AttendanceTypeEnum.checkOut;
});


// Last checked location
final lastLocationProvider = Provider<PositionData>((ref) {
  final records = ref.watch(attendanceListProvider);

  if (records.isEmpty) {
    return PositionData(latitude: 0.0, longitude: 0.0);
  }

  final last = records.last;
  return PositionData(latitude: last.latitude, longitude: last.longitude);
});


// Get the user data
final userProvider = Provider((ref) {
  return UserService();
});

// Get current user as async
final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final service = ref.read(userProvider);
  return service.getCurrentUser();
});

// Time second by second
final currentTimeProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    yield DateTime.now();
    await Future.delayed(Duration(seconds: 1));
  }
});
