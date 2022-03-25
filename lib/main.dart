import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';


void main() async {

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider

      ],

  
  child: MyApp(),);
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
