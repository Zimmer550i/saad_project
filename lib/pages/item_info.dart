import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saad_project/models/item.dart';

class ItemInfo extends StatefulWidget {
  final Item item;
  const ItemInfo({super.key, required this.item});

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
                tag: "${widget.item.prodID}img",
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      coverFit = !coverFit;
                    });
                  },
                  child: Image.asset(
                    widget.item.photoUrl,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    fit: coverFit ? BoxFit.cover : BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5 * 3,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.item.name,
                          maxLines: 3,
                          style: const TextStyle(
                            fontFamily: "Geologica",
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Row(
                        children: [
                          detailedInfo("Price", widget.item.price.toString()),
                          detailedInfo("Category", widget.item.category),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Row(
                        children: [
                          detailedInfo(
                              "Quantity", widget.item.quantity.toString()),
                          detailedInfo("Date Added",
                              DateFormat.yMMMMd().format(widget.item.date)),
                        ],
                      ),
                    ),
                    Text(
                      widget.item.discription,
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
