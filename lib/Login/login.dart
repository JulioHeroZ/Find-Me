import 'package:flutter/material.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color.fromARGB(255, 214, 166, 6),
              Color.fromARGB(255, 226, 122, 4)
            ]),
      ),
    );
  }
}
