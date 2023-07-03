import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saad_project/pages/add_item.dart';
import 'package:saad_project/utils.dart/list_maker.dart';
import 'package:saad_project/utils.dart/tab_bar_icons_icons.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;

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
      body: SafeArea(
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      width: 50,
                      height: 50,
                      alignment: Alignment.topLeft,
                    ),
                    const Text(
                      "Uniwide Group",
                      style: TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
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
                        padding: const EdgeInsets.all(8),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Color(0xff878e96),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: 50,
                      width: 50,
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
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.filter_list_rounded),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.all(8),
                child: const TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.blueAccent,
                  tabs: [
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
                    : TabBarView(
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddItem(),
            ),
          );
        },
      ),
    );
  }
}
