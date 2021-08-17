import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/pages/audio_play/player_widget.dart';

class AudioPlayPage extends StatefulWidget {
  const AudioPlayPage({Key? key}) : super(key: key);

  @override
  _AudioPlayPageState createState() => _AudioPlayPageState();
}

class _AudioPlayPageState extends State<AudioPlayPage> {


  AudioPlayer _audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  @override
  initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '音乐播放列表'),
        showDefaultBack: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              PlayerWidget(url: Uri.encodeFull('https://jacokwu.cn/images/public/周杰伦%20-%20彩虹.mp3')),
              OutlinedButton(
                child: Text('播放'),
                onPressed: () async {
                  int result = await _audioPlayer.play('http://se.sycdn.kuwo.cn/1197263cde3333687db435cd89962ca5/610104cb/resource/n3/63/33/2657748055.mp3', isLocal: false);
                  if (result != 1) {
                    print(result);
                  }
                },
              ),
              OutlinedButton(
                child: Text('切换播放状态'),
                onPressed: () async {
                  if (_audioPlayer.state == PlayerState.PLAYING) {
                    int pauseResult = await _audioPlayer.pause();
                    if (pauseResult != 1) {
                      print(pauseResult);
                    }
                  } else if (_audioPlayer.state == PlayerState.PAUSED) {
                    int resumeResult = await _audioPlayer.resume();
                    if (resumeResult != 1) {
                      print(resumeResult);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
