// ignore: unused_import
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:io/ansi.dart';
// ignore: unused_import
import 'package:padayon/adminscreen.dart';
import 'adminjournalscreens/viewnote.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key, int? filterednotes}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<String> globalmoodlist = [];

  CollectionReference moodsRef = FirebaseFirestore.instance.collection('moods');
  final db = FirebaseFirestore.instance;
  var showSelectedItem = null;
  String? filteredmood;
  int? resultnotescount;
  int? filterednotecount;
  String notestatusfiltered = 'Select Journal Status';
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

//   void countDocuments() async {
//     List<DocumentSnapshot> _myDocCount;

//     QuerySnapshot _myDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc('npyAZ2U8FjCSXmqxwGXq')
//         .collection('notes')
//         .where('mood', isEqualTo: filteredmood)
//         .get();
//     _myDocCount = _myDoc.docs;

//     print(_myDocCount.length);

// // Count of Documents in Collection

//     setState(() {
//       filterednotes = _myDocCount.length;
//     });
//   }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMoods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            title: Text("All user notes"),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            centerTitle: true,
          ),
        ),
        body: Stack(children: [
          Positioned(
            child: SizedBox(height: 100),
          ),
          Positioned(
              child: Column(
            children: [
              TextField(
                controller: TextEditingController(
                    text: "Select a journal mood to filter:"),
                readOnly: true,
              ),
              DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  items: globalmoodlist,
                  // ignore: deprecated_member_use
                  label: "",
                  // ignore: deprecated_member_use
                  hint: "select a mood to filter journals",
                  popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (val) {
                    setState(() {
                      filteredmood = val!;
                      // countDocuments();

                      print('the global list: $globalmoodlist');
                    });
                  },
                  selectedItem: "select"),
              DropdownButton<String>(
                value: null,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                hint: Text('${notestatusfiltered}'),
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
                  'unchecked',
                  'checked',
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
                      text: "Journal results: $resultnotescount"),
                  readOnly: true,
                ),
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc('npyAZ2U8FjCSXmqxwGXq')
                      .collection('notes')
                      .orderBy('created', descending: true)
                      .where('mood', isEqualTo: filteredmood)
                      .where('notestatus', isEqualTo: notestatusfiltered)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
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
                          // print(snapshot.data!.docs.length);

                          //filterednotes = snapshot.data!.docs.length

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
                                        "${data['notestatus']}",
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
                                        "${data['creator']}",
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
                ),
              ),
            ],
          ))
        ]));
  }
}
