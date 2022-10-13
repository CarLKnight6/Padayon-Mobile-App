import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:padayon/homescreen.dart';
import 'package:padayon/loginscreen.dart';
// ignore: unused_import
import 'package:padayon/pgsadminscreen.dart';
// ignore: unused_import
import 'package:padayon/reset.dart';

String? pgsusername;

class pgsloginscreen extends StatefulWidget {
  @override
  _pgsloginscreenState createState() => _pgsloginscreenState();
}

class _pgsloginscreenState extends State<pgsloginscreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   _secureText = false;
  // }
  bool _secureText = true;
  final logemailcontroller = TextEditingController();
  final logpasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    // ignore: unused_local_variable
    bool emailaddValidate = false;

    void clearText() {
      logemailcontroller.clear();
      logpasswordcontroller.clear();
    }

    showAlertDialognouserfound(BuildContext context) {
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
        content: Text("No user found for that email!"),
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

    showAlertDialogwrongpassword(BuildContext context) {
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
        content: Text("Wrong password provided for that user!"),
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
        content: Text("Invalid email user !"),
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

    showAlertDialoguserdisabled(BuildContext context) {
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
        content: Text("This user is disabled!"),
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

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    Future<void> _signOut() async {
      await _firebaseAuth.signOut();
    }

    Future<void> _loginUser() async {
      // try {
      //   UserCredential firebaseUser =
      //       (await FirebaseAuth.instance.signInWithEmailAndPassword(
      //     email: logemailcontroller.text,
      //     password: logpasswordcontroller.text,
      //   ))
      //           .user;
      //   if (firebaseUser != null) {
      //     // SharedPreferences prefs = await SharedPreferences.getInstance();
      //     // prefs.setString('displayName', user.displayName);

      //     print("hello");
      //     Navigator.pushNamed(context, '/adminscreen');
      //   }
      // } catch (e) {
      //   print(e);
      // }
      // var catchnewpw = logpasswordcontroller.text;
      try {
        // ignore: unused_local_variable
        // UserCredential userCredential = await FirebaseAuth.instance
        //     .signInWithEmailAndPassword(
        //         email: logemailcontroller.text,
        //         password: logpasswordcontroller.text);
        //Navigator.pushNamed(context, '/homescreen');
        _signOut();
        FirebaseFirestore.instance
            .collection("pgsaccount")
            .where('username', isEqualTo: logemailcontroller.text)
            .where('pw', isEqualTo: logpasswordcontroller.text)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            // doc.reference.update({'pw': catchnewpw});
            if (doc['status'] == 'enabled') {
              pgsusername = doc['username'];

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => pgsadminscreen(pgsusername: pgsusername),
              ));

              print(doc['username']);
              print(doc['pw']);
            } else {
              FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
              _firebaseAuth.signOut();
              showAlertDialoguserdisabled(context);
              print('account is disabled');
            }
          });
        });

        clearText();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showAlertDialognouserfound(context);
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showAlertDialogwrongpassword(context);
          print('Wrong password provided for that user.');
        } else if (e.code == 'invalid-email') {
          if (logemailcontroller.text == 'admin' ||
              logemailcontroller.text == 'superadmin') {
          } else {
            showAlertDialoginvalidemail(context);
            print('Invalid email.');
          }
        } else if (e.code == 'user-disabled') {
          showAlertDialoguserdisabled(context);
          print('user disabled.');
        }
      }
    }

    // String? validateEmail(String? formEmail) {
    //   if (formEmail == null || formEmail.isEmpty)
    //     return 'E-mail address is required.';

    //   return null;
    // }

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('padayon'),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            automaticallyImplyLeading: false,
          ),
          body: Form(
            key: _formKey,
            child: Container(
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
                    Text(
                      'PGS LOGIN',
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: logemailcontroller,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'e-mail address is required.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your email',
                          prefixIcon: Icon(Icons.person),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          //when error has occured
                          // errorStyle: TextStyle(
                          //   color: Colors.white,
                          // ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        obscureText: _secureText,
                        style: TextStyle(color: Colors.white),
                        controller: logpasswordcontroller,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'password is required.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _secureText
                                  ? Icons.visibility
                                  // ignore: dead_code
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _secureText = !_secureText;
                              });
                            },
                          ),
                          labelText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen)),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (logemailcontroller.text == "admin" &&
                            logpasswordcontroller.text == "admin") {
                          Navigator.pushNamed(context, '/adminscreens');
                          print("welcome admin");
                        }
                        if (logemailcontroller.text == "superadmin" &&
                            logpasswordcontroller.text == "superadmin") {
                          Navigator.pushNamed(context, '/superadminscreens');
                          print("welcome admin");
                        }

                        if (_formKey.currentState!.validate()) {
                          _loginUser();
                        } else {
                          print('wrong email or password!');
                        }

                        //login function button
                      },
                      color: Colors.black.withOpacity(0.05),
                      textColor: Colors.white,
                      child: Text(
                        "login",
                        // style: GoogleFonts.droidSans(
                        //     fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // MaterialButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, '/registrationscreen');
                    //     clearText();
                    //     //   if(acontroller.text == ''){

                    //     // }else{
                    //     //     searchedterm = acontroller.text ;
                    //     //   Navigator.pushNamed(context, '/SearchScreen');
                    //     //   Navigator.of(context).push(MaterialPageRoute(
                    //     //         builder: (context) => SearchResultScreen(searchedterm: searchedterm),
                    //     //     ));
                    //     //   print("searched book: $searchedterm");
                    //     // }
                    //   },
                    //   color: Colors.black.withOpacity(0.05),
                    //   textColor: Colors.white,
                    //   hoverColor: Colors.white,
                    //   child: Text(
                    //     "register",
                    //     // style: GoogleFonts.droidSans(
                    //     //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // TextButton(
                        //     child: Text(
                        //       'Forgot Password?',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           decoration: TextDecoration.underline),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.of(context).push(
                        //         MaterialPageRoute(
                        //             builder: (context) => ResetScreen()),
                        //       );
                        //       clearText();
                        //     }),
                        TextButton(
                            child: Text(
                              'Login as Student User?',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => loginscreen()),
                              );
                              clearText();
                            })
                      ],
                    )
                  ],
                )),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
