import 'package:flutter/material.dart';
import 'package:nubankproject/services/auth_service.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: OutlinedButton(
                  onPressed: () => context.read<AuthService>().logout(),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Sair do App',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        )),
      ),
    ));
  }
}
