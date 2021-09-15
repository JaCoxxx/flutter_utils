import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:flutter_utils/pages/audio_play/model/lyric_item_model.dart';
import 'package:flutter_utils/pages/audio_play/play/cover_show_widget.dart';
import 'package:flutter_utils/pages/audio_play/play/lyric_show_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/play_list_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/pages/audio_play/play/player_widget.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

class AudioPlayPage extends StatefulWidget {
  const AudioPlayPage({Key? key}) : super(key: key);

  @override
  _AudioPlayPageState createState() => _AudioPlayPageState();
}

class _AudioPlayPageState extends State<AudioPlayPage> with AutomaticKeepAliveClientMixin {
  late AudioPlayController _controller;

  /// 当前播放进度
  Duration _currentPosition = Duration();

  /// 总长度
  Duration _sumPosition = Duration();

  /// 当前曲目
  Map<String, dynamic> get _currentSong =>
      _controller.currentId == null ? {} : _controller.getSongDetailInfoById(_controller.currentId!);

  /// 播放列表
  List<Map<String, dynamic>> _playList = [];
  // set _playList(List<Map<String, dynamic>> value) => _playList = value;

  Map<String, dynamic> _trackInfo = {};

  /// 是否在拖动进度条
  bool _isChangedPosition = false;

  /// 是否显示歌词
  bool _showLyric = false;

  @override
  initState() {
    _controller = BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController
      ..init()
      ..addListener(bindControllerListener);
    _currentPosition = _controller.currentPosition;
    _sumPosition = _controller.sumPosition;
    _playList = _controller.playList;
    super.initState();
  }

  _getTrackDetailInfo() async {
    return await AudioPostHttp.getTrackInfo('', 1, 99999).then((value) {
      if (value['state'] == true) {
        _trackInfo = value['data'];
        setState(() {});
      } else {
        showToast(value['errmsg']);
      }
    });
  }

  bindControllerListener() {
    if (_isChangedPosition && _controller.currentId == _currentSong['TSID']) return;
    _currentPosition = _controller.currentPosition;
    _sumPosition = _controller.sumPosition;
    _playList = _controller.playList;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    _controller.removeListener(bindControllerListener);
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.2),
              child: _currentSong['pic'] != null
                  ? CacheNetworkImageWidget(
                      imageUrl: _currentSong['pic'],
                      fit: BoxFit.fitWidth,
                    )
                  : Container(
                      color: Colors.black38,
                    )),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: Colors.black38,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          AppBar(
            centerTitle: true,
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomText(
                  _currentSong['title'],
                  color: Colors.white,
                  fontSize: Dimens.font_size_14,
                ),
                GestureDetector(
                  onTap: () {
                    AudioConfig.getToArtistPage(context,
                        _currentSong['artist'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList());
                  },
                  child: CustomText.content(_currentSong['artist'] != null && _currentSong['artist'].length > 0
                      ? _currentSong['artist'].map((e) => e['name']).join('/')
                      : ''),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                _showLyric ? _buildLyricContainer() : _buildCoverContainer(),
                _buildPlayProgressBar(),
                _buildControllerBar(),
                safeAreaBottom(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLyricContainer() {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              _showLyric = !_showLyric;
              setState(() {});
            },
            child: LyricShowWidget(
              path: _currentSong['lyric'],
              position: _controller.currentPosition,
              onTapLyric: (position) {
                print(position);
                _controller.seek(position);
              },
            )));
  }

  Widget _buildCoverContainer() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _showLyric = !_showLyric;
          setState(() {});
        },
        child: CoverShowWidget(currentSong: _currentSong),
      ),
    );
  }

  Widget _buildPlayProgressBar() {
    return Container(
      height: ScreenUtil().setWidth(100),
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
      child: Row(
        children: [
          Container(
              width: ScreenUtil().setWidth(80), child: CustomText.content(_currentPosition.toString().substring(2, 7))),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: ScreenUtil().setWidth(2),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: ScreenUtil().setWidth(10),
                ),
              ),
              child: Slider(
                min: Duration().inMilliseconds.toDouble(),
                value: _currentPosition.inMilliseconds.toDouble(),
                onChanged: (double value) {
                  _currentPosition = Duration(milliseconds: value.toInt());
                  setState(() {});
                },
                onChangeStart: (double value) {
                  _isChangedPosition = true;
                },
                onChangeEnd: (double value) {
                  _isChangedPosition = false;
                  int milliseconds = value.toInt();
                  if (milliseconds == _sumPosition.inMilliseconds) {
                    _controller.playNext();
                  } else if (_controller.currentState == PlayerState.STOPPED ||
                      _controller.currentState == PlayerState.COMPLETED) {
                    _controller.play(position: Duration(milliseconds: milliseconds));
                  } else {
                    _controller.seek(Duration(milliseconds: milliseconds));
                  }
                },
                max: _sumPosition.inMilliseconds.toDouble(),
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
              ),
            ),
          ),
          Container(
              width: ScreenUtil().setWidth(80), child: CustomText.content(_sumPosition.toString().substring(2, 7))),
        ],
      ),
    );
  }

  Widget _buildControllerBar() {
    return Container(
      height: ScreenUtil().setWidth(140),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayModeWidget(),
          GestureDetector(
              onTap: () {
                _controller.playPrevious();
              },
              child: Icon(Icons.skip_previous)),
          GestureDetector(
              onTap: () {
                if (_controller.currentState == PlayerState.PLAYING) {
                  _controller.pause();
                } else if (_controller.currentState == PlayerState.PAUSED) {
                  _controller.resume();
                } else {
                  _controller.play(position: _currentPosition);
                }
              },
              child: Icon(_controller.currentState == PlayerState.PLAYING ? Icons.pause : Icons.play_arrow)),
          GestureDetector(
              onTap: () {
                _controller.playNext();
              },
              child: Icon(Icons.skip_next)),
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => PlayListWidget());
              },
              child: Icon(Icons.playlist_play)),
        ],
      ),
    );
  }

  Widget _buildPlayModeWidget() {
    return GestureDetector(
      onTap: () {
        _controller.changeListPlayMode();
      },
      child: Icon(AudioConfig.listPlayMode.firstWhere((element) => element['key'] == _controller.currentListPlayMode)['icon']),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
