import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'package:nubankproject/firebase_services.dart';
import 'package:nubankproject/model/vendor_model.dart';
import 'package:nubankproject/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({Key? key}) : super(key: key);

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  @override
  void initState() {
    _fetch();
    super.initState();
  }

  _fetch() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null)
      await FirebaseFirestore.instance
          .collection('vendedor')
          .doc(user.uid)
          .get()
          .then(((value) => location2 = value.data()!["location"]));
  }

  GeoPoint? location2;
  final FirebaseServices _services = FirebaseServices();
  String? productImageUrl;
  final productName = TextEditingController();
  final regularPrice = TextEditingController();

  _saveToDB() {
    EasyLoading.show(status: 'Por favor aguarde...');

    _services
        .uploadImage(_productImage,
            'produtos/${_services.user!.uid}/${productName.text}')
        .then((String? url) {
      if (url != null) {
        setState(() {
          productImageUrl = url;
        });
      }
    }).then((((value) {
      _services.addProduct(data: {
        'productImage': productImageUrl,
        'productName': productName.text,
        'regularPrice': regularPrice.text,
        'uid': _services.user!.uid,
        'location': location2,
        'time': DateTime.now()
      }).then(((value) {
        EasyLoading.dismiss();
      }));
    })));
  }

  Widget _formField(
      {TextEditingController? controller,
      String? label,
      TextInputType? inputType,
      void Function(String)? onChanged}) {
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
      onChanged: onChanged,
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
    final _provider = Provider.of<ProductProvider>(context);

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
                  controller: productName,
                  label: 'Nome do produto',
                  inputType: TextInputType.text,
                  onChanged: (value) {
                    provider.getFormData(
                      productName: value,
                    );
                  }),
              _formField(
                  controller: regularPrice,
                  label: 'Preço regular',
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    provider.getFormData(
                      regularPrice: (value),
                    );
                  })
            ],
          ),
          ElevatedButton(
              onPressed: () {
                print(_provider.productData!);
                _saveToDB();
              },
              child: Text('Salvar'))
        ]),
      );
    });
  }
}
