import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/model/lyric_item_model.dart';
import 'package:flutter_utils/pages/audio_play/play/lyric_painter_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';

/// jacokwu
/// 9/4/21 10:28 AM

class LyricShowWidget extends StatefulWidget {
  final String? path;

  final Duration position;

  final void Function(Duration position) onTapLyric;

  const LyricShowWidget({Key? key, required this.path, required this.position, required this.onTapLyric}) : super(key: key);

  @override
  _LyricShowWidgetState createState() => _LyricShowWidgetState();
}

class _LyricShowWidgetState extends State<LyricShowWidget> with TickerProviderStateMixin {
  LyricPainterWidget? _lyricPainterWidget;

  List<LyricItemModel> _lyricList = [];

  bool _canScroll = false;

  Timer? dragEndTimer; // 拖动结束任务
  late VoidCallback dragEndFunc;
  Duration dragEndDuration = Duration(milliseconds: 3000);

  // 歌词移动动画
  AnimationController? _lyricOffsetController;

  @override
  void initState() {
    super.initState();
    dragEndFunc = () {
      if (_lyricPainterWidget != null && _lyricPainterWidget!.isDragging) {
        _lyricPainterWidget!.isDragging = false;
        // setState(() {});
      }
    };
    _getLyric();
  }

  @override
  didUpdateWidget(LyricShowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.path != oldWidget.path) _getLyric();
    if (widget.position != oldWidget.position && _lyricPainterWidget != null && _canScroll)
      setState(() {
        _startLineAnim(AudioConfig.getLyricLineByCurrentPosition(widget.position, _lyricList));
        // if (!_lyricPainterWidget!.isDragging) calcCurLineOffsetY();
      });
  }

  // 计算当前播放行偏移量
  void calcCurLineOffsetY() {
    if (_lyricPainterWidget!.curLine == -1 || _lyricPainterWidget!.curLine == 0) return;
    _lyricPainterWidget!.offsetY = _lyricPainterWidget!.getLineOffsetY(_lyricPainterWidget!.curLine);
  }

  // 高亮下一行的移动动画
  void _startLineAnim(int curLine) {
    // 如果页面还没有创建, 或者歌词不支持滚动，或者前后行数一致则不执行任何操作
    if (_lyricPainterWidget == null || !_canScroll || _lyricPainterWidget!.curLine == curLine) return;
    // 如果没有在手动拖动，才执行动画
    if (!_lyricPainterWidget!.isDragging) {
      // 如果上一个动画没有执行完成，则结束上一个动画
      if (_lyricOffsetController != null) _lyricOffsetController!.stop();
      _lyricOffsetController = AnimationController(vsync: this, duration: Duration(milliseconds: 600))
        ..addStatusListener((status) {
          // 动画结束后删除控制器
          if (status == AnimationStatus.completed) {
            _lyricOffsetController!.dispose();
            _lyricOffsetController = null;
          }
        });
      // 当前行偏移量
      double curOffsetY = _lyricPainterWidget!.getLineOffsetY(curLine);
      Animation _animation =
          Tween(begin: _lyricPainterWidget!.offsetY, end: curOffsetY).animate(_lyricOffsetController!);
      _lyricOffsetController!.addListener(() {
        _lyricPainterWidget!.offsetY = _animation.value;
      });
      _lyricOffsetController!.forward();
    }

    _lyricPainterWidget!.curLine = curLine;
  }

  _getLyric() async {
    print(widget.path);
    if (isStringEmpty(widget.path)) {
      _lyricList.clear();
      setState(() {});
      return;
    }
    await Dio().get(widget.path!).then((value) {
      print(value);
      if (isStringNotEmpty(value.toString())) {
        Map<String, dynamic> result = AudioConfig.getLyricList(value.toString());
        _lyricList
          ..clear()
          ..addAll(result['lyricList']);
        _canScroll = result['canScroll'];
        if (_lyricList.length > 0)
          _lyricPainterWidget = LyricPainterWidget(
              _lyricList, _canScroll ? AudioConfig.getLyricLineByCurrentPosition(widget.position, _lyricList) : -1);
        calcCurLineOffsetY();
        setState(() {});
      } else {}
    }).catchError((err) {
      print('err:$err');
      _lyricList.clear();
      setState(() {});
      showToast('歌词加载失败');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: _lyricList.length > 0
          ? _buildPaintContainer()
          : Center(
              child: CustomText.content('暂无歌词'),
            ),
    );
  }

  Widget _buildPaintContainer() {
    return GestureDetector(
      onVerticalDragUpdate: (v) {
        if (_lyricPainterWidget != null && !_lyricPainterWidget!.isDragging) {
          _lyricPainterWidget!.isDragging = true;
          setState(() {});
        }
        _lyricPainterWidget!.offsetY += v.delta.dy;
      },
      onVerticalDragEnd: (v) {
        cancelDragTimer();
      },
      child: CustomPaint(
        painter: _lyricPainterWidget,
        size: Size(
            ScreenUtil().screenWidth,
            ScreenUtil().screenHeight -
                kToolbarHeight -
                ScreenUtil().setWidth(240) -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom),
      ),
    );
  }

  void cancelDragTimer() {
    if (dragEndTimer != null) {
      if (dragEndTimer!.isActive) {
        dragEndTimer!.cancel();
        dragEndTimer = null;
      }
    }
    dragEndTimer = Timer(dragEndDuration, dragEndFunc);
  }
}
