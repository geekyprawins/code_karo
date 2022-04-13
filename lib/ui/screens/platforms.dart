import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

class PlatformsScreen extends StatefulWidget {
  const PlatformsScreen({Key? key}) : super(key: key);

  @override
  _PlatformsScreenState createState() => _PlatformsScreenState();
}

class _PlatformsScreenState extends State<PlatformsScreen> {
  List<String> platforms = [];
  void getPlatforms() async {
    final dio = Dio();
    try {
      var response = await dio.get("https://kontests.net/api/v1/sites");
      var resArray = response.data.toList();
      print(resArray);
      // List<String> platforms = [];
      for (var i = 0; i < resArray.length; i++) {
        platforms.add(resArray[i][0].toString());
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
    getPlatforms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Platforms"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: (platforms.isEmpty)
              ? const CircularProgressIndicator()
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.teal.withOpacity(0.8),
                      width: 150,
                      height: 75,
                      child: Center(child: Text(platforms[index])),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: platforms.length),
        ),
      ),
    );
  }
}
