import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String? _email;
  final auth = FirebaseAuth.instance;

  final resetemailcontroler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pushNamed(context, '/loginscreen');
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("padayon:"),
        content: Text(
            "a password reset link has been sent if your email is registered on our app!"),
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

    showAlertDialoginvalidemail(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert2 = AlertDialog(
        title: Text("padayon:"),
        content: Text("invalid email address or not found"),
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

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginscreen');
              },
              icon: Icon(Icons.arrow_back),
            ),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            title: Text('Reset Password'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: resetemailcontroler,
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () {
                      if (resetemailcontroler.text.isNotEmpty &&
                          resetemailcontroler.text.contains('@')) {
                        try {
                          auth.sendPasswordResetEmail(email: _email!);

                          showAlertDialog(context);
                        } on FirebaseAuthException catch (e) {
                          print(e.code);
                          print(e.message);
                        }
                      } else {
                        showAlertDialoginvalidemail(context);
                      }
                    },
                    color: Color.fromRGBO(59, 239, 109, 23),
                    textColor: Colors.white,
                    child: Text(
                      "send request",
                      // style: GoogleFonts.droidSans(
                      //     fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
