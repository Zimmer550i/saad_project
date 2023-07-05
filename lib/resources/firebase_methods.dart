import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saad_project/models/product.dart';

class FirebaseMethods {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String path, Uint8List file) async {
    Reference ref = _storage.ref().child(path);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadProduct (Product product) async {
    try {
      _firestore.collection("products").doc(product.prodID).set(product.toJson());
      return "Product has been Added";
    } catch (e) {
      return e.toString();
    }
  }
}
