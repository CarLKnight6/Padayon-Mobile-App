import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:padayon/adminjournalusersearch/addnote.dart';
import 'package:padayon/adminjournalusersearch/viewnote.dart';
// ignore: unused_import
import 'package:padayon/loginscreen.dart';
// ignore: unused_import
import 'package:padayon/navigation_view.dart';

class HomePageSearch extends StatefulWidget {
  HomePageSearch({Key? key, String? currentuseremail}) : super(key: key);
  @override
  _HomePageSearchState createState() => _HomePageSearchState();
}

class _HomePageSearchState extends State<HomePageSearch> {
  getdata() async {
    // ignore: unused_local_variable
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq') //(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

    // await ref.where('mood', isEqualTo: 'sad').get().then((value) {
    //   value.docs.forEach((element) {
    //     print(element.data());
    //   });
    // });
  }
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
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context)
      //         .push(
      //       MaterialPageRoute(
      //         builder: (context) => AddNote(currentuseremail: currentuseremail),
      //       ),
      //     )
      //         .then((value) {
      //       print("Calling Set  State !");
      //       print('$currentuseremail');

      //       setState(() {});
      //     });
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white70,
      //   ),
      //   backgroundColor: Colors.grey[700],
      // ),
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
      ),
      //
      body: FutureBuilder<QuerySnapshot>(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                Random random = new Random();
                Color bg = myColors[random.nextInt(4)];
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
                            "${data['mood']}",
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
    );
  }
}
