class Sales {
  String salesId;
  DateTime dateTime;
  String productId;
  String productName;
  String? comment; // Changed to optional String comment
  int quantity;
  int sellingPrice;
  int profit;
  String sellerId;
  String buyerName;

  Sales({
    required this.salesId,
    required this.productId,
    required this.productName,
    this.comment, // Made String comment optional with '?'
    required this.sellingPrice,
    required this.sellerId,
    required this.profit,
    required this.quantity,
    required this.buyerName,
    required this.dateTime,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      salesId: json['salesId'],
      productId: json['productId'],
      productName: json['productName'],
      comment: json['comment'], 
      sellingPrice: json['sellingPrice'],
      sellerId: json['sellerId'],
      profit: json['profit'],
      quantity: json['quantity'],
      buyerName: json['buyerName'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesId': salesId,
      'productId': productId,
      'productName': productName,
      'comment': comment, // Now it can be null in the JSON representation
      'sellingPrice': sellingPrice,
      'sellerId': sellerId,
      'profit': profit,
      'quantity': quantity,
      'buyerName': buyerName,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
