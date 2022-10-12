import 'package:cloud_firestore/cloud_firestore.dart';

class Vendedor {
  Vendedor({
    this.shopImage,
    this.logo,
    this.latitude,
    this.longitude,
    this.businessName,
    this.contactNumber,
    this.email,
    this.streetNumber,
    this.bairro,
    this.cidade,
    this.cep,
    this.estado,
    this.pais,
    this.aprovado,
    this.uid,
    this.time,
  });
  Vendedor.fromJson(Map<String, Object?> json)
      : this(
          shopImage: json['shopImage']! as String,
          logo: json['logo']! as String,
          latitude: json['latitude']! as String,
          longitude: json['longitude'] as String,
          businessName: json['businessName'] as String,
          contactNumber: json['contactNumber'] as String,
          email: json['email'] as String,
          streetNumber: json['streetNumber'] as String,
          bairro: json['bairro'] as String,
          cidade: json['cidade'] as String,
          cep: json['cep'] as String,
          estado: json['estado'] as String,
          pais: json['pais'] as String,
          aprovado: json['aprovado'] as bool,
          uid: json['uid'] as String,
          time: json['time'] as Timestamp,
        );

  final String? shopImage;
  final String? logo;
  final String? latitude;
  final String? longitude;
  final String? businessName;
  final String? contactNumber;
  final String? email;
  final String? streetNumber;
  final String? bairro;
  final String? cidade;
  final String? cep;
  final String? estado;
  final String? pais;
  final bool? aprovado;
  final String? uid;
  final Timestamp? time;

  Map<String, Object?> toJson() {
    return {
      'shopImage': shopImage,
      'logo': logo,
      'latitude': latitude,
      'longitude': longitude,
      'businessName': businessName,
      'contactNumber': contactNumber,
      'email': email,
      'streetNumber': streetNumber,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'estado': estado,
      'pais': pais,
      'aprovado': aprovado,
      'uid': uid,
      'time': time,
    };
  }
}
