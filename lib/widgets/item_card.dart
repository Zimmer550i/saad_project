import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniwide/models/product.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  const ItemCard({super.key, required this.product});

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
            tag: "${product.prodID}img",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.photoUrl == ""
                  ? Image.asset(
                      "assets/no_img.png",
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      product.photoUrl,
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
                product.name,
                style: const TextStyle(
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
                    "${product.quantity} pcs \u2022 ${formatElapsedTime(product.date)}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xff68717b),
                    ),
                  )
                ],
              ),
              Text(
                "৳${product.price}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatElapsedTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      final format = DateFormat('yyyy-MM-dd');
      return format.format(dateTime);
    }
  }
}
