import 'package:flutter/material.dart';

/// jacokwu
/// 8/27/21 2:17 PM

/// 与 [TabBar.indicator] 一起使用在所选选项卡下方绘制一条水平线。
///
/// 所选选项卡下划线从选项卡边界插入 [insets]。
/// [borderSide] 定义线条的颜色和粗细。
///
/// [TabBar.indicatorSize] 属性可用于根据其（居中）小部件（带有 [TabBarIndicatorSize.label]）
/// 或整个选项卡（带有 [TabBarIndicatorSize.tab]）来定义指标的边界。
class WUnderlineTabIndicator extends Decoration {
  /// 创建下划线样式的选定选项卡指示器。
  ///
  /// [borderSide] 和 [insets] 参数不能为空。
  const WUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  }) : assert(borderSide != null),
        assert(insets != null);

  /// 所选选项卡下方绘制的水平线的颜色和粗细。
  final BorderSide borderSide;

  /// 相对于选项卡的边界定位选定选项卡的下划线。
  ///
  /// [TabBar.indicatorSize] 属性可用于根据具有 [TabBarIndicatorSize.label] 的（居中）选项卡小部件
  /// 或具有 [TabBarIndicatorSize.tab] 的整个选项卡来定义选项卡指示器的边界。
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is WUnderlineTabIndicator) {
      return WUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is WUnderlineTabIndicator) {
      return WUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([ VoidCallback? onChanged ]) {
    return _UnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
      : assert(decoration != null),
        super(onChanged);

  final WUnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration._indicatorRectFor(rect, textDirection).deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
