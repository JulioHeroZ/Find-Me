// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nubankproject/RegisterStore/registration_screen.dart';
import 'package:nubankproject/firebase_services.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';

import '../Login/login.dart';
import '../model/vendor_model.dart';
import '../product/product_register.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: _services.vendedor.doc(_services.user!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.data!.exists) {
          return RegistrationScreen();
        }

        Vendedor vendedor =
            Vendedor.fromJson(snapshot.data!.data() as Map<String, dynamic>);
        if (vendedor.aprovado == true) {
          return ProductRegister();
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: vendedor.logo!,
                          placeholder: ((context, url) => Container(
                                height: 80,
                                width: 80,
                                color: Colors.grey.shade300,
                              )),
                        ))),
                SizedBox(
                  height: 10,
                ),
                Text(
                  vendedor.businessName!,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  'Tela de espera \n Sua loja esta em fase de aprovação, logo o administrador irá entrar em contato',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)))),
                  child: const Text('Voltar a tela inicial'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => MyAppBar(),
                    ));
                  },
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
