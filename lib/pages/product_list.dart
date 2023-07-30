import 'package:flutter/material.dart';
import 'package:uniwide/utils.dart/list_maker.dart';
import 'package:uniwide/utils.dart/tab_bar_icons_icons.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          "assets/uniwide_logo_without_name.png",
          alignment: Alignment.centerRight,
        ),
        title: const Text(
          "Uniwide Group",
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: IconButton(onPressed: (){}, icon: const Icon(Icons.search_rounded)),
          )
        ],
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.all(8),
              child: TabBar(
                splashBorderRadius: BorderRadius.circular(20),
                labelColor: Colors.black,
                labelPadding: const EdgeInsets.symmetric(vertical: 8),
                indicatorColor: Colors.blueAccent,
                tabs: const [
                  Icon(TabBarIcons.shoe),
                  Icon(TabBarIcons.drugs),
                  Icon(TabBarIcons.cpu),
                  Icon(TabBarIcons.fruits),
                  Icon(TabBarIcons.food),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const TabBarView(
                      children: [
                        ListMaker(category: "Shoes"),
                        ListMaker(category: "Medicines"),
                        ListMaker(category: "Electronics"),
                        ListMaker(category: "Fruites"),
                        ListMaker(category: "Groceries"),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
