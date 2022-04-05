import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nubankproject/services/auth_service.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:nubankproject/firebase_options.dart';

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

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find Me',
      home: MyAppBar(),
    );
  }
}
