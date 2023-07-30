import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:uniwide/pages/add_product.dart';
import 'package:uniwide/pages/product_list.dart';
import 'package:uniwide/pages/sell_history.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  void initFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 8,
        selectedIndex: selectedIndex,
        onTabChange: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        padding: const EdgeInsets.all(20),
        tabs: const [
          GButton(icon: Icons.home, text: "Home"),
          GButton(icon: Icons.list_alt_rounded, text: "History"),
          GButton(icon: Icons.add_box_rounded, text: "Add Product"),
          GButton(icon: Icons.person, text: "Account"),
        ],
      ),
      body: [
        ProductList(isLoading: isLoading),
        const SellHistory(),
        const AddProduct(),
        const Center(
            child: Text(
          "Under Construction",
          style: TextStyle(fontSize: 48),
        ))
      ][selectedIndex],
    );
  }
}
