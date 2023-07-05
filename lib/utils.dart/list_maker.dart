import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saad_project/models/product.dart';
import 'package:saad_project/pages/item_info.dart';
import '../widgets/item_card.dart';

class ListMaker extends StatelessWidget {
  final String category;
  const ListMaker({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 6,
      radius: const Radius.circular(2),
      interactive: true,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (controller, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snap.hasError) {
              return Text(snap.error.toString());
            }

            if (!snap.hasData) {
              return const Text("No Products");
            }

            List<Product> products = [];
            for (var element in snap.data!.docs) {
              products.add(Product.fromJson(element.data()));
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                if (products[index].category == category) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ItemInfo(
                            product: products[index],
                          ),
                        ),
                      ),
                      child: ItemCard(
                        product: products[index],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          }),
    );
  }
}
