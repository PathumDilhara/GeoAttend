import 'package:intl/intl.dart';

String dateFormatter(DateTime date){
  return DateFormat("dd MMMM yyyy").format(date);
}

String timeFormatter(DateTime time){
  return DateFormat("hh:mm:ss a").format(time);
}