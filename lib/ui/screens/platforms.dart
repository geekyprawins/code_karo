import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:code_karo/ui/screens/events.dart';
import 'package:code_karo/ui/screens/local_notifs.dart';
import 'package:code_karo/ui/screens/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class PlatformsScreen extends StatefulWidget {
  const PlatformsScreen({Key? key}) : super(key: key);

  @override
  _PlatformsScreenState createState() => _PlatformsScreenState();
}

class _PlatformsScreenState extends State<PlatformsScreen> {
  List<Map<String, String>> platforms = [];

  late ConfettiController _confettiController;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  void getPlatforms() async {
    if (_connectionStatus == ConnectivityResult.none) return;
    final dio = Dio();
    try {
      var response = await dio.get("https://kontests.net/api/v1/sites");
      var resArray = response.data.toList();
      // print(resArray);
      for (var i = 0; i < resArray.length; i++) {
        Map<String, String> myPlatform = {
          resArray[i][0].toString(): resArray[i][1].toString()
        };
        platforms.add(myPlatform);
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

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        // print(isAllowed);
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );

    getPlatforms();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _confettiController.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus != ConnectivityResult.none) {
        getPlatforms();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Platforms"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          children: [
            Center(
              child: (_connectionStatus == ConnectivityResult.none)
                  ? Center(
                      child: Container(
                        child: const Center(child: Text("You're offline!")),
                        color: Colors.pink,
                        width: 200,
                        height: 75,
                      ),
                    )
                  : (platforms.isEmpty)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            String platformName =
                                platforms[index].keys.elementAt(0);
                            String? platformCode =
                                platforms[index][platformName];
                            return GestureDetector(
                              child: Container(
                                color: Colors.teal.withOpacity(0.8),
                                width: 150,
                                height: 75,
                                child: Center(
                                  child: Text(platformName),
                                ),
                              ),
                              onTap:
                                  // LocalNotifs.createDummyNotif,
                                  //     () {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           EventsScreen(platformCode: platformCode!),
                                  //     ),
                                  //   );
                                  // },

                                  () async {
                                NotificationWeekAndTime? pickedSchedule =
                                    await pickSchedule(context);

                                if (pickedSchedule != null) {
                                  LocalNotifs.createWaterReminderNotification(
                                          pickedSchedule)
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
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: platforms.length,
                        ),
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
            )
          ],
        ),
      ),
    );
  }
}
