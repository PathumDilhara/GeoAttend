import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_attend/enums/att_enum.dart';
import 'package:geo_attend/providers/providers.dart';
import 'package:geo_attend/router/router_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(attendanceListProvider);

    return Scaffold(
      appBar: AppBar(title: Text("History")),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];

          return Column(
            children: [
              ListTile(
                title: Text(
                  item.type.name.toString(),
                  style: TextStyle(
                    color: item.type == AttendanceTypeEnum.checkIn ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(DateFormat("DD MMMM yyyy").format(item.date)),
                onTap: () {
                  GoRouter.of(
                    context,
                  ).push("/${RouterPaths.details}", extra: item);
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
