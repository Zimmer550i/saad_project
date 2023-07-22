import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniwide/models/variant.dart';
import 'package:uniwide/resources/firebase_methods.dart';
import 'package:uniwide/utils.dart/constants.dart';

import '../models/product.dart';

class EditProduct extends StatefulWidget {
  final Product product;
  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _AddItemState();
}

class _AddItemState extends State<EditProduct> {
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
  bool fileExistsInStorage = false;

  @override
  void initState() {
    super.initState();
    fileExistsInStorage = widget.product.photoUrl != "";
    dropdownValue = widget.product.category;
    variant = widget.product.variant.toList();
    prodName.text = widget.product.name;
    prodDiscription.text = widget.product.discription;
    price.text = widget.product.price.toString();
    quantity.text = widget.product.quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text("Update Product"),
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
              const Text(
                "Product Variants",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
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
                  image == null && widget.product.photoUrl == ""
                      ? Container()
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                              widget.product.photoUrl = "";
                            });
                          },
                          child: const Text("Delete"),
                        ),
                ],
              ),
              const SizedBox(height: 10),
              productPhoto(context),
              const SizedBox(height: 10),
              discriptionInputField("Product Discription", prodDiscription),
              Text(
                res,
                style: const TextStyle(color: Colors.grey),
              ),
              res != "Product has been Updated"
                  ? ElevatedButton(
                      onPressed: updateProd,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Update Product"),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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

  void confirmUpdate() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: const Text("You are going to update this product"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Back")),
              TextButton(
                  onPressed: () {
                    updateProd();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Confirm")),
            ],
          );
        });
  }

  Widget productPhoto(BuildContext context) {
    return DottedBorder(
      color: Colors.deepOrange,
      strokeWidth: 2,
      dashPattern: const [5, 5],
      child: widget.product.photoUrl == "" && image == null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () => pickImage(fromGallery: true),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepOrange),
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
                      side: const BorderSide(color: Colors.deepOrange),
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
          : Hero(
              tag: "${widget.product.prodID}img",
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.width,
                  minWidth: double.infinity,
                ),
                child: widget.product.photoUrl != ""
                    ? CachedNetworkImage(
                        imageUrl: widget.product.photoUrl,
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(image!.path),
                        fit: BoxFit.contain,
                      ),
              ),
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

  void updateProd() async {
    setState(() {
      isLoading = true;
    });
    if (image != null) {
      String path = "products/${widget.product.prodID}.jpg";
      Uint8List temp = await File(image!.path).readAsBytes();
      widget.product.photoUrl = await FirebaseMethods().uploadImageToStorage(path, temp);
    }
    if(fileExistsInStorage && image == null && widget.product.photoUrl == ""){
      FirebaseMethods().deleteImageFromStorage("products/${widget.product.prodID}.jpg");
    }

    widget.product.name = prodName.text;
    widget.product.discription = prodDiscription.text;
    widget.product.price = int.parse(price.text);
    widget.product.quantity = int.parse(quantity.text);
    widget.product.variant = variant;
    widget.product.category = dropdownValue!;

    res = await FirebaseMethods().updateProduct(widget.product);

    setState(() {
      isLoading = false;
    });
  }
}
