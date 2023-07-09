class AppUser {
  String userID;
  String mobileNumber;
  String email;
  String firstName;
  String lastName;
  String imgUrl;

  AppUser({
    required this.userID,
    required this.mobileNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imgUrl,
  });

  // Convert AppUser object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'mobileNumber': mobileNumber,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'imgUrl' : imgUrl,
    };
  }

  // Create AppUser object from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userID: json['userID'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imgUrl: json['imgUrl'],
    );
  }
}
