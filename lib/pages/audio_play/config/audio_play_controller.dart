import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:get/get.dart';

/// jacokwu
/// 9/2/21 1:53 PM

class AudioPlayController extends ChangeNotifier {
  AudioPlayController()
      : audioPlayer = AudioPlayer(),
        audioCache = AudioCache(),
        volume = 1.0;

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  /// 音量
  double volume;

  /// 当前播放进度
  Duration currentPosition = Duration();

  /// 总时长
  Duration sumPosition = Duration();

  /// 当前状态
  PlayerState currentState = PlayerState.COMPLETED;

  /// 标识符
  String get playerId => audioPlayer.playerId;

  /// 当前模式
  PlayerMode get mode => audioPlayer.mode;

  /// 播放列表
  List<Map<String, dynamic>> playList = [];

  /// 当前播放ID
  String? currentId;

  /// 列表播放模式
  String currentListPlayMode = 'list';

  bool _hasInit = false;

  init() async {
    if (_hasInit) return;
    _hasInit = true;
    audioPlayer
      ..setReleaseMode(ReleaseMode.STOP)
      ..onDurationChanged.listen((event) {
        sumPosition = event;
        notifyListeners();
      }, onDone: () {}, onError: (error) {}, cancelOnError: true)
      ..onAudioPositionChanged.listen((event) {
        currentPosition = event;
        notifyListeners();
      }, onDone: () {}, onError: (error) {}, cancelOnError: true)
      ..onPlayerStateChanged.listen((event) {
        currentState = event;
        _cache();
        notifyListeners();
      }, onDone: () {}, onError: (error) {}, cancelOnError: true)
      ..onPlayerCompletion.listen((event) {
        print('播放完毕');
        _cache();
        if (currentListPlayMode == 'single') {
          seek(Duration());
          play();
        } else {
          playNext();
        }

      })
      ..onPlayerError.listen((event) {
        _cache();
        print('播放报错:::$event');
      });
    playList = await _getCachePlayList();
    Map<String, dynamic> currentPlay = await _getCacheCurrentPlay();
    currentId = currentPlay['currentId'] ?? null;
    currentPosition =
        currentPlay['currentPosition'] == null ? Duration() : Duration(milliseconds: currentPlay['currentPosition']);
    sumPosition = currentPlay['sumPosition'] == null ? Duration() : Duration(milliseconds: currentPlay['sumPosition']);
    if (currentId != null && getMusicLink(currentId!) != null) {
      audioPlayer.setUrl(getMusicLink(currentId!)!);
    }
    notifyListeners();
  }

  /// 设置音量
  void changeVolume(double volume) {
    audioPlayer.setVolume(volume);
    volume = volume;
  }

  /// 播放
  void play({Duration? position}) async {
    // await audioPlayer.release();
    if (isStringEmpty(currentId)) return;
    bool isGet = await _getMusicTrackLink(currentId!);
    if (!isGet) return;
    String? url = getMusicLink(currentId!);
    if (isStringEmpty(url)) return;
    await audioPlayer.setUrl(url!);
    int result =
        await audioPlayer.play(url, isLocal: isLocalUrl(url), stayAwake: true, volume: volume, position: position);
    if (result != 1) {
      print('播放：：：$result');
    }
  }

  /// 暂停
  void pause() async {
    if (currentState != PlayerState.PLAYING) return;
    int result = await audioPlayer.pause();
    if (result != 1) {
      print(result);
    }
  }

  /// 继续
  void resume() async {
    if (currentState != PlayerState.PAUSED) return;
    int result = await audioPlayer.resume();
    if (result != 1) {
      print(result);
    }
  }

  /// 停止
  void stop() async {
    int result = await audioPlayer.stop();
    if (result != 1) {
      print(result);
    }
  }

  /// 跳转
  void seek(Duration position) async {
    int result = await audioPlayer.seek(position);
    if (result != 1) {
      print(result);
    }
  }

  /// 是否是本地路径
  bool isLocalUrl(String url) {
    return audioPlayer.isLocalUrl(url);
  }

  /// 加入播放列表
  void addPlayList(List<Map<String, dynamic>> list) {
    playList.addAll(list);
  }

  /// 替换播放列表
  void replacePlayList(List<Map<String, dynamic>> list, String? playId) {
    print(list);
    playList
      ..clear()
      ..addAll(list);
    currentId = isStringNotEmpty(playId) ? playId : playList.first['TSID'];
    Future.delayed(Duration(milliseconds: 300)).then((value) => play());
  }

