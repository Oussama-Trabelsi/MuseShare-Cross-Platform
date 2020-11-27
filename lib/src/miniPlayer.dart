import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Models/items.dart';
import 'utils/waves.dart';
import 'utils/zigzag.dart';

typedef void OnError(Exception exception);

const Color color = Color(0xFF007e9a);
const Color mainColor = Color(0xFF1f1f54);

enum PlayerState { stopped, playing, paused }

class MiniAudioPlayer extends StatefulWidget {
  String songDataAddress;
  static String songUrl;
  String songImage;
  String artist;
  String category;
  String name;

  MiniAudioPlayer(Song sng) {
    this.songDataAddress = sng.url;
    this.songImage = sng.image;
    this.artist = sng.artist;
    this.name = sng.name;
    category = sng.category;
    songUrl = "none";
  }

  @override
  _MiniAudioPlayerState createState() => new _MiniAudioPlayerState();


}

class _MiniAudioPlayerState extends State<MiniAudioPlayer> {
  String newSongUrl = MiniAudioPlayer.songUrl;

  Duration duration;
  Duration position;
  AudioPlayer audioPlayer;
  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;



  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    _fetchSongDataFromWeb();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
          if (s == AudioPlayerState.PLAYING) {
            setState(() => duration = audioPlayer.duration);
          } else if (s == AudioPlayerState.STOPPED) {
            onComplete();
            setState(() {
              position = duration;
            });
          }
        }, onError: (msg) {
          setState(() {
            playerState = PlayerState.stopped;
            duration = new Duration(seconds: 0);
            position = new Duration(seconds: 0);
          });
        });
  }

  Future play() async {
    await audioPlayer.play(newSongUrl);
    setState(() {
      playerState = PlayerState.playing;
    });
  }


  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

/////////////////////////////////////////// data related part //////////////////////////////
  List<Song> songs;
  int currentPosition = 0;
  String songImageUrl='none';


  _fetchSongDataFromWeb() async {
    String url = widget.songDataAddress;
    newSongUrl = url;
  }


  _next(int pos) {
    setState(() {
      newSongUrl = "none";
      songs = new List();
      _fetchSongDataFromWeb();
    });
  }

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    Size size = new Size(MediaQuery.of(context).size.width, 80.0);

    _fetchSongDataFromWeb();

    Widget _buildWave(int x, int y, int secs) {
      return Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: new Opacity(
            opacity: 0.2,
            child: new DemoBody(
              size: size,
              xOffset: x,
              yOffset: y,
              color: color,
              secs: secs,
            ),
          ));
    }


    return new Scaffold(
      body: Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              new Stack(
                children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 7),child: Text(widget.name.length>10?widget.name.substring(0,10)+"...":widget.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
                    new Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 0.0),
                      child: new Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            isPlaying ? Container() : _buildWave(0, 0, 100),
                            isPlaying ? Container() : _buildWave(9, 27, 110),
                            isPlaying ? Container() : _buildWave(33, 6, 120),
                            isPlaying ? _buildWave(0, 0, 1) : Container(),
                            isPlaying ? _buildWave(13, 17, 2) : Container(),
                            isPlaying ? _buildWave(33, 6, 3) : Container(),
                            Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child: duration == null
                                  ? new Container()
                                  : new Slider(
                                value: position?.inMilliseconds
                                    ?.toDouble() ??
                                    0.0,
                                onChanged: (double value) => audioPlayer
                                    .seek((value / 1000).roundToDouble()),
                                min: 0.0,
                                max: duration.inMilliseconds.toDouble(),
                              ),
                            )
                          ]),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new IconButton(
                              onPressed: () {},
                              iconSize: 30.0,
                              icon: new Icon(Icons.skip_previous),
                              color: color),
                          newSongUrl == "none"
                              ? new SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: new CircularProgressIndicator(strokeWidth: 1.0,))
                              : newSongUrl == "error"?
                          new SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: new CircularProgressIndicator(strokeWidth: 1.0, valueColor: AlwaysStoppedAnimation(Colors.red),))

                              :new FloatingActionButton(
                            onPressed: () {
                              isPlaying ? pause() : play();
                            },
                            backgroundColor: color,
                            child: Icon(isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                          new IconButton(
                              onPressed: () {},
                              iconSize: 30.0,
                              icon: new Icon(Icons.skip_next),
                              color: color),
                        ],
                      ),
                    ),
                ],
              ),
            ]),
      ),
    );
  }
}
