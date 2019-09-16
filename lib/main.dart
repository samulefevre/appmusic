import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';

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
    new Music('Theme Swift', 'Samu', 'assets/un.jpg', 'assets/un.mp3'),
    new Music('Theme Flutter', 'Samu', 'assets/deux.jpg', 'assets/deux.mp3')
  ];

  Music currentMusic;
  double position = 0.0;

  @override
  void initState() {
    super.initState();
    currentMusic = listMusic[0];
  }

  AudioPlayer audioPlayer;

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
                playerButtons(Icons.fast_rewind, 30.0,ActionMusic.rewind),
                playerButtons(Icons.play_arrow, 45.0,ActionMusic.play),
                playerButtons(Icons.fast_forward, 30.0,ActionMusic.forward),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                playerText('0:0', 0.8),
                playerText('0:22', 0.8),
              ],
            ),
            Slider(
              value: position,
              min: 0.0,
              max: 30.0,
              inactiveColor: Colors.white,
              activeColor: Colors.red,
              onChanged:(double d) {
                setState(() {
                  position = d;
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
            print('Play');
            break;
          case ActionMusic.pause:
            print('Pause');
            break;
          case ActionMusic.rewind:
            print('Rewind');
            break;
          case ActionMusic.forward:
            print('Forward');
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

  
}

enum ActionMusic {
  play,
  pause,
  rewind,
  forward
}
