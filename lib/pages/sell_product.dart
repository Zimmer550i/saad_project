// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniwide/models/product.dart';
import 'package:uniwide/models/sales.dart';
import 'package:uniwide/models/variant.dart';
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
  final TextEditingController _comment = TextEditingController();
  DateTime _dateTime = DateTime.now();
  List<Variant> variantCopy = [];

  @override
  void initState() {
    super.initState();
    if (widget.product.variant.isNotEmpty) {
      variantCopy = widget.product.variant.map((e) {
        return Variant(quantity: e.quantity, size: e.size, color: e.color);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    int availableProduct = widget.product.quantity -
        int.parse(_quantity.text.isEmpty ? "0" : _quantity.text);

    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: const Text("Sell Product")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Selling Date",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then(
                        (value) {
                          if (value != null) {
                            setState(() {
                              _dateTime = value;
                            });
                          }
                        },
                      );
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              widget.product.category != "Shoes"
                  ? textInputField("Quantity", _quantity,
                      isNumber: true, listenOnChanged: true)
                  : chooseVariant(),
              widget.product.category != "Shoes"
                  ? availableProduct < 0
                      ? Text(
                          "Only ${widget.product.quantity} product(s) available!",
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      : Text("Available: $availableProduct")
                  : Container(),
              textInputField("Comment", _comment),
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
          productName: product.name,
          productId: product.prodID,
          profit: int.parse(_sellingPrice.text) - product.price,
          sellingPrice: int.parse(_sellingPrice.text),
          sellerId: FirebaseAuth.instance.currentUser!.uid,
          quantity: int.parse(_quantity.text),
          dateTime: _dateTime,
          comment: _comment.text,
        );

        if (widget.product.category == "Shoes") {
          widget.product.variant = variantCopy;
          int count = 0;
          for (var i in widget.product.variant) {
            count += i.quantity;
          }
          widget.product.quantity = count;
        }

        String res = await FirebaseMethods().createSales(temp, product);

        return res;
      } else {
        return "Provide valid information!";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Widget chooseVariant() {
    return Column(
      children: [
        Text(
          "Quantity: ${_quantity.text.isEmpty ? "0" : _quantity.text}",
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          alignment: WrapAlignment.spaceAround,
          children: [
            ...variantCopy.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (e.quantity > 0) {
                        setState(() {
                          e.quantity = e.quantity - 1;
                          _quantity.text = _quantity.text.isEmpty
                              ? "1"
                              : (int.parse(_quantity.text) + 1).toString();
                        });
                      }
                    },
                    // onLongPress: () {
                    //   //This can be exploited
                    //   //Disable this to prevent
                    //   //Logic here is BS
                    //   setState(() {
                    //     e.quantity = e.quantity + 1;
                    //     _quantity.text = _quantity.text.isEmpty
                    //         ? "1"
                    //         : (int.parse(_quantity.text) - 1).toString();
                    //   });
                    // },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            offset: Offset(1, 4),
                            blurRadius: 4,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${e.size} \u2022 ${e.color}",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(" x ${e.quantity}"),
                ],
              );
            }).toList(),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
