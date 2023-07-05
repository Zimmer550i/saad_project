import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saad_project/models/variant.dart';
import 'package:saad_project/pages/add_variant.dart';
import 'package:saad_project/resources/firebase_methods.dart';
import 'package:saad_project/utils.dart/constants.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
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
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text("Add Product"),
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
                  ? shoeSizeColor()
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
                          : const Text("Add This Product"),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Go Back"),
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

      if (variant.isNotEmpty) {
        int count = 0;
        for (var element in variant) {
          count += element.quantity;
        }
        quantity.text = count.toString();
      }

      var newItem = Product(
        prodID: prodID,
        name: prodName.text,
        price: int.parse(price.text),
        quantity: quantity.text.isNotEmpty ? int.parse(quantity.text) : 0,
        discription: prodDiscription.text,
        category: dropdownValue!,
        variant: variant,
        photoUrl: imagePath,
        date: DateTime.now(),
      );

      res = await FirebaseMethods().uploadProduct(newItem);

      setState(() {});

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        res = "Please provide required informations";
      });
    }
  }

  Widget shoeSizeColor() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddVariant(list: variant),
            ),
          );
        },
        child: const Text("Choose Color and Size"),
      ),
    );
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
}
