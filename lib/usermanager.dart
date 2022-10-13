// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String? searcheduser;
TextEditingController _controller = TextEditingController();
late Timer _debounce;
VoidCallback? continueCallBack;
String? userstatusfiltered;

class usermanager extends StatefulWidget {
  const usermanager({Key? key}) : super(key: key);

  @override
  _usermanagerState createState() => _usermanagerState();
}

TextEditingController titleController = new TextEditingController();
// TextEditingController authorController = new TextEditingController();

showAlertDeleteuser(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("continue"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget nobutton = TextButton(
    child: Text("cancel"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert4 = AlertDialog(
    title: Text("padayon:"),
    content: Text("Do you want to delete this user from the system?"),
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

class _usermanagerState extends State<usermanager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _controller.clear();
              setState(() {
                searcheduser = null;
              });
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("MANAGE USERS"),
          backgroundColor: Color.fromRGBO(8, 120, 93, 3),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      } else {
                        setState(() {
                          searcheduser = null;
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
                      hintText: "Search  email address of user",
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          )),
      body: BookList(),
      // ADD (Create)
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromRGBO(8, 120, 93, 3),
      //   onPressed: () {
      //     titleController.clear();
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             content: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: <Widget>[
      //                 Text("Add"),
      //                 Padding(
      //                   padding: EdgeInsets.only(top: 10),
      //                   child: Text(
      //                     "Mood: ",
      //                     textAlign: TextAlign.start,
      //                   ),
      //                 ),
      //                 TextField(
      //                   controller: titleController,
      //                 ),
      //                 // Padding(
      //                 //   padding: EdgeInsets.only(top: 20),
      //                 //   child: Text("Author: "),
      //                 // ),
      //                 // TextField(
      //                 //   controller: authorController,
      //                 // ),
      //               ],
      //             ),
      //             actions: <Widget>[
      //               Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: 10),
      //                 child: RaisedButton(
      //                   color: Colors.red,
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                   child: Text(
      //                     "Undo",
      //                     style: TextStyle(color: Colors.white),
      //                   ),
      //                 ),
      //               ),

      //               //Add Button

      //               RaisedButton(
      //                 onPressed: () {
      //                   // ignore: todo
      // ignore: todo
      //                   //TODO: FirebaseFirestore create a new record code

      //                   Map<String, dynamic> newBook =
      //                       new Map<String, dynamic>();
      //                   newBook["mood"] = titleController.text;
      //                   // newBook["author"] = authorController.text;

      //                   FirebaseFirestore.instance
      //                       .collection("moods")
      //                       .add(newBook)
      //                       .whenComplete(() {
      //                     Navigator.of(context).pop();
      //                   });
      //                 },
      //                 child: Text(
      //                   "save",
      //                   style: TextStyle(color: Colors.blue),
      //                 ),
      //               ),
      //             ],
      //           );
      //         });
      //   },
      //   tooltip: 'Add a Mood',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

// ignore: must_be_immutable
class BookList extends StatefulWidget {
  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  TextEditingController titleController = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userdata')
          .where('email', isEqualTo: searcheduser)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            padding: EdgeInsets.only(bottom: 80),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Update User"),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DropdownButton<String>(
                                    value: null,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    hint: Text(
                                        'current status is ${document['status']}'),
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? _val) {
                                      setState(() {
                                        userstatusfiltered = _val!;
                                      });

                                      print(userstatusfiltered);
                                    },
                                    items: <String>[
                                      'enabled',
                                      'disabled',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: RaisedButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Undo",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                // Update Button
                                RaisedButton(
                                  onPressed: () {
                                    // ignore: todo
                                    //TODO: FirebaseFirestore update a record code

                                    Map<String, dynamic> updateBook =
                                        new Map<String, dynamic>();
                                    updateBook["status"] = userstatusfiltered;
                                    // updateBook["author"] =
                                    //     authorController.text;

                                    // Update FirebaseFirestore record information regular way
                                    FirebaseFirestore.instance
                                        .collection("userdata")
                                        .doc(document.id)
                                        .update(updateBook)
                                        .whenComplete(() {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Text(
                                    "update",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    title: new Text(" " + document['email']),
                    subtitle: new Text("status: " + document['status']),
                    trailing:
                        // Delete Button
                        InkWell(
                      onTap: () async {
                        // ignore: todo
                        //TODO: FirebaseFirestore delete a record code

                        // FirebaseFirestore.instance
                        //     .collection("userdata")
                        //     .doc(document.id)
                        //     .delete()
                        //     .catchError((e) {
                        //   print(e);
                        // });
                        // //delete fireabase auth
                        // FirebaseAuth.instance.signOut();
                        // await FirebaseAuth.instance
                        //     .signInWithEmailAndPassword(
                        //         email: document['email'],
                        //         password: document['pw']);

                        // FirebaseAuth.instance.currentUser!.delete();
                        // FirebaseAuth.instance.signOut();

                        showAlertDeleteuser(BuildContext context) {
                          // set up the button
                          Widget okButton = TextButton(
                            child: Text("continue"),
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection("userdata")
                                  .doc(document.id)
                                  .delete()
                                  .catchError((e) {
                                print(e);
                              });
                              //delete fireabase auth
                              FirebaseAuth.instance.signOut();
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: document['email'],
                                      password: document['pw']);

                              FirebaseAuth.instance.currentUser!.delete();
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                          );
                          Widget nobutton = TextButton(
                            child: Text("cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert4 = AlertDialog(
                            title: Text("padayon:"),
                            content: Text(
                                "Do you want to delete this user from the system?"),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            child: Text("Loading..."),
          );
        }
      },
    );
  }
}
