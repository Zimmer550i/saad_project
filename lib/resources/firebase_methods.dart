import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniwide/models/product.dart';
import 'package:uniwide/models/app_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<AppUser> getUserData() async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;

    return AppUser.fromJson(snapshot);
  }

  Future<String> uploadProduct(Product product) async {
    try {
      _firestore
          .collection("products")
          .doc(product.prodID)
          .set(product.toJson());
      return "Product has been Added";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteProduct(Product product) async {
    try {
      if (product.photoUrl != "") {
        String path = "products/${product.prodID}.jpg";
        _storage.ref().child(path).delete();
      }
      _firestore.collection('products').doc(product.prodID).delete();
      return "Product Deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> emailSignInUser(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FlutterSecureStorage storage = const FlutterSecureStorage();

      storage.write(key: 'loginToken', value: await user.user?.getIdToken());
    } catch (e) {
      return e.toString();
    }

    return "success";
  }

  Future<String> tokenSignInUser(String token) async {
    try {
      await _auth.signInWithCustomToken(token);
    } catch (e) {
      return e.toString();
    }

    return "success";
  }

  Future<String?> emailSignUpUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user?.uid;
    } catch (e) {
      return null;
    }
  }

  Future<String> createUser(AppUser user) async {
    try {
      _firestore.collection("users").doc(user.userID).set(user.toJson());
      return "User has been Added";
    } catch (e) {
      return e.toString();
    }
  }
}
