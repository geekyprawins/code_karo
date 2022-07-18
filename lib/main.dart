import 'package:code_karo/ui/screens/platforms.dart';
import 'package:code_karo/ui/utils/notifs_init.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  notifsInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Code Karo',
      theme: ThemeData.dark(),
      home: const PlatformsScreen(),
    );
  }
}
