import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class moodsgraph extends StatefulWidget {
  const moodsgraph({Key? key}) : super(key: key);

  @override
  State<moodsgraph> createState() => _moodsgraphState();
}

class _moodsgraphState extends State<moodsgraph> with TickerProviderStateMixin {
  DateTime? _fromchosenDateTime;
  DateTime? _uptochosenDateTime;
  DateTime? _fromchosenDateTime2;
  DateTime? _uptochosenDateTime2;
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  String? searcheduser;
  String? searcheduser2;
  String from = 'from';
  String upto = 'up to';
  String from2 = 'from';
  String upto2 = 'up to';
  late Timer _debounce;
  DateTime selectedDatefrom = DateTime.now();
  DateTime selectedDateupto = DateTime.now();
  DateTime selectedDatefrom2 = DateTime.now();
  DateTime selectedDateupto2 = DateTime.now();

  int key = 0;
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

  //
  Future<void> _selectDatefrom2(BuildContext context) async {
    final DateTime? pickedfrom = await showDatePicker(
        context: context,
        initialDate: selectedDatefrom2,
        firstDate: DateTime(2021, 1, 1),
        lastDate: DateTime(2101, 1, 1));
    if (pickedfrom != null && pickedfrom != selectedDatefrom2)
      setState(() {
        // selectedDatefrom = picked;
        _fromchosenDateTime2 = pickedfrom;
        from2 = _fromchosenDateTime2.toString();
      });
    print(_fromchosenDateTime2);
  }

  Future<void> _selectDateupto2(BuildContext context) async {
    final DateTime? pickedupto = await showDatePicker(
        context: context,
        initialDate: selectedDateupto2,
        firstDate: DateTime(2021, 1, 1),
        lastDate: DateTime(2101, 1, 1));
    if (pickedupto != null && pickedupto != selectedDateupto2)
      setState(() {
        // selectedDateupto = picked;
        _uptochosenDateTime2 = pickedupto;
        upto2 = _uptochosenDateTime2.toString();
      });
    print(_uptochosenDateTime2);
  }

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

  //---------------------taskchart------------

  late List<Expense2> _expense2 = [];

  Map<String, double> getCategoryData2() {
    Map<String, double> catMap2 = {};
    for (var item in _expense2) {
      print(item.category);
      if (catMap2.containsKey(item.category) == false) {
        catMap2[item.category] = 1;
      } else {
        catMap2.update(item.category, (int) => catMap2[item.category]! + 1);
        // test[item.category] = test[item.category]! + 1;
      }
      print(catMap2);
    }
    return catMap2;
  }

  //---------------------------------
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

  //------fortaskcharpiechart

  Widget pieChartExampleOne2() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getCategoryData2(),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final Stream<QuerySnapshot> taskStream = FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('created', descending: true)
        .where('user', isEqualTo: searcheduser2)
        .where('created', isGreaterThanOrEqualTo: _fromchosenDateTime2)
        .where("created", isLessThanOrEqualTo: _uptochosenDateTime2)
        .snapshots();

    void getExpfromSanapshot2(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _expense2 = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a2 = snapshot.docs[i];
          // print(a.data());
          Expense2 exp2 = Expense2.fromJson(a2.data());
          _expense2.add(exp2);
          // print(exp);
        }
      }
    }

    final Stream<QuerySnapshot> expStream = FirebaseFirestore.instance
        .collection('users')
        .doc("npyAZ2U8FjCSXmqxwGXq")
        .collection("notes")
        .orderBy('created', descending: true)
        .where('created', isGreaterThanOrEqualTo: _fromchosenDateTime)
        .where("created", isLessThanOrEqualTo: _uptochosenDateTime)
        .where('creator', isEqualTo: searcheduser)
        .snapshots();

    void getExpfromSanapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _expense = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          Expense exp = Expense.fromJson(a.data());
          _expense.add(exp);
          // print(exp);
        }
      }
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
              title: Text("Moods Graphical Representation"),
              backgroundColor: Color.fromRGBO(8, 120, 93, 3),
              centerTitle: true,
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
                          Text('Mood Graph'),
                          Text('Task Graph'),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
        body: Container(
            child: TabBarView(controller: tabController, children: [
          //moodgraph
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onFieldSubmitted: (_) async {
                      if (_controller.text.isNotEmpty) {
                        setState(() {
                          searcheduser = _controller.text.trim();
                        });
                      }
                    },
                    onChanged: (String text) {
                      if (_debounce.isActive) _debounce.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        setState(() {
                          searcheduser = _controller.text.trim();
                        });
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter email of the specific user",
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
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
                    return pieChartExampleOne();
                  },
                ),
              ],
            ),
          ),
          //taskgraph
          Container(
              child: Column(children: [
            Container(
              margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextFormField(
                onFieldSubmitted: (_) async {
                  if (_controller2.text.isNotEmpty) {
                    setState(() {
                      searcheduser2 = _controller2.text.trim();
                    });
                  }
                },
                onChanged: (String text) {
                  if (_debounce.isActive) _debounce.cancel();
                  _debounce = Timer(const Duration(milliseconds: 1000), () {
                    setState(() {
                      searcheduser2 = _controller2.text.trim();
                    });
                  });
                },
                controller: _controller2,
                decoration: InputDecoration(
                  hintText: "Enter email of the specific user",
                  contentPadding: const EdgeInsets.only(left: 24.0),
                  border: InputBorder.none,
                ),
              ),
            ),
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
                  _selectDatefrom2(context);
                  // setState(() {
                  //   from = selectedDatefrom.toString();
                  // });
                },
                color: Colors.black.withOpacity(0.05),
                textColor: Colors.white,
                child: Text(
                  from2,
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
                  _selectDateupto2(context);
                  // setState(() {
                  //   upto = selectedDateupto.toString();
                  // });
                },
                color: Colors.black.withOpacity(0.05),
                textColor: Colors.white,
                child: Text(
                  upto2,
                  // style: GoogleFonts.droidSans(
                  //     fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            StreamBuilder<Object>(
              stream: taskStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final data = snapshot.requireData;
                print("Data: $data");
                getExpfromSanapshot2(data);
                return pieChartExampleOne2();
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

class Expense2 {
  String amount;
  String category;
  String date;
  String description;

  Expense2(
      {required this.amount,
      required this.category,
      required this.date,
      required this.description});

  factory Expense2.fromJson(Map<String, dynamic> json) {
    return Expense2(
      amount: json['user'],
      category: json['status'],
      date: json['task'],
      description: json['task'],
    );
  }
}
