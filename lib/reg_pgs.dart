// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class pgsmanager extends StatefulWidget {
  const pgsmanager({Key? key}) : super(key: key);

  @override
  _pgsmanagerState createState() => _pgsmanagerState();
}

TextEditingController titleController = new TextEditingController();
TextEditingController authorController = new TextEditingController();

class _pgsmanagerState extends State<pgsmanager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MANAGE PGS USERS"),
        backgroundColor: Color.fromRGBO(8, 120, 93, 3),
      ),
      body: BookList(),
      // ADD (Create)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(8, 120, 93, 3),
        onPressed: () {
          titleController.clear();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Add"),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Username: ",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextField(
                        controller: titleController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Password: "),
                      ),
                      TextField(
                        controller: authorController,
                      ),
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

                    //Add Button

                    RaisedButton(
                      onPressed: () {
                        // ignore: todo
                        //TODO: FirebaseFirestore create a new record code

                        Map<String, dynamic> newBook =
                            new Map<String, dynamic>();
                        newBook["username"] = titleController.text;
                        newBook["pw"] = authorController.text;
                        newBook["status"] = 'enabled';
                        newBook["type"] = 'pgs-user';
                        FirebaseFirestore.instance
                            .collection("pgsaccount")
                            .add(newBook)
                            .whenComplete(() {});

                        Map<String, dynamic> newchanneluser =
                            new Map<String, dynamic>();
                        newchanneluser["currentuser"] = titleController.text;
                        newchanneluser["status"] = 'offline';
                        newchanneluser["channelname"] = 'testchannel';
                        FirebaseFirestore.instance
                            .collection("agorachannels")
                            .add(newchanneluser)
                            .whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        "save",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                );
              });
        },
        tooltip: 'Add a Mood',
        child: Icon(Icons.add),
      ),
    );
  }
}

// ignore: must_be_immutable
class BookList extends StatelessWidget {
  TextEditingController titleController = new TextEditingController();
  // TextEditingController authorController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    //TODO: Retrive all records in collection from FirebaseFirestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pgsaccount').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return new ListView(
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
                                title: Text("Edit Password"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "pw: ",
                                      textAlign: TextAlign.start,
                                    ),
                                    TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        hintText: document['pw'],
                                      ),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                                      updateBook["pw"] = titleController.text;
                                      // updateBook["author"] =
                                      //     authorController.text;

                                      // Updae FirebaseFirestore record information regular way
                                      FirebaseFirestore.instance
                                          .collection("pgsaccount")
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
                      title: new Text(" " + document['username']),
                      // subtitle: new Text("Author " + document['author']),
                      trailing:
                          // Delete Button
                          InkWell(
                        onTap: () {
                          showAlertDeleteuser(BuildContext context) {
                            // set up the button
                            Widget okButton = TextButton(
                              child: Text("continue"),
                              onPressed: () async {
                                FirebaseFirestore.instance
                                    .collection("pgsaccount")
                                    .doc(document.id)
                                    .delete()
                                    .catchError((e) {
                                  print(e);
                                });

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
        }
      },
    );
  }
}
