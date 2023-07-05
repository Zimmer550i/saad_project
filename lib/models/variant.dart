class Variant {
  int quantity;
  String size;
  String color;

  Variant({
    required this.quantity,
    required this.size,
    required this.color,
  });

  Variant.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'],
        size = json['size'],
        color = json['color'];

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }
}
