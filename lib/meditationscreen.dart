import 'package:audioplayers/src/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class meditationscreen extends StatefulWidget {
  const meditationscreen({Key? key}) : super(key: key);

  @override
  _meditationscreenState createState() => _meditationscreenState();
}

class _meditationscreenState extends State<meditationscreen> {
  bool playing = false;
  IconData playBtn = Icons.play_arrow;
  late AudioPlayer _player;
  late AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Color.fromRGBO(59, 239, 109, 23),
          inactiveColor: Color.fromRGBO(59, 239, 109, 23),
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    _player.onDurationChanged.listen((d) {
      setState(() {
        musicLength = d;
      });
    });
    _player.onAudioPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  void _stopSound() {
    _player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                _stopSound();
                Navigator.pushNamed(context, '/homescreen');
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text("Meditate"),
            backgroundColor: Color.fromRGBO(8, 120, 93, 3),
          ),
          //let's start by creating the main UI of the app
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(8, 120, 93, 3),
                    Color.fromRGBO(8, 120, 93, 3),
                  ]),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 48.0,
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Meditation",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Peace of Mind",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Center(
                      child: Container(
                        width: 280.0,
                        height: 280.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                              image: AssetImage("assets/images/bg1.jpg"),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Center(
                      child: Text(
                        "Stargazer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 500.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  slider(),
                                  Text(
                                    "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 45.0,
                                  color: Color.fromRGBO(59, 239, 109, 23),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.skip_previous,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 62.0,
                                  color: Color.fromRGBO(59, 239, 109, 23),
                                  onPressed: () {
                                    if (!playing) {
                                      cache.play("padayonmusic.mp3");
                                      setState(() {
                                        playBtn = Icons.pause;
                                        playing = true;
                                      });
                                    } else {
                                      _player.pause();
                                      setState(() {
                                        playBtn = Icons.play_arrow;
                                        playing = false;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    playBtn,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 45.0,
                                  color: Color.fromRGBO(59, 239, 109, 23),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.skip_next,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
