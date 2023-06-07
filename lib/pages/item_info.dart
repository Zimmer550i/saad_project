import 'package:flutter/material.dart';

class ItemInfo extends StatefulWidget {
  final Map<String, Object> item;
  const ItemInfo({super.key, required this.item});

  @override
  State<ItemInfo> createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  bool coverFit = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item["name"] as String),
      ),
      body: Column(
        children: [
          Hero(
            tag: "${widget.item["image"]}img",
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  coverFit = !coverFit;
                });
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Image.asset(
                  widget.item["image"] as String,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  fit: coverFit ? BoxFit.cover : BoxFit.contain,
                ),
              ),
            ),
          ),
          infoItem("Product Name:", widget.item["name"] as String),
          infoItem("Selling Price:", widget.item["price"].toString()),
          infoItem(
              "Buying Price:",
              ((widget.item["price"]! as int) - (widget.item["profit"]! as int))
                  .toString()),
          infoItem("In Stock:", widget.item["stock"].toString()),
          infoItem("Sold:", widget.item["sold"].toString()),
          infoItem(
              "Profit:",
              ((widget.item["profit"]! as int) * (widget.item["sold"]! as int))
                  .toString()),
        ],
      ),
    );
  }

  Widget infoItem(String a, String b) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            "$a ",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            b,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
