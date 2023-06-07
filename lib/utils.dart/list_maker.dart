import 'package:flutter/material.dart';
import 'package:saad_project/pages/item_info.dart';
import '../widgets/item.dart';

class ListMaker extends StatelessWidget {
  final List<Map<String, Object>> list;
  const ListMaker({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 6,
      radius: const Radius.circular(2),
      interactive: true,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ItemInfo(
                    item: list[index],
                  ),
                ),
              ),
              child: Item(
                item: list[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
