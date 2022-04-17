import 'package:code_karo/ui/screens/open_links.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key, required this.platformCode}) : super(key: key);

  final String platformCode;

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Map<String, String>> events = [];
  void getEvents() async {
    final dio = Dio();
    try {
      var response =
          await dio.get("https://kontests.net/api/v1/${widget.platformCode}");
      var resArray = response.data.toList();
      // print(resArray);
      for (var i = 0; i < resArray.length; i++) {
        Map<String, String> myEvent = {
          resArray[i]["name"].toString(): resArray[i]["url"].toString()
        };
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events at ${widget.platformCode}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: (events.isEmpty)
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    String eventName = events[index].keys.elementAt(0);
                    String? eventURL = events[index][eventName];
                    return GestureDetector(
                      child: Container(
                        color: Colors.teal.withOpacity(0.8),
                        width: 150,
                        height: 75,
                        child: Center(
                          child: Text(eventName),
                        ),
                      ),
                      onTap: () {
                        OpenLinks.openLink(url: eventURL!);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: events.length),
        ),
      ),
    );
  }
}
