import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  Produto({
    this.productImageUrl,
    this.productName,
    this.regularPrice,
    this.uid,
    this.time,
    this.location,
  });
  Produto.fromJson(Map<String, Object?> json)
      : this(
          productImageUrl: json['productImageUrl']! as String,
          productName: json['productName']! as String,
          regularPrice: json['regularPrice']! as double,
          uid: json['uid'] as String,
          time: json['time'] as Timestamp,
          location: json['location'] as GeoPoint,
        );

  final String? productImageUrl;
  final String? productName;
  final double? regularPrice;
  final String? uid;
  final Timestamp? time;
  final GeoPoint? location;

  Map<String, Object?> toJson() {
    return {
      'productImage': productImageUrl,
      'productName': productName,
      'regularPrice': regularPrice,
      'uid': uid,
      'time': time,
      'location': location,
    };
  }
}
