import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';

class AudioPlayPage extends StatefulWidget {
  const AudioPlayPage({Key? key}) : super(key: key);

  @override
  _AudioPlayPageState createState() => _AudioPlayPageState();
}

class _AudioPlayPageState extends State<AudioPlayPage> {

  FlutterSound flutterSound = new FlutterSound();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer(logLevel: Level.debug);
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder(logLevel: Level.debug);

  @override
  initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await recorderModule.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _initializeExample(false);
  }

  Future<void> _initializeExample(bool withUI) async {
    await playerModule.closeAudioSession();
    await playerModule.openAudioSession(
        withUI: withUI,
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await playerModule.setSubscriptionDuration(Duration(milliseconds: 10));
    await recorderModule.setSubscriptionDuration(Duration(milliseconds: 10));
  }


  @override
  void dispose() {
    super.dispose();
    playerModule.closeAudioSession();
    recorderModule.closeAudioSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '音乐播放列表'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              OutlinedButton(
                child: Text('播放'),
                onPressed: () {
                  playerModule.startPlayer(fromURI: 'https://jacokwu.cn/images/public/周杰伦%20-%20彩虹.mp3');
                },
              ),
              OutlinedButton(
                child: Text('切换播放状态'),
                onPressed: () {
                  if (playerModule.isPlaying) {
                    playerModule.pausePlayer();
                  } else {
                    playerModule.resumePlayer();
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
