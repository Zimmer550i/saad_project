import 'package:uniwide/models/variant.dart';

class Product {
  String prodID;
  String name;
  int price;
  int quantity;
  String category;
  String discription;
  List<Variant> variant;
  String photoUrl;
  DateTime date;

  Product({
    required this.prodID,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
    required this.discription,
    required this.variant,
    required this.photoUrl,
    required this.date,
  });

  Product.fromJson(Map<String, dynamic> json)
      : prodID = json['prodID'],
        name = json['name'],
        price = json['price'],
        quantity = json['quantity'],
        category = json['category'],
        discription = json['discription'],
        variant = List<Variant>.from(json['variant']
            .map((variantJson) => Variant.fromJson(variantJson))),
        photoUrl = json['photoUrl'],
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() {
    return {
      'prodID': prodID,
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
      'discription': discription,
      'variant': variant.map((variant) => variant.toJson()).toList(),
      'photoUrl': photoUrl,
      'date': date.toIso8601String(),
    };
  }
}
