import 'package:flutter/material.dart';
import 'package:uniwide/models/sales.dart';

class SellCard extends StatelessWidget {
  final Sales sales;
  const SellCard({super.key, required this.sales});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    sales.productName,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    sales.buyerName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withAlpha(200),
                    ),
                  ),
                ],
              ),
              Text("Date: ${sales.dateTime.day}"),
            ],
          ),
          sales.comment == null
              ? Container()
              : Text(
                  sales.comment!,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.grey),
                ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Buy: ${sales.sellingPrice - sales.profit}"),
              Text("Sell: ${sales.sellingPrice}"),
              Text("Profit: ${sales.profit}"),
            ],
          ),
        ],
      ),
    );
  }
}
