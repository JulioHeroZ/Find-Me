import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:nubankproject/Login/login.dart';
import 'package:nubankproject/services/auth_service.dart';
import 'package:nubankproject/widgets/auth_check.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:nubankproject/firebase_options.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MyApp(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value) => Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => AuthCheck())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        height: 200.0,
        width: 200.0,
        child: LottieBuilder.asset('assets/animassets/mapanimation.json'),
      ),
    ));
  }
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: kDarkTheme,
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(400, 360),
            builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: kDarkTheme,
              title: 'Find Me',
              home: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
