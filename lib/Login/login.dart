// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nubankproject/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../widgets/my_app_bar.dart';

class LoginPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao login';
      }
    });
  }

  login() async {
    setState(() => loading = true);

    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().registrar(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Por favor confirme'),
      content: const Text('Você quer voltar a tela anterior?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Não'),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyAppBar()),
          ),
          child: Text('Sim'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                          color: Color.fromARGB(255, 214, 166, 6),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.5,
                        ),
                      ),
                      /*-------------------Email------------------------------*/
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe o email corretamente!';
                            }
                            return null;
                          },
                        ),
                      ),
                      /*-------------------Senha-----------------------------*/
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        child: TextFormField(
                          controller: senha,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Senha',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe sua senha';
                            } else if (value.length < 6) {
                              return 'Sua senha deve ter no minimo 6 caracteres';
                            }
                            return null;
                          },
                        ),
                      ),
                      /*-----------------Login--------------------------------*/
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                Color.fromARGB(255, 56, 56, 56), // background
                            onPrimary: Color.fromARGB(255, 214, 166, 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            // foreground
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (isLogin) {
                                login();
                              } else {
                                registrar();
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (loading)
                                ? [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ]
                                : [
                                    Icon(Icons.check),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        actionButton,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              primary: Color.fromARGB(255, 214, 166, 6)),
                          onPressed: () => setFormAction(!isLogin),
                          child: Text(toggleButton))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
