import 'package:appointment/db/db_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/task.dart';
import '../services/notification_services.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    print("add task called");
    return await DBHelper.insert(task!);
  }

//get all data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
    for (Task task in taskList) {
      NotificationService.scheduleNotification(task);
    }
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
    getCalendarDataSource();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  CalendarDataSource getCalendarDataSource() {
    List<Appointment> appointments = [];
    for (Task task in taskList) {
      // Parse date with format 'M/d/yyyy h:mm a'
      DateTime startDate =
          DateFormat('M/d/yyyy h:mm a').parse('${task.date} ${task.startTime}');
      DateTime endDate =
          DateFormat('M/d/yyyy h:mm a').parse('${task.date} ${task.endTime}');
      appointments.add(Appointment(
        id: task.id.toString(),
        subject: task.title ?? 'No Title',
        startTime: startDate,
        endTime: endDate,
      ));
    }
    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
