import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:padayon/availablepgsusers.dart';

import './call_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final userNameController = TextEditingController();
  final channelNameController = TextEditingController();
  bool validateError = false;
  // FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = 'admin';

  Future<void> _getUserName() async {
    // FirebaseFirestore.instance
    // .collection('users')
    // .doc(await FirebaseAuth.instance.currentUser!.uid)
    // .collection('userdetails')
    // .get()
    FirebaseFirestore.instance
        .collection("userdata")
        .where('uid', isEqualTo: await FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _userName = doc["anonname"];
        });
      });
    });
  }

  void initState() {
    super.initState();
    print(_userName);
    _getUserName();
  }

  @override
  void dispose() {
    channelNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("videocall"),
        backgroundColor: Color.fromRGBO(8, 120, 93, 3),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Padayon Video Call',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              // Username
              Container(
                width: 300,
                child: TextField(
                  readOnly: true,
                  enabled: false,
                  controller: userNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: '$_userName',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Your anonymousname',
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(220, 231, 220, 1)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(136, 177, 0, 1),
                          width: 2,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 177, 0, 1),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 177, 0, 1),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              // Channel Name
              Container(
                width: 300,
                child: TextField(
                  controller: channelNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter Channel name',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'test',
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(220, 231, 220, 1)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 177, 0, 1),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 177, 0, 1),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 177, 0, 1),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Container(
                width: 100,
                child: MaterialButton(
                  onPressed: onJoin,
                  color: Colors.black.withOpacity(0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Join',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),

              TextButton(
                  child: Text(
                    'Click to view available channels?',
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => availablepgsusers()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      (channelNameController.text.isEmpty || userNameController.text.isEmpty)
          ? validateError = true
          : validateError = false;
    });
    if (channelNameController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await _handleCameraAndMic(Permission.storage);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(_userName, channelNameController.text),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
