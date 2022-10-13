// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:padayon/loginscreen.dart';
// ignore: unused_import
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:padayon/settaskscreens/timezone.dart';
import 'package:pie_chart/pie_chart.dart';

class DatePicker extends StatefulWidget {
  DatePicker({Key? key, String? currentuseremail}) : super(key: key);
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> with TickerProviderStateMixin {
  TabController? tabController;

  DateTime? _fromchosenDateTime;
  DateTime? _uptochosenDateTime;
  String from = 'from';
  String upto = 'up to';
  int? resulttaskcount;
  int key = 0;

  late List<Expense2> _Expense2 = [];
  String? notestatusfiltered;
  Map<String, double> getCategoryData() {
    Map<String, double> catMap = {};
    for (var item in _Expense2) {
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
      centerText: 'Tasks status',
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

  DateTime selectedDatefrom = DateTime.now();
  DateTime selectedDateupto = DateTime.now();
  DateTime? dt;
  TimeOfDay? time;
  late var selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  Map<int, String> monthsInYear = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };
  FlutterLocalNotificationsPlugin fltrNotification =
      new FlutterLocalNotificationsPlugin();
  TextEditingController titleController = new TextEditingController();
  List alarms = [];
  int counter = 0;
  List<Item>? reminders;
  String? reminder;
  String? task;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    dt = DateTime.now();
    time = TimeOfDay.now();
    var androidInitialize = new AndroidInitializationSettings('padayon_icon');
    // var androidInitialize =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitialize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSinitialize);
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future _sNotification(DateTime scheduledTime, int id) async {
    var androidDetails = new AndroidNotificationDetails("1", "padayon",
        icon: "padayon_icon",
        importance: Importance.max,
        enableVibration: true);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    final timeZone = TimeZone();

    // The device's timezone.
    var timeZoneName = await timeZone.getTimeZoneName();

    // Find the 'current location'
    final location = await timeZone.getLocation(timeZoneName);

    final st = tz.TZDateTime.from(scheduledTime, location);
    fltrNotification.zonedSchedule(
        counter, "padayon", alarms[id][4], st, generalNotificationDetails,
        androidAllowWhileIdle: true,
        payload:
            '${alarms[id][4]} at ${alarms[id][1].hourOfPeriod}:${DatePickerState().getminute(alarms[id][1])} ${DatePickerState().getm(alarms[id][1])}',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    setState(() {
      alarms[id][2] = st;
      alarms[id][3] = counter;
      counter = counter + 1;
    });
  }

  Future cancelAllNotifications() async {
    await fltrNotification.cancelAll();
    setState(() {
      alarms = [];
      reminders = generateItems(alarms);
    });
  }

  Future cancelNotification(int id, int index) async {
    await fltrNotification.cancel(id);
    setState(() {
      alarms.removeAt(index);
      reminders?.removeAt(index) ?? 0;
    });
  }

  tz.TZDateTime _nextInstanceOf(int index) {
    final now = alarms[index][2];
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  String? userstatusfiltered;
  Future<void> _scheduleDailyNotification(int index) async {
    await fltrNotification.zonedSchedule(
        counter,
        'Daily Notification',
        'Daily Reminder',
        _nextInstanceOf(index),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'index',
            'Daily notification',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);

    setState(() {
      counter = counter + 1;
    });
  }

  Future<void> _scheduleWeeklyNotification(int index) async {
    await fltrNotification.zonedSchedule(
        counter,
        'Weekly Notification',
        'Weekly Reminder',
        _nextInstanceOf(index),
        const NotificationDetails(
          android: AndroidNotificationDetails('index', 'Weekly notification'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    setState(() {
      counter = counter + 1;
    });
  }

  showAlertDialognotaskfinished(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("finished"),
      onPressed: () {
        Map<String, dynamic> newBook = new Map<String, dynamic>();
        newBook["task"] = task;
        newBook["status"] = 'finished';
        newBook["user"] = currentuseremail;
        newBook['created'] = DateTime.now();

        FirebaseFirestore.instance
            .collection("tasks")
            .add(newBook)
            .whenComplete(() {});
        print(task);
        Navigator.of(context, rootNavigator: true).pop();
        cancelAllNotifications();

        // Navigator.pushNamed(context, "/settaskscreens");
        // Navigator.pop(context, false);
      },
    );

    Widget cancelbutton = TextButton(
      child: Text("unfinished"),
      onPressed: () {
        Map<String, dynamic> newBook = new Map<String, dynamic>();
        newBook["task"] = task;
        newBook["status"] = 'unfinished';
        newBook["user"] = currentuseremail;
        newBook['created'] = DateTime.now();

        FirebaseFirestore.instance
            .collection("tasks")
            .add(newBook)
            .whenComplete(() {});
        print(task);
        Navigator.of(context, rootNavigator: true).pop();
        cancelAllNotifications();

        // Navigator.pushNamed(context, "/settaskscreens");
        // Navigator.pop(context, false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert4 = AlertDialog(
      title: Text("padayon:"),
      content: Text("mark as finished task"),
      actions: [okButton, cancelbutton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert4;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> taskStream = FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('created', descending: true)
        .where('created', isGreaterThanOrEqualTo: _fromchosenDateTime)
        .where("created", isLessThanOrEqualTo: _uptochosenDateTime)
        .where("user", isEqualTo: currentuseremail)
        .snapshots();

    void getExpfromSanapshot2(snapshot) {
      if (snapshot != null) {
        _Expense2 = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          Expense2 exp = Expense2.fromJson(a.data());
          _Expense2.add(exp);
          // print(exp);
        }
      }
    }

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
              title: const Text('padayon'),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
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
                          Text('set task'),
                          Text('task list'),
                          Text('task chart'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Color.fromRGBO(8, 120, 93, 3),
              actions: [
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      cancelAllNotifications();
                    })
              ]),
          body: Container(
              child: TabBarView(controller: tabController, children: [
            ListView(
              children: <Widget>[
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      reminders?[index].isExpanded = !isExpanded; //SUS
                    });
                  },
                  children: reminders?.map<ExpansionPanel>((Item item) {
                        return ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder: (context, isExpanded) {
                              return Row(children: [
                                Expanded(
                                    child: ListTile(
                                  title: Text(item.headerValue),
                                  trailing:
                                      // Delete Button
                                      InkWell(
                                    onTap: () {
                                      setState(() {
                                        task = item.headerValue;
                                      });
                                      showAlertDialognotaskfinished(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Icon(Icons.done),
                                    ),
                                  ),
                                )),
                                // IconButton(icon: Icon(Icons.edit), onPressed: null),
                                Switch(
                                  value: item.toggle,
                                  onChanged: (value) {
                                    setState(() {
                                      item.toggle = !item.toggle;
                                      if (!value) {
                                        fltrNotification.cancel(item.id);
                                      }
                                      if (value) {
                                        _sNotification(
                                            alarms[reminders?.indexOf(item) ??
                                                0][2],
                                            reminders?.indexOf(item) ?? 0);
                                      }
                                    });
                                  },
                                )
                              ]);
                            },
                            body: Column(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                        title: Text(
                                      item.expandedValue,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    )),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                      color: Colors.purple[900],
                                      onPressed: () {
                                        editReminder(
                                            reminders?.indexOf(item) ?? 0);
                                      }),
                                  IconButton(
                                      color: Colors.purple[900],
                                      icon: Icon(
                                        Icons.event,
                                      ),
                                      onPressed: () {
                                        editDate(context,
                                            reminders?.indexOf(item) ?? 0);
                                      }),
                                  IconButton(
                                      color: Colors.purple[900],
                                      icon: Icon(
                                        Icons.access_time,
                                      ),
                                      onPressed: () {
                                        editTime(context,
                                            reminders?.indexOf(item) ?? 0);
                                      }),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      cancelNotification(
                                          alarms[reminders?.indexOf(item) ?? 0]
                                              [3],
                                          reminders?.indexOf(item) ?? 0);
                                      print(task);
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              2.0, 0.0, 0.0, 20.0),
                                          child: Column(children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.alarm,
                                                color: item.dailyColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (item.daily) {
                                                    fltrNotification
                                                        .cancel(item.did);
                                                    item.dailyColor =
                                                        Colors.black;
                                                    item.daily = false;
                                                  } else {
                                                    item.did = counter;
                                                    _scheduleDailyNotification(
                                                        reminders?.indexOf(
                                                                item) ??
                                                            0);
                                                    item.dailyColor =
                                                        Colors.red;
                                                    item.daily = true;
                                                  }
                                                });
                                              },
                                            ),
                                            Text('Daily Reminder')
                                          ]))),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              2.0, 0.0, 0.0, 20.0),
                                          child: Column(children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.alarm,
                                                color: item.weeklyColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (item.weekly) {
                                                    fltrNotification
                                                        .cancel(item.wid);
                                                    item.weeklyColor =
                                                        Colors.black;
                                                    item.weekly = false;
                                                  } else {
                                                    item.wid = counter;
                                                    _scheduleWeeklyNotification(
                                                        reminders?.indexOf(
                                                                item) ??
                                                            0);
                                                    item.weeklyColor =
                                                        Colors.red;
                                                    item.weekly = true;
                                                  }
                                                });
                                              },
                                            ),
                                            Text('Weekly'),
                                          ]))),
                                ],
                              )
                            ]),
                            isExpanded: item.isExpanded);
                      }).toList() ??
                      [],
                ),
              ],
            ),
            //tasklists
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
                    _selectDatefrom(context);
                  },
                  color: Colors.black.withOpacity(0.05),
                  textColor: Colors.white,
                  child: Text(
                    from,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    _selectDateupto(context);
                  },
                  color: Colors.black.withOpacity(0.05),
                  textColor: Colors.white,
                  child: Text(
                    upto,
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
                      text: "Task results: $resulttaskcount"),
                  readOnly: true,
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tasks')
                          .orderBy('created', descending: true)
                          .where('created',
                              isGreaterThanOrEqualTo: _fromchosenDateTime)
                          .where("created",
                              isLessThanOrEqualTo: _uptochosenDateTime)
                          .where('user', isEqualTo: currentuseremail)
                          .where('status', isEqualTo: notestatusfiltered)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((_) => setState(() {
                                    resulttaskcount =
                                        snapshot.data!.docs.length;
                                  }));

                          if (snapshot.data!.docs.length == 0) {
                            return Center(
                              child: Text(
                                "You have no marked tasks !",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }

                          return new ListView(
                            padding: EdgeInsets.only(bottom: 80),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              DateTime mydateTime =
                                  document['created'].toDate();
                              String formattedTime = DateFormat.yMMMd()
                                  .add_jm()
                                  .format(mydateTime);
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Update Task Status"),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  DropdownButton<String>(
                                                    value: null,
                                                    icon: const Icon(
                                                        Icons.arrow_downward),
                                                    elevation: 16,
                                                    hint: Text(
                                                        'current status is ${document['status']}'),
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                    ),
                                                    onChanged: (String? _val) {
                                                      setState(() {
                                                        userstatusfiltered =
                                                            _val!;
                                                      });

                                                      print(userstatusfiltered);
                                                    },
                                                    items: <String>[
                                                      'finished',
                                                      'unfinished',
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  Text(
                                                    "status: ${document['status']}",
                                                    textAlign: TextAlign.start,
                                                  ),

                                                  // Padding(
                                                  //   padding: EdgeInsets.only(top: 20),
                                                  //   child: Text("Author: "),
                                                  // ),
                                                  // TextField(
                                                  //   controller: authorController,
                                                  //   decoration: InputDecoration(
                                                  //     hintText: document['author'],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: RaisedButton(
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Undo",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                // Update Button
                                                RaisedButton(
                                                  onPressed: () {
                                                    // ignore: todo
                                                    //TODO: FirebaseFirestore update a record code

                                                    Map<String, dynamic>
                                                        updateBook = new Map<
                                                            String, dynamic>();
                                                    updateBook["status"] =
                                                        userstatusfiltered;
                                                    // updateBook["author"] =
                                                    //     authorController.text;

                                                    // Update FirebaseFirestore record information regular way
                                                    FirebaseFirestore.instance
                                                        .collection("tasks")
                                                        .doc(document.id)
                                                        .update(updateBook)
                                                        .whenComplete(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                  child: Text(
                                                    "update",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },

                                    title: new Text(" " + document['task']),
                                    subtitle: new Text(
                                        "status:  ${document['status']}\ncreated: ${formattedTime}"),
                                    // ==subtitle: new Text("Author " + document['author']),
                                    trailing:

                                        // Delete Button
                                        InkWell(
                                      onTap: () {
                                        showAlertDeleteuser(
                                            BuildContext context) {
                                          // set up the button
                                          Widget okButton = TextButton(
                                            child: Text("continue"),
                                            onPressed: () async {
                                              FirebaseFirestore.instance
                                                  .collection("tasks")
                                                  .doc(document.id)
                                                  .delete()
                                                  .catchError((e) {
                                                print(e);
                                              });
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          );
                                          Widget nobutton = TextButton(
                                            child: Text("cancel"),
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert4 = AlertDialog(
                                            title: Text("padayon:"),
                                            content:
                                                Text("remove from task list?"),
                                            actions: [okButton, nobutton],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert4;
                                            },
                                          );
                                        }

                                        showAlertDeleteuser(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Icon(Icons.delete),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Center(
                            child: Text("Not found!"),
                          );
                        }
                      },
                    ),
                  ))
            ])),

            //taskschart
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
                  if (_Expense2.isNotEmpty) {
                    return pieChartExampleOne();
                  } else {
                    return nullpieChartExampleOne();
                  }
                },
              ),
            ])),
          ])),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              pickDate(context, null);
            },
            child: Icon(Icons.event),
            tooltip: 'Add',
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }

  Future notificationSelected(String? payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future picktime(BuildContext context, int? index) async {
    TimeOfDay tod = TimeOfDay.now();
    TimeOfDay? t = await showTimePicker(
      context: context,
      // ignore: unnecessary_null_comparison
      initialTime: (index != null)
          ? alarms[index][1]
          : TimeOfDay(
              hour: tod.hour,
              minute: (tod.minute == 59) ? tod.minute : tod.minute + 1),
    );
    if (t != null) {
      int? l = alarms.length;
      time = t;
      int? index = l;
      DateTime? st = dt!
          .add(Duration(hours: t.hour, minutes: t.minute, seconds: 5)); //sus2

      setState(() async {
        await setReminder();
        if (st.isAfter(DateTime.now())) {
          _sNotification(st, index);
          if (reminder != null) {
            alarms.insert(l, [dt, time, false, counter, reminder]);
            reminder = null;
            reminders = generateItems(alarms);
          }
        }
      });
    }
  }

  Future pickDate(BuildContext context, int? index) async {
    DateTime? date = await showDatePicker(
      context: context,
      // ignore: unnecessary_null_comparison
      initialDate: (index != null) ? alarms[index][0] : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2023), //change per year
    );
    if (date != null) {
      setState(() {
        dt = date;
      });
      picktime(context, index);
    }
  }

  getminute(t) {
    if (t.minute < 10)
      return "0" + t.minute.toString();
    else
      return t.minute;
  }

  getm(t) {
    if (t.period.toString() == "DayPeriod.am")
      return "am";
    else
      return "pm";
  }

  setReminder() async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(children: [
        Container(
            padding: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) => (value == "" ||
                              value == " " ||
                              value == "  " ||
                              value == "   " ||
                              value == "    " ||
                              value == "     " ||
                              value == "      " ||
                              value == "       " ||
                              value == "        " ||
                              value == "          " ||
                              value == "           " ||
                              value == "            " ||
                              value == "             " ||
                              value == "              ")
                          ? "Please Enter Reminder Details"
                          : null,
                      onSaved: (input) => reminder = input,
                      decoration: InputDecoration(
                          labelText: 'Enter Reminder Details',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                // Navigator.pop(context, reminder);
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Submit'))
                      ],
                    )
                  ],
                ))),
      ]),
    );
  }

  editDate(BuildContext context, int index) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: alarms[index][0],
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate != null) {
      List newdateTime = [newDate, alarms[index][1], false];
      if (newdateTime[0] != alarms[index][0] ||
          newdateTime[1] != alarms[index][1]) {
        DateTime nst = dt!.add(Duration(
            hours: alarms[index][1].hour, minutes: alarms[index][1].minute));
        await fltrNotification.cancel(alarms[index][3]);
        await _sNotification(nst, index);
        setState(() {
          alarms[index][0] = newdateTime[0];
          alarms[index][1] = newdateTime[1];
          reminders = generateItems(alarms);
        });
      }
    }
  }

  editTime(BuildContext context, int index) async {
    TimeOfDay? newtime = await showTimePicker(
      context: context,
      initialTime: alarms[index][1],
    );
    if (newtime != null) {
      List newdateTime = [alarms[index][0], newtime, false];

      if (newdateTime[0] != alarms[index][0] ||
          newdateTime[1] != alarms[index][1]) {
        DateTime nst = newdateTime[0]
            .add(Duration(hours: newtime.hour, minutes: newtime.minute));
        await fltrNotification.cancel(alarms[index][3]);
        await _sNotification(nst, index);
        setState(() {
          alarms[index][0] = newdateTime[0];
          alarms[index][1] = newdateTime[1];
          reminders = generateItems(alarms);
        });
      }
    }
  }

  editAlarm(BuildContext context, int index) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: alarms[index][0],
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate != null) {
      TimeOfDay? newtime = await showTimePicker(
        context: context,
        initialTime: alarms[index][1],
      );
      if (newtime != null) {
        List newdateTime = [newDate, newtime, false];

        if (newdateTime[0] != alarms[index][0] ||
            newdateTime[1] != alarms[index][1]) {
          DateTime nst =
              dt!.add(Duration(hours: newtime.hour, minutes: newtime.minute));
          await fltrNotification.cancel(alarms[index][3]);
          await _sNotification(nst, index);
          setState(() {
            alarms[index][0] = newdateTime[0];
            alarms[index][1] = newdateTime[1];
            reminders = generateItems(alarms);
          });
        }
      }
    }
  }

  editReminder(int index) async {
    await setReminder();
    if (reminder != null) {
      setState(() {
        alarms[index][4] = reminder;
        DateTime st = alarms[index][0].add(Duration(
            hours: alarms[index][1].hour, minutes: alarms[index][1].minute));
        fltrNotification.cancel(alarms[index][3]);
        _sNotification(st, index);
        reminders = generateItems(alarms);
      });
    }
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
    this.daily = false,
    this.did = 0,
    this.wid = 0,
    // this.monthly = false,
    this.weekly = false,
    this.dailyColor = Colors.black,
    this.weeklyColor = Colors.black,
    this.toggle = true,
    required this.id,
    // this.monthlyColor = Colors.black,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  bool daily;
  bool weekly;
  bool toggle;
  int did;
  int wid;
  int id;
  // bool monthly;
  Color dailyColor;
  Color weeklyColor;
  // Color monthlyColor;
}

List<Item> generateItems(List reminders) {
  return List.generate(reminders.length, (int index) {
    return Item(
      id: reminders[index][3],
      headerValue: '${reminders[index][4]}',
      expandedValue:
          '${reminders[index][0].day} ${DatePickerState().monthsInYear[reminders[index][0].month]} ${reminders[index][0].year} , ${reminders[index][1].hourOfPeriod}:${DatePickerState().getminute(reminders[index][1])} ${DatePickerState().getm(reminders[index][1])}',
    );
  });
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
      date: json['status'],
      description: json['task'],
    );
  }
}
