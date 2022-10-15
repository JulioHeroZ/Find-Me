// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:nubankproject/provider/product_provider.dart';
import 'package:nubankproject/widgets/add_product/produto.dart';
import 'package:nubankproject/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class ProductRegister extends StatefulWidget {
  const ProductRegister({Key? key}) : super(key: key);

  @override
  State<ProductRegister> createState() => _ProductRegisterState();
}

class _ProductRegisterState extends State<ProductRegister> {
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

  static const String id = 'add-product-screen';

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    return WillPopScope(
        onWillPop: () async => _onWillPop(context),
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Adicionar novos produtos'),
              bottom: TabBar(isScrollable: true, tabs: [
                Tab(
                  child: Text(
                    'Produto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    'Imagens',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ]),
            ),
            body: TabBarView(children: [
              ProductTab(),
              Center(
                child: Text('Imagens'),
              )
            ]),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      print(_provider.productData!['productName']);
                      print(_provider.productData!['regularPrice']);
                    },
                    child: Text('Salvar')),
              )
            ],
          ),
        ));
  }
}
