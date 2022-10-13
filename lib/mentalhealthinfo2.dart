// ignore_for_file: deprecated_member_use, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class mentalhealthinfo2 extends StatefulWidget {
  @override
  _mentalhealthinfo2State createState() => _mentalhealthinfo2State();
}

class _mentalhealthinfo2State extends State<mentalhealthinfo2>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "d709f1eff9582e9e7fa50a7e4085b92f8dec0c55";

  TextEditingController _controller = TextEditingController();

  late StreamController _streamController;
  late Stream _stream;

  late Timer _debounce;

  _search() async {
    if (_controller.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(Uri.parse(_url + _controller.text.trim()),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );

    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = new TextEditingController();
    TextEditingController authorController = new TextEditingController();
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/homescreen');
              },
              icon: Icon(Icons.arrow_back),
            ),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            title: Text('Mental Health Info'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: TextFormField(
                      onFieldSubmitted: (_) async {
                        _search();
                      },
                      onChanged: (String text) {
                        if (_debounce.isActive) _debounce.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          _search();
                        });
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Search for a word",
                        contentPadding: const EdgeInsets.only(left: 24.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.white,
                      indicatorColor: Color.fromRGBO(8, 120, 93, 3),
                      unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      tabs: [
                        Text('Main'),
                        Text('Merriam-Webster'),
                        Text('Oxford'),
                        Text('Urban Dictionary'),
                        Text('Psychology Dictionary')
                      ],
                    ),
                  ),
                ],
              ),
            )),
        body: Container(
          child: TabBarView(
            controller: tabController,
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: _stream,
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: Text(" "),
                      );
                    }

                    if (snapshot.data == "waiting") {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data["definitions"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListBody(
                          children: <Widget>[
                            Container(
                              color: Colors.grey[300],
                              child: ListTile(
                                leading: snapshot.data["definitions"][index]
                                            ["image_url"] ==
                                        null
                                    ? null
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot.data["definitions"][index]
                                                ["image_url"]),
                                      ),
                                title: Text(_controller.text.trim() +
                                    "(" +
                                    snapshot.data["definitions"][index]
                                        ["type"] +
                                    ")"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.data["definitions"][index]
                                  ["definition"]),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              //webster
              Container(
                margin: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('info')
                      .where('word',
                          isEqualTo: _controller.text.toLowerCase().trim())
                      .where('base', isEqualTo: 'merriam-webster')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return new ListView(
                          padding: EdgeInsets.only(bottom: 80),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  onTap: () {},
                                  title: new Text(" " + document['word']),
                                  subtitle: new Text(
                                      "Definition: " + document['meaning']),
                                  trailing:
                                      // Delete Button
                                      InkWell(
                                    onTap: () {
                                      // ignore: todo
                                      //TODO: FirebaseFirestore delete a record code
                                      FirebaseFirestore.instance
                                          .collection("info")
                                          .doc(document.id)
                                          .delete()
                                          .catchError((e) {
                                        print(e);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Icon(Icons.book),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
              //oxford
              Container(
                margin: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('info')
                      .where('word',
                          isEqualTo: _controller.text.toLowerCase().trim())
                      .where('base', isEqualTo: 'oxford')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return new ListView(
                          padding: EdgeInsets.only(bottom: 80),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  onTap: () {},
                                  title: new Text(" " + document['word']),
                                  subtitle: new Text(
                                      "Definition: " + document['meaning']),
                                  trailing:
                                      // Delete Button
                                      InkWell(
                                    onTap: () {
                                      // ignore: todo
                                      //TODO: FirebaseFirestore delete a record code
                                      FirebaseFirestore.instance
                                          .collection("info")
                                          .doc(document.id)
                                          .delete()
                                          .catchError((e) {
                                        print(e);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Icon(Icons.book),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
              //urban dictionary
              Container(
                margin: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('info')
                      .where('word',
                          isEqualTo: _controller.text.toLowerCase().trim())
                      .where('base', isEqualTo: 'urban dictionary')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return new ListView(
                          padding: EdgeInsets.only(bottom: 80),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  onTap: () {},
                                  title: new Text(" " + document['word']),
                                  subtitle: new Text(
                                      "Definition: " + document['meaning']),
                                  trailing:
                                      // Delete Button
                                      InkWell(
                                    onTap: () {
                                      // ignore: todo
                                      //TODO: FirebaseFirestore delete a record code
                                      FirebaseFirestore.instance
                                          .collection("info")
                                          .doc(document.id)
                                          .delete()
                                          .catchError((e) {
                                        print(e);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Icon(Icons.book),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
              //psychology dictionary
              Container(
                margin: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('info')
                      .where('word',
                          isEqualTo: _controller.text.toLowerCase().trim())
                      .where('base', isEqualTo: 'psychology dictionary')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return new ListView(
                          padding: EdgeInsets.only(bottom: 80),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  onTap: () {},
                                  title: new Text(" " + document['word']),
                                  subtitle: new Text(
                                      "Definition: " + document['meaning']),
                                  trailing:
                                      // Delete Button
                                      InkWell(
                                    onTap: () {
                                      // ignore: todo
                                      //TODO: FirebaseFirestore delete a record code
                                      FirebaseFirestore.instance
                                          .collection("info")
                                          .doc(document.id)
                                          .delete()
                                          .catchError((e) {
                                        print(e);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Icon(Icons.book),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
