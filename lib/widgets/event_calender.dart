import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/task_controller.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  CalendarFormat _calenderFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  final _taskController = Get.put(TaskController());
  CalendarView _selectedView = CalendarView.timelineWeek;
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    _calendarController = CalendarController();
    _calendarController.selectedDate = DateTime.now();
    _calendarController.displayDate = DateTime.now();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildViewSelector(),
        Container(
            height: 225,
            child: Obx(() => SfCalendar(
                  todayHighlightColor: Colors.green,
                  controller: _calendarController,
                  appointmentTextStyle: TextStyle(fontSize: 20),
                  minDate: DateTime.utc(2023),
                  view: _selectedView,
                  dataSource: _taskController.getCalendarDataSource(),
                ))),
      ],
    );
  }

  Widget buildViewSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: DropdownButton<CalendarView>(
        value: _selectedView,
        onChanged: (newView) {
          setState(() {
            _selectedView = newView!;
            _calendarController.view = _selectedView;
          });
        },
        items: [
          DropdownMenuItem(
            value: CalendarView.timelineWeek,
            child: Text('Week View'),
          ),
          DropdownMenuItem(
            value: CalendarView.timelineDay,
            child: Text('Day View'),
          ),
          DropdownMenuItem(
            value: CalendarView.month,
            child: Text('Month View'),
          ),
          // Add more options for different views here...
        ],
      ),
    );
  }
}
