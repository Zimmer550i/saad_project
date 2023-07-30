import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniwide/models/sales.dart';
import 'package:uniwide/widgets/sell_card.dart';

class SellHistory extends StatefulWidget {
  const SellHistory({super.key});

  @override
  State<SellHistory> createState() => _SellHistoryState();
}

class _SellHistoryState extends State<SellHistory> {
  String monthYear = "${DateTime.now().month}_${DateTime.now().year}";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sell History"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: monthDecrement,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios_rounded),
                    ),
                  ),
                  Text(
                    monthYearInString(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: monthIncrement,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('sales')
                    .doc(monthYear)
                    .collection('sales_items')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text("No sales made in ${monthYearInString()}"),
                    );
                  } else {
                    List<Sales> sales = [];
                    int totalProfit = 0;
                    for (var i in snapshot.data!.docs) {
                      Sales element = Sales.fromJson(i.data());
                      sales.add(element);
                      totalProfit += element.profit;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "Total Profit: $totalProfit",
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 28),
                            ),
                            ...sales.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SellCard(sales: e),
                              );
                            })
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  void monthDecrement() {
    List<String> list = monthYear.split("_");
    int month = int.parse(list[0]) - 1;
    int year = int.parse(list[1]);

    if (month == 0) {
      year--;
      month++;
    }

    setState(() {
      monthYear = "${month}_$year";
    });
  }

  void monthIncrement() {
    List<String> list = monthYear.split("_");
    int month = int.parse(list[0]) + 1;
    int year = int.parse(list[1]);

    if (month == 13) {
      month = 1;
      year++;
    }

    if (year > DateTime.now().year) {
      return;
    } else if (year == DateTime.now().year && month > DateTime.now().month) {
      return;
    }

    setState(() {
      monthYear = "${month}_$year";
    });
  }

  String monthYearInString() {
    List<String> list = monthYear.split("_");
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return "${months[int.parse(list[0]) - 1]} ${list[1]}";
  }
}
