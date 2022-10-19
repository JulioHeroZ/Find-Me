import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {};

  getFormData({String? productName, String? category, int? regularPrice}) {
    if (productName != null) {
      productData!['productName'] = productName;
    }
    if (category != null) {
      productData!['category'] = category;
    }
    if (regularPrice != null) {
      productData!['regularPrice'] = regularPrice;
    }
    notifyListeners();
  }
}
