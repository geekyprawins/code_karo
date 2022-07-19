import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}

Future<NotificationWeekAndTime?> pickSchedule(BuildContext context,
    {required String startTime}) async {
  List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  TimeOfDay? timeOfDay;
  DateTime eventTime = DateTime.parse(startTime).toLocal();
  int? selectedDay;
  DateTime? contestDay;

  // await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text(
  //           'I want to be reminded every:',
  //           textAlign: TextAlign.center,
  //         ),
  //         content: Wrap(
  //           alignment: WrapAlignment.center,
  //           spacing: 3,
  //           children: [
  //             for (int index = 0; index < weekdays.length; index++)
  //               ElevatedButton(
  //                 onPressed: () {
  //                   selectedDay = index + 1;
  //                   Navigator.pop(context);
  //                 },
  //                 style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(
  //                     Colors.teal,
  //                   ),
  //                 ),
  //                 child: Text(weekdays[index]),
  //               ),
  //           ],
  //         ),
  //       );
  //     });

  contestDay = await showDatePicker(
    context: context,
    initialDate: DateTime.parse(startTime).toLocal(),
    firstDate: DateTime(DateTime.now().year),
    lastDate: DateTime(DateTime.now().year + 1),
  );

  if (contestDay != null) {
    print("Day of week is : ${contestDay.weekday}");
    timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          eventTime.subtract(
            const Duration(minutes: 30),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Colors.teal,
              ),
            ),
            child: child!,
          );
        });

    if (timeOfDay != null) {
      return NotificationWeekAndTime(
        dayOfTheWeek: contestDay.weekday,
        timeOfDay: timeOfDay,
      );
    }
  }
  return null;
}
