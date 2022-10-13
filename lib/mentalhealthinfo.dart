import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class mentalhealthinfoscreen extends StatefulWidget {
  @override
  _mentalhealthinfoscreenState createState() => _mentalhealthinfoscreenState();
}

class _mentalhealthinfoscreenState extends State<mentalhealthinfoscreen> {
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

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/homescreen');
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text("Mental Health Info"),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
            // bottom: ,
          ),
          body: Stack(
            children: [
              Positioned(
                  child: Column(
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
                                                snapshot.data["definitions"]
                                                    [index]["image_url"]),
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
                                  child: Text(snapshot.data["definitions"]
                                      [index]["definition"]),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ))
            ],
          )),
      onWillPop: () async {
        return false;
      },
    );
  }
}
