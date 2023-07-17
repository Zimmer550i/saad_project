class Sales {
  String salesId;
  DateTime dateTime;
  String productId;
  int quantity;
  int sellingPrice;
  int profit;
  String sellerId;
  String? buyerName;

  Sales({
    required this.salesId,
    required this.productId,
    required this.sellingPrice,
    required this.sellerId,
    required this.profit,
    required this.quantity,
    this.buyerName,
  }) : dateTime = DateTime.now();

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      salesId: json['salesId'],
      productId: json['productId'],
      sellingPrice: json['sellingPrice'],
      sellerId: json['sellerId'],
      profit: json['profit'],
      quantity: json['quantity'],
      buyerName: json['buyerName'],
    )..dateTime = DateTime.parse(json['dateTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'salesId': salesId,
      'dateTime': dateTime.toIso8601String(),
      'productId': productId,
      'sellingPrice': sellingPrice,
      'sellerId': sellerId,
      'buyerName': buyerName,
      'quantity' : quantity,
      'profit': profit,
    };
  }
}
