import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saad_project/controllers/item_controller.dart';
import 'package:saad_project/pages/item_info.dart';
import '../widgets/item_card.dart';

class ListMaker extends StatelessWidget {
  final ItemController itemController = Get.put(ItemController());
  final String category;
  ListMaker({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 6,
      radius: const Radius.circular(2),
      interactive: true,
      child: GetX<ItemController>(
        builder: (controller) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              if (controller.items[index].category == category) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ItemInfo(
                          product: controller.items[index],
                        ),
                      ),
                    ),
                    child: ItemCard(
                      product: controller.items[index],
                    ),
                  ),
                );
              }
              else{
                return Container();
              }
            },
          );
        }
      ),
    );
  }
}
