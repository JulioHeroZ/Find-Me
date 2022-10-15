// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:nubankproject/Login/login.dart';
import 'package:nubankproject/widgets/auth_check.dart';
import '../constants.dart';
import '../widgets/profile_list_item.dart';

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(top: 10 * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 10 * 5,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 10 * 2.5,
                    width: 10 * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: 10 * 1.5,
                      widthFactor: 10 * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: 10 * 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10 * 2),
          SizedBox(height: 10 * 0.5),
          // Text(
          //   user.email!,
          //   style: kTitleTextStyle,
          // ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthCheck()));
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(500, 50),
                  primary: kAccentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text(
                "Possui uma loja? Cadastre-se aqui!",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                profileInfo,
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ProfileListItem(
                        icon: LineAwesomeIcons.question_circle,
                        text: 'Ajuda e Suporte Técnico',
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.cog,
                        text: 'Configurações',
                      ),
                      Container(
                        margin: const EdgeInsets.all(40.0),
                        child: user == null
                            ? ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AuthCheck()));
                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(0, 50),
                                    primary: kAccentColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  _signOut();
                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(0, 50),
                                    primary: kAccentColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: Text(
                                  "Sair",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
