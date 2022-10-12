import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference vendedor =
      FirebaseFirestore.instance.collection('vendedor');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);
    await ref.putFile(_file);

    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> addVendor({Map<String, dynamic>? data}) {
    return vendedor
        .doc(user!.uid)
        .set(data)
        .then((value) => print("Vendedor adicionado"))
        .catchError((error) => print("Adicionar vendedor falhou: $error"));
  }
}
