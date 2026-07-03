import 'package:geo_attend/models/attendance_model.dart';
import 'package:geo_attend/router/router_paths.dart';
import 'package:geo_attend/screens/history_screen.dart';
import 'package:geo_attend/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/details_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/${RouterPaths.home}",
    routes: [
      // home
      GoRoute(
        path: "/${RouterPaths.home}",
        builder: (context, state) => HomeScreen(),
      ),

      // History
      GoRoute(
        path: "/${RouterPaths.history}",
        builder: (context, state) => HistoryScreen(),
      ),

      // Detailed screen
      GoRoute(
        path: "/${RouterPaths.details}",
        builder:  (context, state) {
          final model = state.extra as AttendanceModel;
          return DetailsScreen(model: model);
        },
      ),
    ],
  );
}
