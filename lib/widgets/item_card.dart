import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saad_project/models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Hero(
            tag: "${item.prodID}img",
            child: ClipRect(
              clipBehavior: Clip.hardEdge,
              child: item.photoUrl.startsWith("assets/")
                  ? Image.asset(
                      item.photoUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(item.photoUrl),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "${item.quantity} pcs \u2022 ${item.date}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: "Geologica",
                      color: Color(0xff68717b),
                    ),
                  )
                ],
              ),
              Text(
                "৳${item.price}",
                style: const TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
