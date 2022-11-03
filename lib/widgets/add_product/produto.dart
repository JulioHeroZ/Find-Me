import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nubankproject/firebase_services.dart';
import 'package:nubankproject/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({Key? key}) : super(key: key);

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  final FirebaseServices _services = FirebaseServices();
  String? _productImageUrl;
  final _productName = TextEditingController();
  final _regularPrice = TextEditingController();

  _saveToDB() {
    EasyLoading.show(status: 'Por favor aguarde...');

    _services
        .uploadImage(_productImage,
            'produtos/${_services.user!.uid}/${_productName.text}')
        .then((String? url) {
      if (url != null) {
        setState(() {
          _productImageUrl = url;
        });
      }
    }).then((((value) {
      _services.addProduct(data: {
        'productImage': _productImageUrl,
        'productName': _productName.text,
        'regularPrice': _regularPrice.text,
        'uid': _services.user!.uid,
        'time': DateTime.now()
      }).then(((value) {
        EasyLoading.dismiss();
      }));
    })));
  }

  final List<String> _categorias = [];
  String? selectedCategory;

  Widget _formField({
    TextEditingController? controller,
    String? label,
    TextInputType? inputType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(label!),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
    );
  }

  @override
  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _productImage;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          Column(
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    _productImage == null
                        ? Container(
                            color: Colors.amber,
                            height: 250,
                            child: TextButton(
                              // ignore: prefer_const_constructors
                              child: Center(
                                child: Text(
                                  'Adicionar Imagem',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              onPressed: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _productImage = value;
                                  });
                                });
                              },
                            ))
                        : InkWell(
                            onTap: () {
                              _pickImage().then((value) {
                                setState(() {
                                  _productImage = value;
                                });
                              });
                            },
                            child: Container(
                              height: 240,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                image: DecorationImage(
                                    image: FileImage(
                                      File(_productImage!.path),
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              _formField(
                controller: _productName,
                label: 'Nome do produto',
                inputType: TextInputType.text,
              ),
              _formField(
                controller: _regularPrice,
                label: 'Preço regular',
                inputType: TextInputType.text,
              )
            ],
          ),
          ElevatedButton(
              onPressed: () {
                _saveToDB();
              },
              child: Text('Salvar'))
        ]),
      );
    });
  }
}
