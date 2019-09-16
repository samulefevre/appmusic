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
            )
          ],
        ),
      ),
    );
  }
}
