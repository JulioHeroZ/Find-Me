// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:nubankproject/Settings/settings.dart';
import 'package:nubankproject/home/home_page.dart';

import '../home/user_page.dart';

// ignore: use_key_in_widget_constructors
class MyAppBar extends StatefulWidget {
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  final screens = [ProfileScreen(), HomePage(), SettingsPage()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) => Scaffold(

      // ignore: duplicate_ignore
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 204, 150, 3),
        title: Image.asset(
          "assets/images/logo.png",
          height: 150,
          width: 200,
        ),
        centerTitle: true,
      ),
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Profile',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Saiba Mais',
            backgroundColor: Colors.purple,
          ),
        ],
      ));
}
