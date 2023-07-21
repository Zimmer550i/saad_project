import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniwide/models/product.dart';
import 'package:uniwide/pages/sell_product.dart';
import 'package:uniwide/resources/firebase_methods.dart';
import 'package:uniwide/widgets/variants_list.dart';

class ProductInfo extends StatefulWidget {
  final Product product;
  const ProductInfo({super.key, required this.product});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                confirmDelete(context, widget.product);
              },
              child: const Row(
                children: [
                  Icon(Icons.delete_forever_rounded),
                  Text("Delete"),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(Icons.edit_note_rounded),
                  Text("Edit"),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SellProduct(product: widget.product),
                  ),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.attach_money_rounded),
                  Text("Sell"),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: "${widget.product.prodID}img",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          offset: Offset(0, 4),
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.product.photoUrl == ""
                              ? Image.asset(
                                  "assets/no_img.png",
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                )
                              : CachedNetworkImage(
                                  imageUrl: widget.product.photoUrl,
                                  placeholder: (context, url) {
                                    return const Center(child: CircularProgressIndicator(),);
                                  },
                                  width: MediaQuery.of(context).size.width,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 5,
                                right: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(200),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(Icons.arrow_back_ios_new),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Row(
                        children: [
                          detailedInfo(
                              "Price", widget.product.price.toString()),
                          detailedInfo("Category", widget.product.category),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Row(
                        children: [
                          detailedInfo(
                              "Quantity", widget.product.quantity.toString()),
                          detailedInfo("Date Added",
                              DateFormat.yMMMMd().format(widget.product.date)),
                        ],
                      ),
                    ),
                    widget.product.variant.isNotEmpty
                        ? VariantsList(
                            product: widget.product,
                          )
                        : Container(),
                    const Text("Discription: "),
                    Text(
                      widget.product.discription,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailedInfo(String head, String body) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            body,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                delete(context, product);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void delete(BuildContext newContext, Product product) async {
    final snackBar = SnackBar(
      content: Text(await FirebaseMethods().deleteProduct(product)),
    );

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(newContext).showSnackBar(snackBar);
  }
}
