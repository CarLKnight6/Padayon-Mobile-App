import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padayon/journalscreens/addnote.dart';
import 'package:padayon/journalscreens/viewnote.dart';
import 'package:padayon/loginscreen.dart';
// ignore: unused_import
import 'package:padayon/navigation_view.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, String? currentuseremail}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime? _fromchosenDateTime;
  DateTime? _uptochosenDateTime;
  String from = 'from';
  String upto = 'up to';
  DateTime selectedDatefrom = DateTime.now();
  DateTime selectedDateupto = DateTime.now();
  int? resultsnotecount;

  Future<void> _selectDatefrom(BuildContext context) async {
    final DateTime? pickedfrom = await showDatePicker(
        context: context,
        initialDate: selectedDatefrom,
        firstDate: DateTime(2021, 1, 1),
        lastDate: DateTime(2101, 1, 1));
    if (pickedfrom != null && pickedfrom != selectedDatefrom)
      setState(() {
        // selectedDatefrom = picked;
        _fromchosenDateTime = pickedfrom;
        from = _fromchosenDateTime.toString();
      });
    print(_fromchosenDateTime);
  }

  Future<void> _selectDateupto(BuildContext context) async {
    final DateTime? pickedupto = await showDatePicker(
        context: context,
        initialDate: selectedDateupto,
        firstDate: DateTime(2021, 1, 1),
        lastDate: DateTime(2101, 1, 1));
    if (pickedupto != null && pickedupto != selectedDateupto)
      setState(() {
        // selectedDateupto = picked;
        _uptochosenDateTime = pickedupto;
        upto = _uptochosenDateTime.toString();
      });
    print(_uptochosenDateTime);
  }

  int key = 0;

  late List<Expense> _expense = [];

  Map<String, double> getCategoryData() {
    Map<String, double> catMap = {};
    for (var item in _expense) {
      print(item.category);
      if (catMap.containsKey(item.category) == false) {
        catMap[item.category] = 1;
      } else {
        catMap.update(item.category, (int) => catMap[item.category]! + 1);
        // test[item.category] = test[item.category]! + 1;
      }
      print(catMap);
    }
    return catMap;
  }

  List<Color> colorList = [
    Color.fromRGBO(82, 98, 255, 1),
    Color.fromRGBO(46, 198, 255, 1),
    Color.fromRGBO(123, 201, 82, 1),
    Color.fromRGBO(255, 171, 67, 1),
    Color.fromRGBO(252, 91, 57, 1),
    Color.fromRGBO(139, 135, 130, 1),
  ];

  Widget pieChartExampleOne() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getCategoryData(),
      initialAngleInDegree: 0,
      animationDuration: Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 32,
      colorList: colorList,
      chartLegendSpacing: 32,
      chartValuesOptions: ChartValuesOptions(
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      centerText: 'Mood',
      legendOptions: LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    );
  }

  Map<String, double> dataMap2 = {
    "Empty": 100,
  };

  Widget nullpieChartExampleOne() {
    return PieChart(
      dataMap: dataMap2,
      animationDuration: Duration(milliseconds: 2000),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: [Colors.orange],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: "mood",
      legendOptions: LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    );
  }

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc('npyAZ2U8FjCSXmqxwGXq') //(FirebaseAuth.instance.currentUser!.uid)
      .collection(currentuseremail.toString());
  // .doc('npyAZ2U8FjCSXmqxwGXq')
  // .collection('notes');

  List<Color> myColors = [
    Colors.yellow[200]!,
    Colors.red[200]!,
    Colors.green[200]!,
    Colors.deepPurple[200]!,
    Colors.purple[200]!,
    Colors.cyan[200]!,
    Colors.teal[200]!,
    Colors.tealAccent[200]!,
    Colors.pink[200]!,
  ];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> expStream = FirebaseFirestore.instance
        .collection('users')
        .doc("npyAZ2U8FjCSXmqxwGXq")
        .collection(currentuseremail.toString())
        .orderBy('created', descending: true)
        .where('created', isGreaterThanOrEqualTo: _fromchosenDateTime)
        .where("created", isLessThanOrEqualTo: _uptochosenDateTime)
        .snapshots();

    void getExpfromSanapshot(snapshot) {
      if (snapshot != null) {
        _expense = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          Expense exp = Expense.fromJson(a.data());
          _expense.add(exp);
          // print('this is exp ${exp}');

        }
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) =>
                    AddNote(currentuseremail: currentuseremail),
              ),
            )
                .then((value) {
              print("Calling Set  State !");
              print('$currentuseremail');

              setState(() {});
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white70,
          ),
          backgroundColor: Colors.grey[700],
        ),
        //
        appBar: AppBar(
            title: Text(
              "Journal",
              style: TextStyle(
                fontSize: 32.0,
                fontFamily: "lato",
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width,
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.white,
                      indicatorColor: Color.fromRGBO(8, 120, 93, 3),
                      unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      tabs: [
                        Text('Journal'),
                        Text('Mood Chart'),
                      ],
                    ),
                  ),
                ],
              ),
            )),

        //
        body: Container(
            child: TabBarView(controller: tabController, children: [
          //userjournals

          Container(
              child: Column(children: [
            SizedBox(
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.red),
                controller: TextEditingController(
                    text: "Total Journal: $resultsnotecount"),
                readOnly: true,
              ),
            ),
            Expanded(
                child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc('npyAZ2U8FjCSXmqxwGXq')
                  .collection('notes')
                  .where('creator', isEqualTo: currentuseremail)
                  .orderBy('created', descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance!
                      .addPostFrameCallback((_) => setState(() {
                            resultsnotecount = snapshot.data!.docs.length;
                          }));
                  if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Text(
                        "You have no saved Notes !",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // ignore: unused_local_variable
                      Random random = new Random();
                      Color bg =
                          Colors.yellow[200]!; //myColors[random.nextInt(4)];
                      Map data = snapshot.data!.docs[index].data() as Map;
                      DateTime mydateTime = data['created'].toDate();
                      String formattedTime =
                          DateFormat.yMMMd().add_jm().format(mydateTime);

                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => ViewNote(
                                data,
                                formattedTime,
                                snapshot.data!.docs[index].reference,
                              ),
                            ),
                          )
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: Card(
                          color: bg,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['title']}",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontFamily: "lato",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                // Text(
                                //   "${data['feeling']}",
                                //   style: TextStyle(
                                //     fontSize: 24.0,
                                //     fontFamily: "lato",
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black87,
                                //   ),
                                // ),
                                //
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "lato",
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("Loading..."),
                  );
                }
              },
            )),
          ])),
          //moodgraph
          Container(
              child: Column(children: [
            TextField(
              controller:
                  TextEditingController(text: "Set absolute time range:"),
              readOnly: true,
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/journalscreens');
                  //JOURNAL FUNCTION
                  // _selectTime(context);
                  _selectDatefrom(context);
                  // setState(() {
                  //   from = selectedDatefrom.toString();
                  // });
                },
                color: Colors.black.withOpacity(0.05),
                textColor: Colors.white,
                child: Text(
                  from,
                  // style: GoogleFonts.droidSans(
                  //     fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/journalscreens');
                  //JOURNAL FUNCTION
                  // _selectTime(context);
                  _selectDateupto(context);
                  // setState(() {
                  //   upto = selectedDateupto.toString();
                  // });
                },
                color: Colors.black.withOpacity(0.05),
                textColor: Colors.white,
                child: Text(
                  upto,
                  // style: GoogleFonts.droidSans(
                  //     fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            StreamBuilder<Object>(
              stream: expStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final data2 = snapshot.requireData;
                print("Data: $data2");
                getExpfromSanapshot(data2);
                if (_expense.isNotEmpty) {
                  return pieChartExampleOne();
                } else {
                  return nullpieChartExampleOne();
                }
              },
            ),
          ])),
        ])));
  }
}

class Expense {
  String amount;
  String category;
  String date;
  String description;

  Expense(
      {required this.amount,
      required this.category,
      required this.date,
      required this.description});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json['creator'],
      category: json['mood'],
      date: json['title'],
      description: json['description'],
    );
  }
}
