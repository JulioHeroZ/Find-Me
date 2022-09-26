import 'package:flutter/material.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _businessName = TextEditingController();

  Widget _formField(
      {TextEditingController? controller, String? label, TextInputType? type}) {
    return TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                Container(
                  color: Colors.amber,
                  height: 250,
                  child: Center(
                    child: Text(
                      'Aperte para adicionar a imagem da loja',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                    height: 80,
                    child: AppBar(
                      elevation: 0,
                      actions: [
                        IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MyAppBar(),
                              ),
                            );
                          },
                        ),
                      ],
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children: [
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Text(
                            '+',
                            style: TextStyle(fontSize: 30, color: Colors.amber),
                          )),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                children: [
                  _formField(
                      controller: _businessName,
                      label: 'Nome da loja',
                      type: TextInputType.phone)
                ],
              ))
        ],
      ),
    );
  }
}
