import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'package:padayon/settaskscreens/epap.dart';
import 'package:padayon/journalscreens/homepage.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    homescreen(),
    HomePage(), //journal
    Epap(), //taskscreen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel Budget App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => NewTripLocationView(
              //             trip: newTrip,
              //           )),
              // );
            },
          ),
//          IconButton(
//            icon: Icon(Icons.undo),
//            onPressed: () async {
//              try {
//                AuthService auth = Provider.of(context).auth;
//                await auth.signOut();
//                print("Signed Out!");
//              } catch (e) {
//                print (e);
//              }
//            },
//          ),
//          IconButton(
//            icon: Icon(Icons.account_circle),
//            onPressed: () {
//              Navigator.of(context).pushNamed('/convertUser');
//            },
//          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              // ignore: deprecated_member_use
              title: new Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.explore),
              // ignore: deprecated_member_use
              title: new Text("Journal"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle),
              // ignore: deprecated_member_use
              title: new Text("Tasks"),
            ),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
