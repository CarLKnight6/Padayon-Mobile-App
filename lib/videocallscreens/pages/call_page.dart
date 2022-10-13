import 'dart:ui';

import 'package:padayon/videocallscreens/widgets/app_bar.dart';
import 'package:padayon/videocallscreens/widgets/call_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:native_screenshot/native_screenshot.dart';

// ignore: must_be_immutable
class CallPage extends StatefulWidget {
  String userName;
  final String channelName;
  CallPage(this.userName, this.channelName);
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(132, 174, 0, 0.5),
        title: Text('Hi ' + widget.userName + '!'),
        elevation: 10,
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/profile_pic.png'),
          radius: 10,
          backgroundColor: Color.fromRGBO(255, 104, 220, 1),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                _capturePng();
              })
        ],
      ),
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          VideoCall(widget.channelName, widget.userName),
          Positioned(
            bottom: 10,
            left: 60,
            child: StatusBar(),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePng() async {
    String path = await NativeScreenshot.takeScreenshot();
    print(path);
  }
}
