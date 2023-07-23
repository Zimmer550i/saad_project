import 'package:uniwide/models/product.dart';

class AppUser {
  String userID;
  String mobileNumber;
  String email;
  String firstName;
  String lastName;
  String imgUrl;
  DateTime dateCreated;
  bool isAdmin;
  List<Product> cart = [];
  List<String> likes = [];

  AppUser({
    required this.userID,
    required this.mobileNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imgUrl,
    this.isAdmin = false,
  }): dateCreated = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'mobileNumber': mobileNumber,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'imgUrl': imgUrl,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userID: json['userID'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imgUrl: json['imgUrl'],
      isAdmin: json['isAdmin'],
    );
  }
}
