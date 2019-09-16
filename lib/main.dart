import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'music.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'App music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Music> listMusic = [
    new Music('Theme Swift', 'Samu', 'assets/un.jpg', 'un.mp3'),
    new Music('Theme Flutter', 'Samu', 'assets/deux.jpg', 'deux.mp3')
  ];

  static AudioPlayer audioPlayer = new AudioPlayer();
  static AudioCache audioCache = new AudioCache(fixedPlayer: audioPlayer);
  Music currentMusic;
  Duration position = new Duration(seconds: 0);
  Duration durationMusic = new Duration(seconds: 0);
  PlayerState statut = PlayerState.stopped;

  int musicIndex = 0;

  @override
  void initState() {
    super.initState();
    currentMusic = listMusic[musicIndex];
    configAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Card(
              elevation: 9.0,
              child: Container(
                width: MediaQuery.of(context).size.height / 2.5,
                child: Image.asset(currentMusic.imagePath),
              ),
            ),
            playerText(currentMusic.title, 1.5),
            playerText(currentMusic.artist, 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                playerButtons(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                playerButtons(
                    (statut == PlayerState.playing)
                        ? Icons.pause
                        : Icons.play_arrow,
                    45.0,
                    (statut == PlayerState.playing)
                        ? ActionMusic.pause
                        : ActionMusic.play),
                playerButtons(Icons.fast_forward, 30.0, ActionMusic.forward),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                playerText(fromDuration(position), 0.8),
                playerText(fromDuration(durationMusic), 0.8),
              ],
            ),
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: durationMusic.inSeconds.toDouble(),
              inactiveColor: Colors.white,
              activeColor: Colors.red,
              onChanged: (double d) {
                setState(() {
                  Duration newDuration = new Duration(seconds: d.toInt());
                  position = newDuration;
                  audioPlayer.seek(position);
                });
              },
            )
          ],
        ),
      ),
    );
  }

  IconButton playerButtons(IconData icon, double size, ActionMusic action) {
    return IconButton(
      iconSize: size,
      color: Colors.white,
      icon: Icon(icon),
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            play();
            break;
          case ActionMusic.pause:
            pause();
            break;
          case ActionMusic.rewind:
            print('Rewind');
            rewind();
            break;
          case ActionMusic.forward:
            print('Forward');
            forward();
            break;
        }
      },
    );
  }

  Text playerText(String data, double scale) {
    return new Text(
      data,
      textScaleFactor: scale,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  void configAudioPlayer() {
    audioPlayer.onAudioPositionChanged
        .listen((pos) => setState(() => position = pos));

    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => durationMusic = d);
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.STOPPED) {
        setState(() => statut = PlayerState.stopped);
      }
    });
  }

  Future<void> play() async {
    await audioCache.play(currentMusic.urlSong);
    setState(() => statut = PlayerState.playing);
  }

  Future<void> pause() async {
    audioPlayer?.pause();
    setState(() => statut = PlayerState.paused);
  }

  Future<void> forward() async {
    (musicIndex == listMusic.length - 1) ? musicIndex = 0 : musicIndex++;
    currentMusic = listMusic[musicIndex];
    audioPlayer?.stop();
    play();
  }

  Future<void> rewind() async {
    (musicIndex == 0) ? musicIndex = listMusic.length - 1 : musicIndex--;
    currentMusic = listMusic[musicIndex];
    audioPlayer?.stop();
    play();
  }

  String fromDuration(Duration duration) {
    return duration.toString().split('.').first;
  }
}

enum ActionMusic { play, pause, rewind, forward }

enum PlayerState { playing, stopped, paused }
