import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
        Container(
            color: Color.fromARGB(255, 12, 102, 221),
            height: 100,
            child: Row(
              children: <Widget>[
                Image.asset('assets/images/logo.png'),
                SizedBox(
                  width: 10,
                ),
              ],
            )),
      ],
    );
  }
}
