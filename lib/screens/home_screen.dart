import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/widgets/custom_button.dart';
import 'package:intl/intl.dart';

import '../providers/attendance_provider.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  double cardBR = 15;

  double mainPad = 16;

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
              height: screenHeight * 0.35,
              child: Stack(
                children: [
                  // Employee data card
                  _buildEmployeeInformationCard(screenHeight, ref),

                  // Check in checkout card
                  Positioned(
                    bottom: 0,
                    left: 10,
                    right: 10,
                    child: _buildCheckInOutCard(screenHeight, ref),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),

            // current state showing
            _buildCurrentStateCard(screenHeight),

            // Recent history
            _buildRecentHistoryCard(screenHeight, ref),
          ],
        ),
      ),
    );
  }

  // ======================== Employe information card =============
  Widget _buildEmployeeInformationCard(double screenHeight, WidgetRef ref) {
    final currentTime = ref.watch(currentTimeProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      width: double.infinity,
      height: screenHeight * 0.3,
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
                "John Doe",
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
  Widget _buildCheckInOutCard(double screenHeight, WidgetRef ref) {
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
            bgColor: Colors.green,
            onTap: () {
              ref.read(attendanceProvider.notifier).checkIn();
            },
          ),
          SizedBox(width: 20),
          customButton(
            title: "Check Out",
            bgColor: Colors.red,
            onTap: () {
              ref.read(attendanceProvider.notifier).checkOut();
            },
          ),
        ],
      ),
    );
  }

  // ================================ Current state card ======================
  Widget _buildCurrentStateCard(double screenHeight) {
    return Container(
      margin: EdgeInsets.all(mainPad),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: screenHeight * 0.2,
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
            "Status : Checked In", // TODO
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),

          Text(
            "Last Location :  6.92, 79.86", // TODO
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
  Widget _buildRecentHistoryCard(double screenHeight, WidgetRef ref) {
    final recentList = ref.watch(attendanceProvider.notifier).recentThree;

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
            Stack(
              children: [
                Material(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.grey.shade200,
                  child: SizedBox(
                    height: screenHeight * 0.2,
                    child: ListView.builder(
                      itemCount: recentList.length,
                      itemBuilder: (context, index) {
                        AttendanceModel item = recentList[index];

                        return Column(
                          children: [
                            ListTile(
                              tileColor: Colors.grey.shade200,
                              title: Text(item.type),
                              subtitle: Text(item.dateTime.toString()),
                              onTap: () {
                                // TODO : go to details page
                              },
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 50,
                  right: 50,
                  child: customButton(
                    title: "more",
                    bgColor: Colors.green,
                    onTap: () {
                      // TODO : anv to histy page
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
