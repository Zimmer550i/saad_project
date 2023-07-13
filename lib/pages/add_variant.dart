import 'package:flutter/material.dart';
import 'package:uniwide/models/variant.dart';

class AddVariant extends StatefulWidget {
  final List<Variant> list;
  const AddVariant({super.key, required this.list});

  @override
  State<AddVariant> createState() => _AddVariantState();
}

class _AddVariantState extends State<AddVariant> {
  final TextEditingController _size = TextEditingController();
  final TextEditingController _color = TextEditingController();
  final TextEditingController _quantity = TextEditingController();

  bool adding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Variant"),
      ),
      body: ListView.builder(
        itemCount: widget.list.length + 1,
        itemBuilder: (context, index) {
          if (widget.list.length == index) {
            return addButton(context, index + 1);
          }

          Variant item = widget.list[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 16,
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
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${item.quantity.toString()} pcs \u2022 ${item.size} \u2022 ${item.color}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Center addButton(BuildContext context, int variantNo) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            setState(() {
              adding = !adding;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            // height: adding ? null : 40,
            width: adding ? MediaQuery.of(context).size.width - 16 : 40,
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
            padding: const EdgeInsets.all(2),
            child: !adding ? const Icon(Icons.add) : addButtonInput(variantNo),
          ),
        ),
      ),
    );
  }

  Padding addButtonInput(int variantNo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Variant #$variantNo"),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _size,
            decoration: const InputDecoration(
              hintText: "Size",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _color,
            decoration: const InputDecoration(
              hintText: "Color",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Quantity",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _size.text = "";
                  _color.text = "";
                  _quantity.text = "";
                  adding = !adding;
                },
                child: const Text("Go Back"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.list.add(Variant(
                        quantity: int.parse(_quantity.text),
                        size: _size.text,
                        color: _color.text));
                    adding = !adding;

                    _size.text = "";
                    _color.text = "";
                    _quantity.text = "";
                  });
                },
                child: const Text("Add Variant"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
