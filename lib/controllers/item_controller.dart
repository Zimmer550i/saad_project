import 'package:get/get.dart';
import 'package:saad_project/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemController extends GetxController {
  var items = <Item>[].obs;

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
        Item(
          prodID: "123",
          name: "Item",
          price: 400,
          quantity: 50,
          discription: "some discription",
          category: "Electronics",
          variant: [],
          photoUrl: "assets/no_img.png",
          date: DateTime.now(),
        ),
      );
      items.add(
        Item(
          prodID: "123",
          name: "Apple",
          price: 120,
          quantity: 200,
          discription: "Ripe apples. Picked from the best Farms out there",
          category: "Fruites",
          variant: [],
          photoUrl: "assets/apple.jpg",
          date: DateTime.now(),
        ),
      );
    }
  }
}
