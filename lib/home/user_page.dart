// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants.dart';
import '../widgets/profile_list_item.dart';

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            'juliohero64@gmail.com',
            style: kTitleTextStyle,
          ),
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
                      ProfileListItem(
                        icon: LineAwesomeIcons.alternate_sign_out,
                        text: 'Logout',
                        hasNavigation: false,
                      ),
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
