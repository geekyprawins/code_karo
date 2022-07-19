import 'package:code_karo/ui/screens/open_links.dart';
import 'package:code_karo/ui/screens/utils.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'event_info.dart';
import 'local_notifs.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key, required this.platformCode}) : super(key: key);

  final String platformCode;

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventInfo> events = [];

  late ConfettiController _confettiController;

  void getEvents() async {
    final dio = Dio();
    try {
      var response =
          await dio.get("https://kontests.net/api/v1/${widget.platformCode}");
      var resArray = response.data.toList();
      // print(resArray);
      for (var i = 0; i < resArray.length; i++) {
        EventInfo myEvent = EventInfo.fromJson(resArray[i]);
        events.add(myEvent);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEvents();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events at ${widget.platformCode}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(children: [
          Center(
            child: (events.isEmpty)
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      String eventName = events[index].eventName;
                      String? eventURL = events[index].eventURL;
                      String startTime = events[index].startTime;
                      String startDay =
                          DateTime.parse(startTime).toLocal().day.toString() +
                              ' ';
                      List<String> months = [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December'
                      ];
                      String startMonth = months[
                              DateTime.parse(startTime).toLocal().month - 1] +
                          ' ';
                      String startYear =
                          DateTime.parse(startTime).toLocal().year.toString();
                      String startHr =
                          DateTime.parse(startTime).toLocal().hour.toString();
                      String startMin =
                          DateTime.parse(startTime).toLocal().minute.toString();
                      if (startMin == '0') {
                        startMin = '';
                      } else {
                        startMin = ':' + startMin;
                      }
                      String startSec =
                          DateTime.parse(startTime).toLocal().second.toString();
                      String displayDate = startDay +
                          startMonth +
                          startYear +
                          ' @ ' +
                          startHr +
                          startMin +
                          ' hrs';
                      return GestureDetector(
                        child: Container(
                          color: Colors.teal.withOpacity(0.8),
                          width: 150,
                          height: 100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(eventName),
                                Text(displayDate),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orangeAccent,
                                  ),
                                  onPressed: () async {
                                    NotificationWeekAndTime? pickedSchedule =
                                        await pickSchedule(
                                      context,
                                      startTime: startTime,
                                    );

                                    if (pickedSchedule != null) {
                                      LocalNotifs
                                              .createContestReminderNotification(
                                                  pickedSchedule,
                                                  contestName: eventName)
                                          .then((value) {
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   const SnackBar(
                                        //     content: Text(
                                        //       "Reminder created! ✌️",
                                        //       style: TextStyle(color: Colors.white),
                                        //     ),
                                        //     duration: Duration(milliseconds: 1200),
                                        //     backgroundColor: Colors.black,
                                        //   ),
                                        // );
                                        _confettiController.play();
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Set Reminder",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          OpenLinks.openLink(url: eventURL);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: events.length),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            // shouldLoop: true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            maxBlastForce: 200,
            minBlastForce: 100, // manually specify the colors to be used
            gravity: 0.7,
            numberOfParticles: 200,
            // createParticlePath: drawStar, // define a custom shape/path.
          ),
        ]),
      ),
    );
  }
}
