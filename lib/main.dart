// ignore_for_file: prefer_const_constructors

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:nubankproject/provider/product_provider.dart';
import 'package:nubankproject/services/auth_service.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:nubankproject/firebase_options.dart';
import 'constants.dart';
import 'package:flutter/services.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        Provider<ProductProvider>(
          create: (context) => ProductProvider(),
        )
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
        .pushReplacement(MaterialPageRoute(builder: (context) => MyAppBar())));
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
      initTheme: kLightTheme,
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(400, 360),
            builder: (BuildContext context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: kLightTheme,
              title: 'Find Me',
              home: SplashScreen(),
              builder: EasyLoading.init(),
            ),
          );
        },
      ),
    );
  }
}
