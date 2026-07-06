import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/enums/att_enum.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/router/router_paths.dart';
import 'package:geo_attend/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import '../services/location_service.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  double cardBR = 15;
  double mainPad = 16;

  ValueNotifier<bool> isFetching = ValueNotifier(false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(title: Text("GeoAttend")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Employee data card + check in/out card
            SizedBox(
              height: screenHeight * 0.30,
              child: Stack(
                children: [
                  // Employee data card
                  _buildEmployeeInformationCard(screenHeight, ref),

                  // Check in checkout card
                  Positioned(
                    bottom: 0,
                    left: 10,
                    right: 10,
                    child: _buildCheckInOutCard(context, screenHeight, ref),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // current state showing
            _buildCurrentStateCard(screenHeight, ref),

            // Recent history
            _buildRecentHistoryCard(context, screenHeight, ref),
          ],
        ),
      ),
    );
  }

  // ======================== Employe information card =============
  Widget _buildEmployeeInformationCard(double screenHeight, WidgetRef ref) {
    final currentTime = ref.watch(currentTimeProvider);

    final userAsync = ref.watch(currentUserProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      width: double.infinity,
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(cardBR),
          bottomRight: Radius.circular(cardBR),
        ),
        color: Colors.orange,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // User profile icon
          SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "assets/images/profile.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20),

          // user name and other data
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userAsync.when(
                  data: (user) => user.userName,
                  error: (_, _) => "Error",
                  loading: () => "Loading...",
                ),
                softWrap: true,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 3),

              // Today date
              Text(
                DateFormat('dd MMMM yyyy').format(DateTime.now()),
                softWrap: true,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.9),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 3),

              // current live time
              Text(
                currentTime.when(
                  data: (time) => DateFormat('hh:mm:ss a').format(time),
                  error: (error, stackTrace) => "Error",
                  loading: () => "__:__:__",
                ),
                softWrap: true,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.9),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== Check in out card =============================
  Widget _buildCheckInOutCard(
    BuildContext context,
    double screenHeight,
    WidgetRef ref,
  ) {
    final currentState = ref.watch(currentStateProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      width: double.infinity,
      height: screenHeight * 0.13,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBR),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customButton(
            title: "Check In",
            bgColor:
                currentState == AttendanceTypeEnum.checkOut ||
                        currentState == AttendanceTypeEnum.pending
                    ? Colors.green
                    : Colors.grey,
            onTap: () async {
              if (context.mounted) {
                loadingDialog(context);
              }

              if (currentState == AttendanceTypeEnum.checkOut ||
                  currentState == AttendanceTypeEnum.pending) {
                final user = ref.read(currentUserProvider).value;
                if (user == null) return;

                final service = LocationService();
                final pos = await service.getCurrentLocation();

                if (context.mounted) {
                  Navigator.pop(context);
                }

                ref
                    .read(attendanceListProvider.notifier)
                    .checkIn(
                      employeeName: user.userName,
                      latitude: pos.latitude,
                      longitude: pos.longitude,
                    );
              }
            },
          ),
          SizedBox(width: 20),
          customButton(
            title: "Check Out",
            bgColor:
                currentState == AttendanceTypeEnum.checkOut ||
                        currentState == AttendanceTypeEnum.pending
                    ? Colors.grey
                    : Colors.red,
            onTap: () async {
              if (context.mounted) {
                loadingDialog(context);
              }

              if (currentState == AttendanceTypeEnum.checkIn) {
                final user = ref.read(currentUserProvider).value;
                if (user == null) return;

                final service = LocationService();
                final pos = await service.getCurrentLocation();

                if (context.mounted) {
                  Navigator.pop(context);
                }

                ref
                    .read(attendanceListProvider.notifier)
                    .checkOut(
                      employeeName: user.userName,
                      latitude: pos.latitude,
                      longitude: pos.longitude,
                    );
              }
            },
          ),
        ],
      ),
    );
  }

  // ================================ Current state card ======================
  Widget _buildCurrentStateCard(double screenHeight, WidgetRef ref) {
    final currentState = ref.watch(currentStateProvider);
    final lastLocation = ref.watch(lastLocationProvider);

    return Container(
      margin: EdgeInsets.all(mainPad),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: screenHeight * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBR),
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status : ${currentState.name.toString()}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color:
                  currentState == AttendanceTypeEnum.checkIn
                      ? Colors.green
                      : Colors.red,
            ),
          ),
          SizedBox(height: 10),

          Text(
            "Last Location :  ${lastLocation.latitude}, ${lastLocation.longitude}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // =================== Attendance recent history ======================
  Widget _buildRecentHistoryCard(
    BuildContext context,
    double screenHeight,
    WidgetRef ref,
  ) {
    final recentList = ref.watch(attendanceListProvider.notifier).recentThree;

    return Container(
      margin: EdgeInsets.all(mainPad),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      // height: screenHeight * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBR),
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent History",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),

          if (recentList.isEmpty)
            Center(
              child: Text(
                "There is not record to show",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    color: Colors.grey.shade200,
                    child: SizedBox(
                      height: screenHeight * 0.25,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: recentList.length,
                        itemBuilder: (context, index) {
                          AttendanceModel item = recentList[index];

                          return Column(
                            children: [
                              ListTile(
                                tileColor: Colors.grey.shade200,
                                title: Text(
                                  item.type.name.toString(),
                                  style: TextStyle(
                                    color:
                                        item.type == AttendanceTypeEnum.checkIn
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat(
                                    "DD MMMM yyyy",
                                  ).format(item.dateTime),
                                ),
                                onTap: () {
                                  GoRouter.of(context).push(
                                    "/${RouterPaths.details}",
                                    extra: item,
                                  );
                                },
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                customButton(
                  title: "see all",
                  bgColor: Colors.green,
                  onTap: () {
                    GoRouter.of(context).push("/${RouterPaths.history}");
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  void loadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Location fetching", style: TextStyle(fontSize: 20)),
              Divider(),
            ],
          ),
          content: SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          ),
        );
      },
    );
  }
}
