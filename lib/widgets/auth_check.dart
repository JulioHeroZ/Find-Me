// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nubankproject/Login/login.dart';
import 'package:nubankproject/RegisterStore/landing_screen.dart';
import 'package:nubankproject/services/auth_service.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

import '../RegisterStore/registration_screen.dart';

class AuthCheck extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    if (auth.isLoading)
      // ignore: curly_braces_in_flow_control_structures
      return loading();
    else if (auth.usuario == null)
      // ignore: curly_braces_in_flow_control_structures
      return LoginPage();
    else
      // ignore: curly_braces_in_flow_control_structures
      return LandingScreen();
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
