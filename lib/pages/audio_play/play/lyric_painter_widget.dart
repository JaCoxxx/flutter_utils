import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/model/lyric_item_model.dart';

/// jacokwu
/// 9/4/21 1:52 PM

class LyricPainterWidget extends CustomPainter with ChangeNotifier {
  /// 歌词列表
  List<LyricItemModel> lyricList;

  /// 当前播放行,-1表示不可滚动
  int curLine;

  /// 画笔
  Paint _linePaint = Paint();

  /// 文本画笔集合
  List<TextPainter> _lyricPainterList = [];

  /// 是否正在拖动
  bool isDragging = false;

  /// 偏移量
  double _offsetY = 0;

  double get offsetY => _offsetY;
  set offsetY(double value) {
    if (isDragging) {
      if (value <= (_lyricPainterList[0].height / 2 + ScreenUtil().setWidth(30)) * -1 && value > _totalHeight * -1 + _lyricPainterList.last.height / 2) {
        // 向下拖动超范围
        _offsetY = value;
      }
    } else {
      _offsetY = value;
    }
    notifyListeners();
  }

  /// 总高度
  double _totalHeight = 0;

  LyricPainterWidget(this.lyricList, this.curLine) {
    _linePaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = ScreenUtil().setWidth(1);
    _lyricPainterList.addAll(lyricList.map<TextPainter>((e) => TextPainter(
        textAlign: TextAlign.center,
        maxLines: 2,
        text: TextSpan(text: e.lyric, style: TextStyle(color: Colors.grey, fontSize: Dimens.font_size_14)),
        textDirection: TextDirection.ltr)));
    lyricList[0].offset = 0;
    _layoutTextPainters();
  }

  void _layoutTextPainters() {
    _lyricPainterList.forEach((lp) => lp.layout(maxWidth: ScreenUtil().screenWidth - ScreenUtil().setWidth(30)));
    offsetY = (_lyricPainterList[0].height / 2 + ScreenUtil().setWidth(30)) * -1;

    // 延迟一下计算总高度
    Future.delayed(Duration(milliseconds: 300), () {
      double _sumHeight = 0;
      _lyricPainterList.asMap().keys.forEach((index) {
        double _curLineHeight = getLineHeight(index);
        lyricList[index].offset = _sumHeight * -1;
        _sumHeight += _curLineHeight;
      });
      _totalHeight = _sumHeight;
    });
  }

  /// 获取行高度
  double getLineHeight(int index) {
    return _lyricPainterList.length > 0 ? _lyricPainterList[index].height + ScreenUtil().setWidth(30) : 0;
  }

  /// 获取行偏移量
  double getLineOffsetY(int curLine) {
    return lyricList[curLine].offset!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double y = _offsetY + size.height / 2;
    for (int i = 0; i < _lyricPainterList.length; i++) {
      // 在区域内才绘制
      if (y <= size.height && y >= (0 - _lyricPainterList[i].height / 2)) {
        if (curLine == i) {
          // 正在播放的行
          _lyricPainterList[i].text =
              TextSpan(text: lyricList[i].lyric, style: TextStyle(color: Colors.white, fontSize: Dimens.font_size_14));
        } else if (isDragCurLine(i)) {
          // 正在拖动时的高亮行
          _lyricPainterList[i].text = TextSpan(
            text: lyricList[i].lyric,
            style: TextStyle(color: Colors.white.withOpacity(.85), fontSize: Dimens.font_size_14),
          );
        } else {
          _lyricPainterList[i].text =
              TextSpan(text: lyricList[i].lyric, style: TextStyle(color: Colors.grey, fontSize: Dimens.font_size_14));
        }
        _lyricPainterList[i].layout(maxWidth: size.width - ScreenUtil().setWidth(30));
        _lyricPainterList[i].paint(canvas, Offset((size.width - _lyricPainterList[i].width) / 2, y));
      }
      // 计算偏移量
      y += getLineHeight(i);
    }

    // 拖动状态下额外标识物
    if (isDragging && curLine != -1) {
      canvas.drawLine(
          Offset(ScreenUtil().setWidth(80), size.height / 2 - ScreenUtil().setWidth(30)),
          Offset(size.width - ScreenUtil().setWidth(120), size.height / 2 - ScreenUtil().setWidth(30)),
          Paint()
            ..color = Colors.white12
            ..strokeWidth = ScreenUtil().setWidth(1));
    }
  }

  bool isDragCurLine(int index) {
    if (!isDragging || curLine == -1) return false;
    if (index == 0 && _offsetY >= ( - ScreenUtil().setWidth(15) - _lyricPainterList[index].height))
      return true;
    else if (lyricList[index].offset == 0)
      return false;
    else if (_offsetY >= (lyricList[index].offset! - getLineHeight(index) - ScreenUtil().setWidth(15)) &&
        _offsetY < (lyricList[index].offset! - ScreenUtil().setWidth(15))) return true;
    return false;
  }

  @override
  bool shouldRepaint(LyricPainterWidget oldDelegate) {
    print(isDragging != oldDelegate.isDragging || _offsetY != oldDelegate._offsetY);
    return isDragging != oldDelegate.isDragging || _offsetY != oldDelegate._offsetY;
  }
}
