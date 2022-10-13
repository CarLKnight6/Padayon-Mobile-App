// ignore: unused_import
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:padayon/loginscreen.dart';
import 'package:padayon/pgsloginscreen.dart';

// import 'package:padayon/notelist.dart';
// ignore: unused_import
import 'package:padayon/usernotelist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:padayon/pgsvideocallscreens/pages/home_page.dart';

int? filterednotes;
QuerySnapshot? myDoc2;

class pgsadminscreen extends StatefulWidget {
  pgsadminscreen({Key? key, String? pgsusername}) : super(key: key);

  @override
  State<pgsadminscreen> createState() => _pgsadminscreenState();
}

class _pgsadminscreenState extends State<pgsadminscreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                alignment: Alignment.centerLeft,
                onPressed: () {
                  Navigator.pushNamed(context, '/loginscreen');
                },
                icon: Icon(Icons.logout_rounded),
              ),
              title: Text('padayon'),
              backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(color: Colors.white),
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          labelText: 'WELCOME  $pgsusername',
                          prefixIcon: Icon(Icons.person),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),

                          //when error has occured
                          errorStyle: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, '/registrationscreen');
                    //       //REG FUNCTION
                    //     },
                    //     color: Colors.black.withOpacity(0.05),
                    //     textColor: Colors.white,
                    //     child: Text(
                    //       "REGISTER AN ACCOUNT",
                    //       // style: GoogleFonts.droidSans(
                    //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       //MANAGE ACCOUNT FUNCTION
                    //       _launchURL();
                    //     },
                    //     color: Colors.black.withOpacity(0.05),
                    //     textColor: Colors.white,
                    //     child: Text(
                    //       "MANAGE USER ACCOUNT",
                    //       // style: GoogleFonts.droidSans(
                    //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          //VIDEOCHATSCREEN FUNCTION
                          Navigator.pushNamed(context, '/pgsvideocallscreens');
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                pgsMyHomePage(pgsusername: pgsusername),
                          ));
                        },
                        color: Colors.black.withOpacity(0.05),
                        textColor: Colors.white,
                        child: Text(
                          "VIDEO CHAT SESSION",
                          // style: GoogleFonts.droidSans(
                          //     fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    //filtermoodjournals
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaterialButton(
                    //     onPressed: () async {
                    //       List<DocumentSnapshot> _myDocCount;
                    //       QuerySnapshot _myDoc = await FirebaseFirestore
                    //           .instance
                    //           .collection('users')
                    //           .doc('npyAZ2U8FjCSXmqxwGXq')
                    //           .collection('notes')
                    //           .get();
                    //       _myDocCount = _myDoc.docs;
                    //       print(_myDocCount.length);
                    //       filterednotes = _myDocCount.length;

                    //       // Navigator.pushNamed(context, '/journalscreens');
                    //       //JOURNAL FUNCTION
                    //       Navigator.pushNamed(context, "/noteslists");

                    //       Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) =>
                    //             NoteList(filterednotes: filterednotes),
                    //       ));
                    //     },
                    //     color: Colors.black.withOpacity(0.05),
                    //     textColor: Colors.white,
                    //     child: Text(
                    //       "FILTER MOOD OF JOURNALS",
                    //       // style: GoogleFonts.droidSans(
                    //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),

                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaterialButton(
                    //     onPressed: () async {
                    //       // Navigator.pushNamed(context, '/journalscreens');
                    //       //JOURNAL FUNCTION

                    //       List<DocumentSnapshot> _myDocCount;
                    //       QuerySnapshot _myDoc = await FirebaseFirestore
                    //           .instance
                    //           .collection('users')
                    //           .doc('npyAZ2U8FjCSXmqxwGXq')
                    //           .collection('notes')
                    //           .get();
                    //       _myDocCount = _myDoc.docs;
                    //       print(_myDocCount.length);
                    //       filterednotes = _myDocCount.length;
                    //       Navigator.pushNamed(context, "/usernoteslists");

                    //       Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) =>
                    //             UserNoteList(filterednotes: filterednotes),
                    //       ));
                    //     },
                    //     color: Colors.black.withOpacity(0.05),
                    //     textColor: Colors.white,
                    //     child: Text(
                    //       "JOURNALS",
                    //       // style: GoogleFonts.droidSans(
                    //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),

                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       // Navigator.pushNamed(context, '/journalscreens');
                    //       //JOURNAL FUNCTION
                    //       Navigator.pushNamed(context, "/moodmanager");
                    //     },
                    //     color: Colors.black.withOpacity(0.05),
                    //     textColor: Colors.white,
                    //     child: Text(
                    //       "MOODS",
                    //       // style: GoogleFonts.droidSans(
                    //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaterialButton(
                    //     onPressed: () async {
                    //       // Navigator.pushNamed(context, '/journalscreens');
                    //       //JOURNAL FUNCTION

                    //       // ignore: unused_local_variable

                    //       Navigator.pushNamed(context, "/usermanager");
                    //     },
                    //     color: Colors.black.withOpacity(0.05),
                    //     textColor: Colors.white,
                    //     child: Text(
                    //       "Users",
                    //       // style: GoogleFonts.droidSans(
                    //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    // // SizedBox(
                    // //   width: double.infinity,
                    // //   child: MaterialButton(
                    // //     onPressed: () async {
                    // //       // Navigator.pushNamed(context, '/journalscreens');
                    // //       //JOURNAL FUNCTION

                    // //       // ignore: unused_local_variable

                    // //       Navigator.pushNamed(context, "/leaderboard");
                    // //     },
                    // //     color: Colors.black.withOpacity(0.05),
                    // //     textColor: Colors.white,
                    // //     child: Text(
                    // //       "leaderBOARD",
                    // //       // style: GoogleFonts.droidSans(
                    // //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    // //     ),
                    // //   ),
                    // // ),

                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       // Navigator.pushNamed(context, '/journalscreens');
                    //       //JOURNAL FUNCTION
                    //       Navigator.pushNamed(context, "/taskfilter");
                    //     },
                    //     color: Colors.black.withOpacity(0.05),
                    //     textColor: Colors.white,
                    //     child: Text(
                    //       "TASKS",
                    //       // style: GoogleFonts.droidSans(
                    //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),

                    // // SizedBox(
                    // //   width: double.infinity,
                    // //   child: MaterialButton(
                    // //     onPressed: () {
                    // //       // Navigator.pushNamed(context, '/journalscreens');
                    // //       //JOURNAL FUNCTION
                    // //       Navigator.pushNamed(context, "/moodsgraph");
                    // //     },
                    // //     color: Colors.black.withOpacity(0.05),
                    // //     textColor: Colors.white,
                    // //     child: Text(
                    // //       "Graphical Representations Report",
                    // //       // style: GoogleFonts.droidSans(
                    // //       //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    // //     ),
                    // //   ),
                    // // ),
                  ],
                ))),
        onWillPop: () async {
          return false;
        });
  }
}

// ignore: unused_element
_launchURL() async {
  const url =
      'https://console.firebase.google.com/u/0/project/padayon-8b933/authentication/users';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// ignore: unused_element
_launchURL2() async {
  const url =
      'https://console.firebase.google.com/u/0/project/padayon-8b933/firestore/data/~2Fusers~2FnpyAZ2U8FjCSXmqxwGXq';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
