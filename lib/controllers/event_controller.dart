import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/task.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Task> source) {
    appointments = source;
  }

  @override
  DateTime getEndTime(int index) {
    String dateString = appointments![index].date;
    DateTime parsedDate = DateFormat("M/d/yyyy").parse(dateString);
    return parsedDate;
  }

  String getTitle(int index) {
    return appointments![index].title;
  }
}
