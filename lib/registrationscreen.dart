import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: unused_import
import 'package:padayon/loginscreen.dart';

class registrationscreen extends StatefulWidget {
  const registrationscreen({Key? key}) : super(key: key);

  @override
  _registrationscreenState createState() => _registrationscreenState();
}

class _registrationscreenState extends State<registrationscreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      anoncontroller.clear();
      anoncontroller.text = getRandomString(10);
    });
  }

  final _formKey2 = GlobalKey<FormState>();

  final regemailcontroller = TextEditingController();

  final regpasswordcontroller = TextEditingController();
  var anoncontroller = TextEditingController();
  bool _randomtext = true;
  var donetext = 'done';
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  void clearText() {
    regemailcontroller.clear();
    regpasswordcontroller.clear();
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          clearText();
          Navigator.pushNamed(context, '/loginscreen');
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("padayon:"),
        content: Text("Successfully registered!"),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog2passwordweak(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          clearText();
          Navigator.pushNamed(context, '/registrationscreen');
        },
      );

      // set up the AlertDialog
      AlertDialog alert2 = AlertDialog(
        title: Text("padayon:"),
        content: Text("password is too weak!"),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert2;
        },
      );
    }

    showAlertDialog2emailalreadyexist(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          clearText();
          Navigator.pushNamed(context, '/registrationscreen');
        },
      );

      // set up the AlertDialog
      AlertDialog alert3 = AlertDialog(
        title: Text("padayon:"),
        content: Text("email already exists!"),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert3;
        },
      );
    }

    showAlertDialoginvalidemail(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          clearText();
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert4 = AlertDialog(
        title: Text("padayon:"),
        content: Text("Invalid email address provided!"),
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

    showAlertDialog2invalidentry(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          clearText();
          Navigator.pushNamed(context, '/registrationscreen');
        },
      );

      // set up the AlertDialog
      AlertDialog alert4 = AlertDialog(
        title: Text("padayon:"),
        content: Text("please check again!"),
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

    Future<void> _createUser() async {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: regemailcontroller.text,
                password: regpasswordcontroller.text);
        showAlertDialog(context);
        FirebaseAuth _auth = FirebaseAuth.instance;
        // CollectionReference ref = FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(_auth.currentUser!.uid)
        //     .collection('userdetails');

        CollectionReference ref =
            FirebaseFirestore.instance.collection('userdata');

        var data = {
          'anonname': anoncontroller.text,
          'email': regemailcontroller.text,
          'uid': _auth.currentUser!.uid,
          'pw': regpasswordcontroller.text,
          'status': 'enabled'
        };

        ref.add(data);

        clearText();
        //print('this one is  add $anoncontroller');

        setState(() {
          donetext = 'success!';
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showAlertDialog2passwordweak(context);
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showAlertDialog2emailalreadyexist(context);
          print('The account already exists for that email.');
        } else if (e.code == 'invalid-email') {
          showAlertDialoginvalidemail(context);
          print('Invalid email.');
        }
      } catch (e) {
        showAlertDialog2invalidentry(context);
        print(e);
      }
    }

    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginscreen');
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text('padayon'),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
          ),
          body: Container(
              key: _formKey2,
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(color: Colors.white),
                      controller: anoncontroller,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'press the box to get anon name';
                        }
                        return null;
                      },
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_randomtext
                              ? Icons.account_box
                              : Icons.add_box_outlined),
                          onPressed: () {
                            anoncontroller.clear();
                            setState(() {
                              anoncontroller.clear();
                              anoncontroller.text =
                                  getRandomString(10); // randomfunction here
                            });
                          },
                        ),
                        labelText: 'your anonymous name',
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: regpasswordcontroller,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'password is required!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your password',
                        prefixIcon: Icon(Icons.person),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        //when error has occured
                        // errorStyle: TextStyle(
                        //   color: Colors.red,
                        // ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: regemailcontroller,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'e-mail address is required.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your email address',

                        prefixIcon: Icon(Icons.person),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        //when error has occured
                        // errorStyle: TextStyle(
                        //   color: Colors.red,
                        // ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
                            _launchURL3();
                          })
                    ],
                  ),
                  MaterialButton(
                    onPressed: () {
                      // if (_formKey2.currentState!.validate()) {
                      if (regemailcontroller.text.isEmpty &&
                          regpasswordcontroller.text.isEmpty &&
                          anoncontroller.text.isEmpty) {
                        showAlertDialog2invalidentry(context);
                      } else if (anoncontroller.text.isEmpty) {
                        showAlertDialog2invalidentry(context);
                      } else if (regemailcontroller.text.isEmpty) {
                        showAlertDialoginvalidemail(context);
                      } else if (regpasswordcontroller.text.isEmpty) {
                        showAlertDialog2invalidentry(context);
                      } else {
                        _createUser();
                      }

                      // }
                    },
                    color: Colors.black.withOpacity(0.05),
                    textColor: Colors.white,
                    child: Text(
                      donetext,
                      // style: GoogleFonts.droidSans(
                      //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ))),
      onWillPop: () async {
        return false;
      },
    );
  }
}

_launchURL3() async {
  const url = 'https://pages.flycricket.io/padayon-mobile-appli-0/privacy.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
