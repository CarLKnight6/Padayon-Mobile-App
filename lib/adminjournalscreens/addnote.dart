import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:padayon/loginscreen.dart';

// ignore: must_be_immutable
class AddNote extends StatefulWidget {
  AddNote({Key? key, String? currentuseremail}) : super(key: key);
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title;
  late String des;
  late String mood;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              12.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    //
                    ElevatedButton(
                      onPressed: add,
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "lato",
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //
                SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        onChanged: (_val) {
                          title = _val;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "mood",
                        ),
                        style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        onChanged: (_val) {
                          mood = _val;
                        },
                      ),
                      //
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Note Description",
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "lato",
                            color: Colors.grey,
                          ),
                          onChanged: (_val) {
                            des = _val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void add() async {
    // save to db
    CollectionReference ref2 = FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq') //(FirebaseAuth.instance.currentUser!.uid)
        .collection(currentuseremail.toString())
        .doc('$mood')
        .collection('notes');
    // .doc('npyAZ2U8FjCSXmqxwGXq')
    // .collection('notes');

    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq') //(FirebaseAuth.instance.currentUser!.uid)
        .collection(currentuseremail.toString());

    CollectionReference ref3 = FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq') //(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
      'creator': currentuseremail,
      'mood': mood,
    };

    ref.add(data);
    ref2.add(data);
    ref3.add(data);
    print('this one is  add $currentuseremail');

    //

    Navigator.pop(context);
  }
}
