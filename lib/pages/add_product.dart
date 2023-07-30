import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniwide/models/variant.dart';
import 'package:uniwide/resources/firebase_methods.dart';
import 'package:uniwide/utils.dart/constants.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddItemState();
}

class _AddItemState extends State<AddProduct> {
  XFile? image;
  TextEditingController prodName = TextEditingController();
  TextEditingController prodDiscription = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController overheadCost = TextEditingController();

  bool isLoading = false;
  String res = "";
  String? dropdownValue;
  int expensePerProduct = 0;
  List<Variant> variant = [];

  @override
  Widget build(BuildContext context) {
    if (variant.isNotEmpty) {
      int count = 0;
      for (var element in variant) {
        count += element.quantity;
      }
      quantity.text = count.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              textInputField("Product Name", prodName),
              textInputField("Product Price", price, isNumber: true),
              const Text(
                "Product Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                items: dropdownItems(),
                value: dropdownValue,
                elevation: 2,
                isExpanded: true,
                onChanged: (val) {
                  setState(() {
                    dropdownValue = val as String;
                  });
                },
              ),
              const SizedBox(height: 5),
              dropdownValue == "Shoes"
                  ? productVariants()
                  : textInputField(
                      "Quantity",
                      quantity,
                      isNumber: true,
                      updateController: true,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Product Photo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  image == null
                      ? Container()
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                          child: const Text("Delete"),
                        ),
                ],
              ),
              const SizedBox(height: 10),
              DottedBorder(
                color: Colors.deepOrange,
                strokeWidth: 2,
                dashPattern: const [5, 5],
                child: image == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                              onPressed: () => pickImage(fromGallery: true),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Colors.deepOrange),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Upload Photos",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => pickImage(),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Colors.deepOrange),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Take Photos",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.width,
                          minWidth: double.infinity,
                        ),
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              textInputField("Overhead Cost", overheadCost,
                  isNumber: true, updateController: true),
              expensePerProduct != 0
                  ? Text(
                      "  $expensePerProduct spent per product",
                      style: const TextStyle(color: Colors.grey),
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              discriptionInputField("Product Discription", prodDiscription),
              Text(
                res,
                style: const TextStyle(color: Colors.grey),
              ),
              res != "Product has been Added"
                  ? ElevatedButton(
                      onPressed: addProd,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Add Product"),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: const Icon(Icons.check_rounded),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void addProd() async {
    if (prodName.text.isNotEmpty &&
        price.text.isNotEmpty &&
        dropdownValue != null) {
      setState(() {
        isLoading = true;
      });
      String prodID = const Uuid().v4();
      String imagePath = "";
      if (image != null) {
        String path = "products/$prodID.jpg";
        Uint8List temp = await File(image!.path).readAsBytes();
        imagePath = await FirebaseMethods().uploadImageToStorage(path, temp);
      }

      int prodPrice = int.parse(price.text);
      if (overheadCost.text.isNotEmpty) {
        prodPrice +=
            (int.parse(overheadCost.text) / int.parse(quantity.text)).round();
      }

      var newItem = Product(
        prodID: prodID,
        name: prodName.text,
        price: prodPrice,
        quantity: quantity.text.isNotEmpty ? int.parse(quantity.text) : 0,
        discription: prodDiscription.text,
        category: dropdownValue!,
        variant: variant,
        photoUrl: imagePath,
        date: DateTime.now(),
      );

      res = await FirebaseMethods().uploadProduct(newItem);

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        res = "Please provide required informations";
      });
    }
  }

  List<DropdownMenuItem<Object?>> dropdownItems() {
    List<DropdownMenuItem<Object?>> temp = [];
    for (var element in categories) {
      temp.add(
        DropdownMenuItem(
          value: element,
          child: Text(element),
        ),
      );
    }
    return temp;
  }

  void calcExpense() {
    if (overheadCost.text != "" && quantity.text != "") {
      setState(() {
        expensePerProduct =
            (int.parse(overheadCost.text) / int.parse(quantity.text)).round();
      });
    }
  }

  void pickImage({bool fromGallery = false}) async {
    ImagePicker picker = ImagePicker();
    XFile? temp = await picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );

    if (temp != null) {
      setState(() {
        image = temp;
      });
    }
  }

  Widget textInputField(String title, TextEditingController controller,
      {bool isNumber = false,
      String hintText = "",
      bool updateController = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          controller: controller,
          onChanged: updateController
              ? (value) {
                  setState(() {
                    calcExpense();
                  });
                }
              : null,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget discriptionInputField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Discription",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Wrap productVariants() {
    TextEditingController variantSize = TextEditingController();
    TextEditingController variantColor = TextEditingController();
    TextEditingController variantQuantity = TextEditingController();

    return Wrap(
      runSpacing: 8,
      spacing: 8,
      alignment: WrapAlignment.spaceAround,
      children: [
        ...variant.map((e) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(1, 4),
                      blurRadius: 4,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${e.size} \u2022 ${e.color}",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Text(" x ${e.quantity}"),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Add Variant"),
                actions: [
                  textInputField("Size", variantSize),
                  textInputField("Color", variantColor),
                  textInputField("Quantity", variantQuantity),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Back")),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              variant.add(Variant(
                                quantity: int.parse(variantQuantity.text),
                                size: variantSize.text,
                                color: variantColor.text,
                              ));
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text("Add")),
                    ],
                  ),
                ],
              ),
            );
          },
          child: const Text("Add Variant"),
        )
      ],
    );
  }
}
