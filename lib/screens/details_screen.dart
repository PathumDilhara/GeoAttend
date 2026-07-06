import 'package:flutter/material.dart';
import 'package:geo_attend/enums/att_enum.dart';
import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/utils/date_time_formatter.dart';

class DetailsScreen extends StatelessWidget {
  final AttendanceModel model;
  const DetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.type.name.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color:
                    model.type == AttendanceTypeEnum.checkIn
                        ? Colors.green
                        : Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              dateFormatter(model.date),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              "latitude : ${model.latitude.toString()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              "longitude : ${model.longitude.toString()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
