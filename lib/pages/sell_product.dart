// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniwide/models/product.dart';
import 'package:uniwide/models/sales.dart';
import 'package:uniwide/resources/firebase_methods.dart';
import 'package:uniwide/widgets/item_card.dart';
import 'package:uuid/uuid.dart';

class SellProduct extends StatefulWidget {
  final Product product;
  const SellProduct({super.key, required this.product});

  @override
  State<SellProduct> createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct> {
  final TextEditingController _buyerName = TextEditingController();
  final TextEditingController _sellingPrice = TextEditingController();
  final TextEditingController _quantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int avialableProduct = widget.product.quantity -
        int.parse(_quantity.text.isEmpty ? "0" : _quantity.text);

    return Scaffold(
      appBar: AppBar(title: const Text("Sell Product")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ItemCard(product: widget.product),
              ),
              const SizedBox(
                height: 25,
              ),
              textInputField("Buyer's Name", _buyerName),
              textInputField("Selling Price", _sellingPrice),
              textInputField("Quantity", _quantity,
                  isNumber: true, listenOnChanged: true),
              avialableProduct < 0
                  ? Text(
                      "Only ${widget.product.quantity} product(s) available!",
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  : Text("Available: $avialableProduct"),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  confirmSell(context, widget.product);
                },
                child: const Text("Sell This Product"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textInputField(
    String title,
    TextEditingController controller, {
    bool isNumber = false,
    String hintText = "",
    bool listenOnChanged = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          controller: controller,
          onChanged: listenOnChanged
              ? (value) {
                  setState(() {});
                }
              : null,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  void confirmSell(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sell'),
          content: const Text('Are you sure you want to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String temp = await sellProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(temp),
                  ),
                );

                if (temp == "Sales information has been saved") {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }

                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String> sellProduct(Product product) async {
    try {
      if (_buyerName.text != "" &&
          _quantity.text != "" &&
          _sellingPrice.text != "" &&
          product.quantity >= int.parse(_quantity.text)) {
        Sales temp = Sales(
          buyerName: _buyerName.text,
          salesId: const Uuid().v4(),
          productId: product.prodID,
          profit: int.parse(_sellingPrice.text) - product.price,
          sellingPrice: int.parse(_sellingPrice.text),
          sellerId: FirebaseAuth.instance.currentUser!.uid,
          quantity: int.parse(_quantity.text),
        );

        String res = await FirebaseMethods().createSales(temp, product);

        return res;
      } else {
        return "Provide valid informations!";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
