import 'package:flutter/material.dart';
import 'package:nubankproject/Login/login.dart';
import 'package:nubankproject/Settings/Settings.dart';
import 'package:nubankproject/home/home_page.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find Me',
      home: MyAppBar(),
    );
  }
}
