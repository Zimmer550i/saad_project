import 'package:flutter/material.dart';
import 'package:uniwide/models/product.dart';
import 'package:uniwide/models/variant.dart';

class VariantsList extends StatefulWidget {
  final Product product;
  const VariantsList({super.key, required this.product});

  @override
  State<VariantsList> createState() => _VariantsListState();
}

class _VariantsListState extends State<VariantsList> {
  int selectedColor = 0;
  int selectedSize = 0;

  List<String> getColorsList() {
    Set<String> colorsList = {};

    for (Variant i in widget.product.variant) {
      if(i.quantity>0) {
        colorsList.add(i.color);
      }
    }

    return colorsList.toList();
  }

  List<String> getSizeList(String color) {
    Set<String> sizeList = {};

    for (Variant i in widget.product.variant) {
      if (i.color == color && i.quantity>0) {
        sizeList.add(i.size);
      }
    }

    return sizeList.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> colorsList = getColorsList();
    List<String> sizeList = getSizeList(colorsList[selectedColor]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Color: "),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colorsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedColor = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: selectedColor == index
                            ? Colors.grey
                            : Colors.grey[350]),
                    child: Text(colorsList[index]),
                  ),
                ),
              );
            },
          ),
        ),
        const Text("Size: "),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sizeList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: selectedSize == index
                            ? Colors.grey
                            : Colors.grey[350]),
                    child: Text(sizeList[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
