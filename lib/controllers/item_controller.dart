import 'package:get/get.dart';
import 'package:saad_project/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemController extends GetxController {
  var items = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences retriveItems = await SharedPreferences.getInstance();
    if (retriveItems.containsKey("savedItems")) {
      // items = retriveItems.get("savedItems");
    } else {
      items.add(
        Product(
          prodID: "123",
          name: "Product",
          price: 400,
          quantity: 50,
          discription: "some discription",
          category: "Electronics",
          variant: [],
          photoUrl: "",
          date: DateTime.now(),
        ),
      );
      items.add(
        Product(
          prodID: "123",
          name: "Apple",
          price: 120,
          quantity: 200,
          discription: "Ripe apples. Picked from the best Farms out there",
          category: "Fruites",
          variant: [],
          photoUrl: "",
          date: DateTime.now(),
        ),
      );
    }
  }
}
