import 'dart:async';
import 'dart:math';

// ignore: unused_import
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padayon/adminscreen.dart';
import 'package:pie_chart/pie_chart.dart';
// ignore: unused_import
import 'adminjournalusersearch/viewnote.dart';

class TaskFilter extends StatefulWidget {
  const TaskFilter({Key? key, int? filterednotes}) : super(key: key);

  @override
  _TaskFilterState createState() => _TaskFilterState();
}

class _TaskFilterState extends State<TaskFilter> with TickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  var showSelectedItem = null;
  String? selectedmonth;
  int? resultnotescount;
  String? notestatusfiltered;
  TextEditingController _controller = TextEditingController();
  // ignore: unused_field
  late StreamController _streamController;
  List<String> lst = [];
  DateTime? _fromchosenDateTime;
  DateTime? _uptochosenDateTime;
  late Timer _debounce;
  String? searcheduser;
  String? filteredmood;
  List<String> globalmoodlist = [];
  String from = 'from';
  String upto = 'up to';
  DateTime selectedDatefrom = DateTime.now();
  DateTime selectedDateupto = DateTime.now();

  CollectionReference moodsRef = FirebaseFirestore.instance.collection('moods');

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
  // _search() async {
  //   if (_controller.text.length == 0) {
  //     _streamController.add(null);
  //     return;
  //   }

  //   _streamController.add("waiting");
  //   setState(() {
  //     searcheduser = _controller.text.trim();
  //   });
  // }

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

  getMoods() async {
    List<String> moodList = [];
    QuerySnapshot snapshot = await moodsRef.get();
    snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      moodList.add(data['mood']);
    });
    setState(() {
      globalmoodlist = moodList;
    });
    // print(moodList);
    // print('thegloballist here : $globalmoodlist');
  }

  void countDocuments() async {
    List<DocumentSnapshot> _myDocCount;

    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq')
        .collection('notes')
        .where('mood', isEqualTo: filteredmood)
        .get();
    _myDocCount = _myDoc.docs;

    print(_myDocCount.length);

// Count of Documents in Collection

    setState(() {
      filterednotes = _myDocCount.length;
    });
  }

  //tasks
  DateTime? _fromchosenDateTime2;
  DateTime? _uptochosenDateTime2;
  TextEditingController _controller2 = TextEditingController();
  String? searcheduser2;
  String from2 = 'from';
  String upto2 = 'up to';
  DateTime selectedDatefrom2 = DateTime.now();
  DateTime selectedDateupto2 = DateTime.now();
  TabController? tabController;

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

  int key = 0;
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

  List<Color> colorList = [
    Color.fromRGBO(82, 98, 255, 1),
    Color.fromRGBO(46, 198, 255, 1),
    Color.fromRGBO(123, 201, 82, 1),
    Color.fromRGBO(255, 171, 67, 1),
    Color.fromRGBO(252, 91, 57, 1),
    Color.fromRGBO(139, 135, 130, 1),
  ];

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
      centerText: 'Task',
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
      centerText: "Task",
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMoods());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Stream<QuerySnapshot> taskStream = FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('created', descending: true)
        .where('created', isGreaterThanOrEqualTo: _fromchosenDateTime2)
        .where("created", isLessThanOrEqualTo: _uptochosenDateTime2)
        .where('user', isEqualTo: searcheduser2)
        .snapshots();

    void getExpfromSanapshot(snapshot) {
      if (snapshot != null) {
        _expense2 = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          Expense2 exp = Expense2.fromJson(a.data());
          _expense2.add(exp);
          // print('this is exp ${exp}');

        }
      }
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
              title: Text("User Tasks Status"),
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
                          Text('Tasks List'),
                          Text('Tasks Status Graph'),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
        body: Container(
            child: TabBarView(controller: tabController, children: [
          //tasklist

          Stack(children: [
            Positioned(
                child: Column(
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
                          print(searcheduser);
                          countDocuments();
                        });
                      }
                    },
                    onChanged: (String text) {
                      if (_debounce.isActive) _debounce.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        setState(() {
                          searcheduser = _controller.text.trim();
                          print(searcheduser);
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
                // DropdownSearch<String>(
                //     mode: Mode.MENU,
                //     showSelectedItems: true,
                //     items: globalmoodlist,
                //     // ignore: deprecated_member_use
                //     label: "",
                //     // ignore: deprecated_member_use
                //     hint: "select a mood to filter journals",
                //     popupItemDisabled: (String s) => s.startsWith('I'),
                //     onChanged: (val) {
                //       setState(() {
                //         filteredmood = val!;
                //         countDocuments();

                //         print('the global list: $globalmoodlist');
                //       });
                //     },
                //     selectedItem: "select mood"),
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
                      //   from = _fromchosenDateTime.toString();
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
                      // setState(() {});
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
                DropdownButton<String>(
                  value: null,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  hint: Text(
                      '${notestatusfiltered == null ? 'Select Task Status' : notestatusfiltered}'),
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? _val) {
                    setState(() {
                      notestatusfiltered = _val!;
                      print(notestatusfiltered);
                    });
                  },
                  items: <String>[
                    'finished',
                    'unfinished',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                SizedBox(
                  height: 50,
                  child: TextField(
                    style: TextStyle(color: Colors.red),
                    controller: TextEditingController(
                        text: "Task results: $resultnotescount"),
                    readOnly: true,
                  ),
                ),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('tasks')
                        .orderBy('created', descending: true)
                        .where('user', isEqualTo: searcheduser)
                        .where('created',
                            isGreaterThanOrEqualTo: _fromchosenDateTime)
                        .where("created",
                            isLessThanOrEqualTo: _uptochosenDateTime)
                        .where('status', isEqualTo: notestatusfiltered)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // WidgetsBinding.instance!.addPostFrameCallback((_) {
                        //   setState(() {

                        //   });
                        // });

                        WidgetsBinding.instance!
                            .addPostFrameCallback((_) => setState(() {
                                  resultnotescount = snapshot.data!.docs.length;
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

                            Color bg = myColors[(2)];
                            Map data = snapshot.data!.docs[index].data() as Map;
                            DateTime mydateTime = data['created'].toDate();
                            String formattedTime =
                                DateFormat.yMMMd().add_jm().format(mydateTime);

                            return InkWell(
                              onTap: () {
                                // Navigator.of(context)
                                //     .push(
                                //   MaterialPageRoute(
                                //     builder: (context) => ViewNote(
                                //       data,
                                //       formattedTime,
                                //       snapshot.data!.docs[index].reference,
                                //     ),
                                //   ),
                                // )
                                //     .then((value) {
                                //   setState(() {});
                                // });
                              },
                              child: Card(
                                color: bg,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data['task']}",
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
                                          "${data['status']}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "lato",
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
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
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "${data['user']}",
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
                          child: Text("Not found!"),
                        );
                      }
                    },
                  ),
                ),
              ],
            ))
          ]),

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
                final data2 = snapshot.requireData;
                print("Data: $data2");
                getExpfromSanapshot(data2);
                if (_expense2.isNotEmpty) {
                  return pieChartExampleOne2();
                } else {
                  return nullpieChartExampleOne();
                }
              },
            ),
          ])),
        ])));
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
