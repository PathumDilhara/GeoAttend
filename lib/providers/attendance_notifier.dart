import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/enums/att_enum.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/providers/providers.dart';
import 'package:uuid/uuid.dart';

import '../services/location_service.dart';

class AttendanceNotifier extends Notifier<List<AttendanceModel>> {
  @override
  List<AttendanceModel> build() {
    return [];
  }

  List<AttendanceModel> get recentThree =>
      state.reversed.take(3).toList();

  // Check In
  Future<void> checkIn() async {

    final user = ref.read(currentUserProvider).value;
    String name = user !=null ? user.userName : "";

    final service = LocationService();
    final pos = await service.getCurrentLocation();

    final record = AttendanceModel(
      id: Uuid().v4(),
      employeeName: name,
      type: AttendanceTypeEnum.checkIn,
      date: DateTime.now(),
      latitude: pos.latitude,
      longitude: pos.longitude,
    );

    state = [...state, record];
  }

  // Check Out
  Future<void> checkOut() async {
    final user = ref.read(currentUserProvider).value;
    String name = user !=null ? user.userName : "";

    final service = LocationService();
    final pos = await service.getCurrentLocation();


    final record = AttendanceModel(
      id: Uuid().v4(),
      employeeName: name,
      type: AttendanceTypeEnum.checkOut,
      date: DateTime.now(),
      latitude: pos.latitude,
      longitude: pos.longitude,
    );

    state = [...state, record];
  }
}
