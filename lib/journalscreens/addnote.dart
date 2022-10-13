import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../loginscreen.dart';

// ignore: must_be_immutable
class AddNote extends StatefulWidget {
  AddNote({Key? key, String? currentuseremail}) : super(key: key);
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  // late String title;
  // late String des;
  // late String mood;
  String? title;
  String? des;
  String? mood;
  String notestatus = 'unchecked';
  String dropdownValue = 'sad';
  List<String> globalmoodlist = [];

  CollectionReference moodsRef = FirebaseFirestore.instance.collection('moods');

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getMoods());
  }

  showAlertDialognoemptytitle(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert4 = AlertDialog(
      title: Text("padayon:"),
      content: Text("Title is empty!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert4;
      },
    );
  }

  showAlertDialognoemptymood(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert4 = AlertDialog(
      title: Text("padayon:"),
      content: Text("Please select a mood!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert4;
      },
    );
  }

  showAlertDialognoemptycontent(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert4 = AlertDialog(
      title: Text("padayon:"),
      content: Text("Note description is empty!"),
      actions: [
        okButton,
      ],
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
                      onPressed: () {
                        if (title == null ||
                            title == '' ||
                            title == ' ' ||
                            title == '  ' ||
                            title == '   ' ||
                            title == '    ' ||
                            title == '     ' ||
                            title == '      ' ||
                            title == '       ' ||
                            title == '        ' ||
                            title == '         ' ||
                            title == '          ' ||
                            title == '           ' ||
                            title == '            ' ||
                            title == '             ' ||
                            title == '              ' ||
                            title == '               ' ||
                            title == '                ' ||
                            title == '                 ' ||
                            title == '                  ' ||
                            title == '                   ' ||
                            title == '                    ') {
                          showAlertDialognoemptytitle(context);
                          print('title is empty');
                        } else if (mood == null ||
                            mood == '' ||
                            mood == ' ' ||
                            mood == '  ' ||
                            mood == '   ' ||
                            mood == '    ' ||
                            mood == '     ') {
                          showAlertDialognoemptymood(context);
                          print('mood is empty');
                        } else if (des == null ||
                            des == '' ||
                            des == ' ' ||
                            des == '  ' ||
                            des == '   ' ||
                            des == '    ' ||
                            des == '     ' ||
                            des == '      ' ||
                            des == '       ' ||
                            des == '        ' ||
                            des == '         ' ||
                            des == '          ' ||
                            des == '           ' ||
                            des == '            ' ||
                            des == '             ' ||
                            des == '              ' ||
                            des == '               ') {
                          showAlertDialognoemptycontent(context);
                          print('content is empty');
                        } else if (title != null &&
                            title != '' &&
                            title != ' ' &&
                            title != '  ' &&
                            title != '   ' &&
                            title != '    ' &&
                            title != '     ' &&
                            title != '      ' &&
                            title != '       ' &&
                            title != '        ' &&
                            title != '         ' &&
                            title != '          ' &&
                            title != '           ' &&
                            title != '            ' &&
                            title != '             ' &&
                            title != '              ' &&
                            title != '               ' &&
                            title != '                ' &&
                            title != '                 ' &&
                            title != '                  ' &&
                            title != '                   ' &&
                            title != '                    ' &&
                            mood != null &&
                            mood != '' &&
                            mood != ' ' &&
                            mood != '  ' &&
                            mood != '   ' &&
                            mood != '    ' &&
                            mood != '     ' &&
                            des != null &&
                            des != '' &&
                            des != ' ' &&
                            des != '  ' &&
                            des != '   ' &&
                            des != '    ' &&
                            des != '     ' &&
                            des != '      ' &&
                            des != '       ' &&
                            des != '        ' &&
                            des != '         ' &&
                            des != '          ' &&
                            des != '           ' &&
                            des != '            ' &&
                            des != '             ' &&
                            des != '              ' &&
                            des != '               ') {
                          add();
                        }
                      },
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
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        onChanged: (_val) {
                          title = _val;
                        },
                      ),
                      Wrap(
                        // direction: Axis.vertical,
                        runAlignment: WrapAlignment.start,
                        children: [
                          DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItems: true,
                              items: globalmoodlist,
                              // ignore: deprecated_member_use
                              label: "",
                              // ignore: deprecated_member_use
                              hint: "select a mood to filter journals",
                              popupItemDisabled: (String s) =>
                                  s.startsWith('I'),
                              onChanged: (val) {
                                setState(() {
                                  mood = val!;
                                });
                              },
                              selectedItem: "select mood"),
                          // TextFormField(
                          //   enableInteractiveSelection: false,
                          //   decoration: InputDecoration.collapsed(
                          //     hintText: "choose mood",
                          //   ),
                          //   style: TextStyle(
                          //     fontSize: 20.0,
                          //     fontFamily: "lato",
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.grey,
                          //   ),
                          //   onChanged: (_val) {
                          //     //mood = _val;
                          //   },
                          // ),
                        ],
                      ),
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
    // // save to db
    print('addedtofirebase');
    // ignore: unused_local_variable
    FirebaseAuth _auth = FirebaseAuth.instance;

    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq')
        .collection(currentuseremail.toString());

    CollectionReference ref3 = FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq')
        .collection('notes');

    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
      'creator': currentuseremail,
      'mood': mood,
      'notestatus': notestatus,
    };

    ref.add(data); //userdata

    ref3.add(data); //admindata
    // print('this one is  add $currentuseremail');

    // Map<String, dynamic> updateBook = new Map<String, dynamic>();
    // updateBook[mood!] = updateBook[mood] + 1;
    // // FirebaseFirestore.instance
    // //     .collection("moodpriority")
    // //     .doc(ref.id)
    // //     .update(updateBook)
    // //     .whenComplete(() {});
    // print(updateBook[mood!]);

    Navigator.pop(context);
  }
}