  /// 添加下一首播放
  void addNextPlay(Map<String, dynamic> data) {
    int dataIndex = playList.indexWhere((element) => element['TSID'] == data['TSID']);
    if (dataIndex != -1) {
      playList.removeAt(dataIndex);
    }
    int currentIndex = _getIndexById(currentId ?? '');
    playList.insert(currentIndex + 1, data);
    // 如果当前播放列表只有新加的一首，则直接播放
    if (playList.length == 1) {
      currentId = playList.first['TSID'];
      play();
    }
  }

  /// 上一首
  void playPrevious() {
    if (isStringEmpty(currentId)) return;
    int currentIndex = _getIndexById(currentId!);
    currentId = currentIndex == 0 ? playList.last['TSID'] : playList[currentIndex - 1]['TSID'];
    play();
  }

  /// 下一首
  void playNext() {
    if (isStringEmpty(currentId)) return;
    int currentIndex = _getIndexById(currentId!);
    currentId = currentIndex == playList.length - 1 ? playList.first['TSID'] : playList[currentIndex + 1]['TSID'];
    play();
  }

  /// 获取歌曲详细内容
  Map<String, dynamic> getSongDetailInfoById(String id) {
    return playList[_getIndexById(id)];
  }

  /// 获取歌曲链接
  Future<bool> _getMusicTrackLink(String id) async {
    int index = _getIndexById(id);
    return await AudioPostHttp.getSongTrackLink(id).then((value) {
      if (value['state'] == true) {
        playList[index] = value['data'];
        return true;
      } else {
        showToast(value['errmsg']);
        return false;
      }
    });
  }

  void changeListPlayMode() {
    int curIndex = AudioConfig.listPlayMode.indexWhere((element) => element['key'] == currentListPlayMode);
    currentListPlayMode = AudioConfig.listPlayMode[curIndex == AudioConfig.listPlayMode.length - 1 ? 0 : curIndex + 1]['key'];
    notifyListeners();
  }

  String? getMusicLink(String id) {
    Map<String, dynamic> detailInfo = getSongDetailInfoById(id);
    return isStringNotEmpty(detailInfo['path'])
        ? detailInfo['path']
        : detailInfo['trail_audio_info'] != null
            ? detailInfo['trail_audio_info']['path']
            : '';
  }

  /// 获取id对应下标
  int _getIndexById(String id) {
    return playList.indexWhere((element) => element['TSID'] == id);
  }

  /// 清空播放列表
  clearPlayList() {
    playList.clear();
    stop();
    currentId = null;
    currentPosition = Duration();
    sumPosition = Duration();
    _delCachePlayList();
    _delCacheCurrentPlay();
  }

  /// 播放指定歌曲
  playById(String id) {
    if (playList.length == 0 || playList.indexWhere((element) => element['TSID'] == id) == -1) return;
    currentId = id;
    Future.delayed(Duration(milliseconds: 300)).then((value) => play());
  }

  /// 删除播放列表歌曲
  delAudioFromPlayList(Map<String, dynamic> item) {
    if (currentId == item['TSID']) playNext();
    playList.remove(item);
    _cachePlayList();
    notifyListeners();
  }

  /// 缓存播放列表
  Future<void> _cachePlayList() async {
    await AudioConfig.savePlayList(jsonEncode(playList));
  }

  /// 获取缓存播放列表
  Future<List<Map<String, dynamic>>> _getCachePlayList() async {
    String? value = await AudioConfig.getPlayList();
    return value == null
        ? [] as List<Map<String, dynamic>>
        : jsonDecode(value).map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
  }

  /// 删除缓存播放列表
  Future<void> _delCachePlayList() async {
    await AudioConfig.removePlayList();
  }

  /// 缓存当前播放内容
  Future<void> _cacheCurrentPlay() async {
    await AudioConfig.saveCurrentPlay(jsonEncode({
      'currentId': currentId,
      'currentPosition': currentPosition.inMilliseconds,
      'sumPosition': sumPosition.inMilliseconds,
    }));
  }

  /// 获取缓存当前播放内容
  Future<Map<String, dynamic>> _getCacheCurrentPlay() async {
    String? value = await AudioConfig.getCurrentPlay();
    return value == null ? {} : jsonDecode(value);
  }

  /// 删除缓存当前播放内容
  Future<void> _delCacheCurrentPlay() async {
    await AudioConfig.removeCurrentPlay();
  }

  /// 缓存
  void _cache() {
    _cachePlayList();
    _cacheCurrentPlay();
  }

  @override
  void dispose() {
    audioPlayer.release();
    super.dispose();
    audioPlayer.dispose();
  }
}
