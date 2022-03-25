import 'package:flutter/material.dart';
import 'package:nubankproject/Login/login.dart';
import 'package:nubankproject/Settings/Settings.dart';
import 'package:nubankproject/home/home_page.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
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
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: [
                Tab(icon: Icon(Icons.home), text: "Home"),
                Tab(icon: Icon(Icons.face), text: "Login"),
                Tab(icon: Icon(Icons.settings), text: "Config."),
              ],
            ),
            titleSpacing: 20,
          ),
          body: TabBarView(children: [
            HomePage(),
            Login(),
            Settings(),
          ]),
        ),
      );
}