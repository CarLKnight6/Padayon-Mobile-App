import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:padayon/journalscreens/homepage.dart';
import 'package:padayon/loginscreen.dart';

// ignore: must_be_immutable
class homescreen extends StatefulWidget {
  homescreen({Key? key, String? currentuseremail}) : super(key: key);

  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> _signOut() async {
    await _firebaseAuth.signOut();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('padayon'),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            //automaticallyImplyLeading: false,
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('MENU', style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(8, 120, 93, 3),
                  ),
                ),
                ListTile(
                  title: Text('Sign Out'),
                  onTap: () {
                    _signOut();
                    Navigator.pushNamed(context, '/loginscreen');
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Exit'),
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      exit(0);
                    });
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
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
                  // MaterialButton(
                  //   onPressed: () {
                  //     _signOut();
                  //     Navigator.pushNamed(context, '/');
                  //   },
                  //   color: Colors.black.withOpacity(0.05),
                  //   textColor: Colors.white,
                  //   child: Text(
                  //     "SIGNOUT",
                  //     // style: GoogleFonts.droidSans(
                  //     //     fontSize: 20.0, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          labelText: 'WELCOME USER $currentuseremail',
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
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/meditationscreen');
                      },
                      color: Colors.black.withOpacity(0.05),
                      textColor: Colors.white,
                      child: Text(
                        "MEDITATION",
                        // style: GoogleFonts.droidSans(
                        //     fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        //VIDEOCHATSCREEN FUNCTION
                        Navigator.pushNamed(context, '/videocallscreens');
                      },
                      color: Colors.black.withOpacity(0.05),
                      textColor: Colors.white,
                      child: Text(
                        "ONE ON ONE VIDEO CHAT SESSION",
                        // style: GoogleFonts.droidSans(
                        //     fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              HomePage(currentuseremail: currentuseremail),
                        ));
                        //JOURNAL FUNCTION
                      },
                      color: Colors.black.withOpacity(0.05),
                      textColor: Colors.white,
                      child: Text(
                        "JOURNAL",
                        // style: GoogleFonts.droidSans(
                        //     fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/mentalhealthinfo2');
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) =>
                        //       HomePage(currentuseremail: currentuseremail),
                        // ));
                        //mental FUNCTION
                      },
                      color: Colors.black.withOpacity(0.05),
                      textColor: Colors.white,
                      child: Text(
                        "MENTAL HEALTH INFO",
                        // style: GoogleFonts.droidSans(
                        //     fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/settaskscreens');
                        //task function
                      },
                      color: Colors.black.withOpacity(0.05),
                      textColor: Colors.white,
                      child: Text(
                        "SET TASKS",
                        // style: GoogleFonts.droidSans(
                        //     fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
