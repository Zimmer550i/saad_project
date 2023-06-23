import 'dart:io';
import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Hero(
              tag: "${widget.item.prodID}img",
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    coverFit = !coverFit;
                  });
                },
                child: Image.file(
                  File(widget.item.photoUrl),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  fit: coverFit ? BoxFit.cover : BoxFit.contain,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 15,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width/5*3,
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
                              Text(
                                "\$${widget.item.price}",
                                style: const TextStyle(
                                  fontFamily: "Geologica",
                                  fontSize: 28,
                                ),
                              ),
                            ],
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
                        Row(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
