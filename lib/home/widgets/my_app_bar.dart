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
            color: Color.fromARGB(255, 20, 8, 126),
            height: 100,
            child: Row(
              children: <Widget>[
                Image.network(
                    'https://drive.google.com/file/d/1Uqo4R0aOeHImOirhMFYWDSD99VAqLwg3/view?usp=sharing'),
                SizedBox(
                  width: 10,
                ),
              ],
            )),
      ],
    );
  }
}
