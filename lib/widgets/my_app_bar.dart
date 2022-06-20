// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:nubankproject/Settings/settings.dart';
import 'package:nubankproject/home/home_page.dart';
import 'package:nubankproject/widgets/auth_check.dart';

// ignore: use_key_in_widget_constructors
class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          // ignore: duplicate_ignore
          appBar: AppBar(
            title: Image.asset(
              "assets/images/logo.png",
              height: 150,
              width: 200,
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 214, 166, 6),
                    Color.fromARGB(255, 226, 122, 4)
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            // ignore: prefer_const_constructors
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: [
                Tab(icon: Icon(Icons.home), text: "Home"),
                Tab(icon: Icon(Icons.face), text: "Login"),
                Tab(icon: Icon(Icons.cloud), text: "Saiba Mais"),
              ],
            ),
            titleSpacing: 20,
          ),
          body: TabBarView(children: [
            HomePage(),
            AuthCheck(),
            SettingsPage(),
          ]),
        ),
      );
}
