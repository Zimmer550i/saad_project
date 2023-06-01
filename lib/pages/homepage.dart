import 'package:flutter/material.dart';
import 'package:saad_project/utils.dart/list_maker.dart';
import 'package:saad_project/utils.dart/tab_bar_icons_icons.dart';

import '../utils.dart/constants.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
                child: TabBarView(
                  children: [
                    ListMaker(list: shoes),
                    ListMaker(list: drugs),
                    ListMaker(list: electronics),
                    ListMaker(list: fruits),
                    ListMaker(list: groceries),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
