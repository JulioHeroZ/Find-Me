import 'package:flutter/material.dart';
import 'package:nubankproject/home/widgets/my_app_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            MyAppBar(),
          ],
        ));
  }
}
