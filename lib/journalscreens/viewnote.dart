import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:padayon/loginscreen.dart';

class ViewNote extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;

  ViewNote(this.data, this.time, this.ref);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late String title;
  late String des;
  // late String mood;
  // String dropdownValue = 'sad';
  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    // mood = widget.data['mood'];
    return SafeArea(
      child: Scaffold(
        //
        floatingActionButton: edit
            ? FloatingActionButton(
                onPressed: save,
                child: Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                ),
                backgroundColor: Colors.grey[700],
              )
            : null,
        //
        resizeToAvoidBottomInset: false,
        //
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            size: 24.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.grey[700],
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                        //
                        SizedBox(
                          width: 8.0,
                        ),
                        //
                        ElevatedButton(
                          onPressed: delete,
                          child: Icon(
                            Icons.delete_forever,
                            size: 24.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.red[300],
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //
                SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        initialValue: widget.data['title'],
                        enabled: edit,
                        onChanged: (_val) {
                          title = _val;
                        },
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),
                      // DropdownButton<String>(
                      //   value: widget.data['mood'],
                      //   icon: const Icon(Icons.arrow_downward),
                      //   elevation: 16,
                      //   style: const TextStyle(color: Colors.deepPurple),
                      //   underline: Container(
                      //     height: 2,
                      //     color: Colors.deepPurpleAccent,
                      //   ),
                      //   onChanged: (String? _val) {
                      //     setState(() {
                      //       mood = _val!;
                      //     });
                      //   },
                      //   items: <String>[
                      //     'sad',
                      //     'happy',
                      //     'fear',
                      //     'anger',
                      //     'surprise',
                      //     'disgust',
                      //   ].map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          widget.time,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "lato",
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      //

                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Note Description",
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "lato",
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['description'],
                        enabled: edit,
                        onChanged: (_val) {
                          des = _val;
                        },
                        maxLines: 20,
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
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

  void delete() async {
    // delete from db
    await widget.ref.delete();
    // final refadminjournal = FirebaseFirestore.instance
    //         .collection('users')
    //         .doc('npyAZ2U8FjCSXmqxwGXq')
    //         .collection('notes')
    //         .where('created', isEqualTo: widget.time)
    //     //documentid display in note ui hidden^trial stage
    //     ;

    FirebaseFirestore.instance
        .collection('users')
        .doc('npyAZ2U8FjCSXmqxwGXq')
        .collection('notes')
        .where('creator', isEqualTo: currentuseremail)
        .where('title', isEqualTo: widget.data['title']) //thecomparison
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('users')
            .doc('npyAZ2U8FjCSXmqxwGXq')
            .collection('notes')
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success deleled not entitled:" + widget.data['title']);
        });
      });
    });

    Navigator.pop(context);
  }

  void save() async {
    if (key.currentState!.validate()) {
      // TODo : showing any kind of alert that new changes have been saved
      await widget.ref.update(
        {
          'title': title, //'mood': mood,
          'description': des,
          'notestatus': 'unchecked'
        },
      );

      var data = {
        //databeingupdated
        'title': title,
        //'mood': mood,
        'description': des,
        'notestatus': 'unchecked'
      };

      FirebaseFirestore.instance
          .collection('users')
          .doc('npyAZ2U8FjCSXmqxwGXq')
          .collection('notes')
          .where('title', isEqualTo: widget.data['title'])
          .where('creator', isEqualTo: currentuseremail)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('users')
              .doc('npyAZ2U8FjCSXmqxwGXq')
              .collection('notes')
              .doc(element.id)
              .update(data)
              .then((value) {
            print("Success updated entitled:" + widget.data['title']);
          });
        });
      });
      Navigator.of(context).pop();
    }
  }
}
