import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {};

  getFormData({String? productName, String? regularPrice}) {
    if (productName != null) {
      productData!['productName'] = productName;
    }
    if (regularPrice != null) {
      productData!['regularPrice'] = regularPrice;
    }
    notifyListeners();
  }
}
