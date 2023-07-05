import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saad_project/models/product.dart';

class ItemInfo extends StatefulWidget {
  final Product product;
  const ItemInfo({super.key, required this.product});

  @override
  State<ItemInfo> createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  bool coverFit = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(Icons.shopping_cart),
                  Text("Buy"),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            coverFit = !coverFit;
                          });
                        },
                        child: widget.product.photoUrl == ""
                            ? Image.asset(
                                "assets/no_img.png",
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                              )
                            : Image.network(
                                widget.product.photoUrl,
                                width: MediaQuery.of(context).size.width,
                                height: coverFit ? MediaQuery.of(context).size.width : null,
                                fit: coverFit ? BoxFit.cover : BoxFit.contain,
                              ),
                      ),
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
                        fontFamily: "Geologica",
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
                    Text(
                      widget.product.discription,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 18,
                      ),
                    ),
                    // CircularPercentIndicator(
                    //   radius: MediaQuery.of(context).size.width / 4,
                    //   percent: stock / (stock + sold),
                    //   lineWidth: 20,
                    //   circularStrokeCap: CircularStrokeCap.round,
                    //   progressColor: Colors.deepPurple,
                    //   backgroundColor: Colors.deepPurple.shade100,
                    //   center: Text("$stock/${stock + sold}"),
                    // ),
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
              fontFamily: "Geologica",
              fontSize: 14,
            ),
          ),
          Text(
            body,
            style: const TextStyle(
              fontFamily: "Geologica",
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
