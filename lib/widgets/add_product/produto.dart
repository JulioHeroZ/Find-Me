import 'dart:io';

import 'package:flutter/material.dart';
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
  final List<String> _categorias = [];
  String? selectedCategory;

  Widget _formField(
      {String? label,
      TextInputType? inputType,
      required Null Function(dynamic value) onChanged}) {
    return TextFormField(
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

  Widget _categoryDropDown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: const Text(
        'Selecione a categoria',
        style: TextStyle(fontSize: 18),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          selectedCategory = value!;
        });
      },
      items: _categorias.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categorias.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categorias.add(element['catName']);
        });
      });
    });
  }

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
                    label: 'Nome do produto',
                    inputType: TextInputType.name,
                    onChanged: (value) {
                      provider.getFormData(productName: value);
                    }),
                _categoryDropDown(),
                _formField(
                    label: 'Preço regular',
                    inputType: TextInputType.name,
                    onChanged: (value) {
                      provider.getFormData(regularPrice: int.parse(value));
                    })
              ],
            )
          ]));
    });
  }
}
