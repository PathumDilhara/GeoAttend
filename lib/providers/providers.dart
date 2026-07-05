import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/models/position_data.dart';
import 'package:geo_attend/models/user_model.dart';
import 'package:geo_attend/providers/attendance_notifier.dart';
import 'package:geo_attend/services/user_service.dart';

import '../enums/att_enum.dart';

final attendanceListProvider =
    NotifierProvider<AttendanceNotifier, List<AttendanceModel>>(
      AttendanceNotifier.new,
    );

final currentStateProvider = Provider<AttendanceTypeEnum>((ref) {
  final records = ref.watch(attendanceListProvider);

  if (records.isEmpty) {
    return AttendanceTypeEnum.checkOut;
  }

  final last = records.last;
  return last.type == AttendanceTypeEnum.checkIn
      ? AttendanceTypeEnum.checkIn
      : AttendanceTypeEnum.checkOut;
});

final lastLocationProvider = Provider<PositionData>((ref) {
  final records = ref.watch(attendanceListProvider);

  if (records.isEmpty) {
    return PositionData(latitude: 0.0, longitude: 0.0);
  }

  final last = records.last;
  return PositionData(latitude: last.latitude, longitude: last.longitude);
});

final userProvider = Provider((ref) {
  return UserService();
});

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final service = ref.read(userProvider);
  return service.getCurrentUser();
});

final currentTimeProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    yield DateTime.now();
    await Future.delayed(Duration(seconds: 1));
  }
});
