import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/main_theme_data.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

class WAppBar extends StatefulWidget implements PreferredSizeWidget {
  static final double appBarHeight = 57;

  /// 标题配置，优先级低于 [buildTitle]
  final WAppBarTitleConfig? titleConfig;

  /// 标题自定义，优先级高于 [titleConfig]
  final Widget? buildTitle;

  /// 标题栏底色
  final Color? backgroundColor;

  /// 状态栏底色
  final Color? statusBarBackgroundColor;

  /// 状态栏UI亮度
  final Brightness brightness;

  /// 是否显示默认返回按钮，默认为false
  final bool? showDefaultBack;

  /// 左侧action，仅在 [showDefaultBack] 为false时生效
  final Widget Function(BuildContext context)? backWidget;

  /// 左侧返回按钮图标，仅在 [showDefaultBack] 为true时生效
  final Icon? backIcon;

  /// 左侧返回按钮颜色，仅在 [showDefaultBack] 为true时生效
  final Color? backColor;

  /// 左侧返回按钮点击事件
  final void Function()? onClickBackBtn;

  /// 右侧操作组件
  final Widget? rightAction;

  const WAppBar({
    Key? key,
    this.titleConfig,
    this.buildTitle,
    this.backgroundColor,
    this.statusBarBackgroundColor = Colors.white,
    this.brightness = Brightness.light,
    this.showDefaultBack = false,
    this.backWidget,
    this.backIcon,
    this.backColor,
    this.onClickBackBtn,
    this.rightAction,
  }) : super(key: key);

  @override
  _WAppBarState createState() => _WAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

class _WAppBarState extends State<WAppBar> {
  @override
  Widget build(BuildContext context) {
    final SystemUiOverlayStyle overlayStyle =
        widget.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        color: widget.statusBarBackgroundColor,
        child: Semantics(
          explicitChildNodes: true,
          child: _buildBar(),
        ),
      ),
    );
  }

  Widget _buildBar() {
    return Container(
      color: widget.backgroundColor != null
          ? widget.backgroundColor
          : MainThemeData.currentTheme.appBarTheme.backgroundColor,
      child: SafeArea(
        child: Container(
          height: 57,
          child: Stack(
            children: [
              Center(
                child: widget.titleConfig == null ? emptyWidget : _buildTitle(),
              ),
              _buildBack(),
              _buildRightAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.titleConfig!.title,
      style: TextStyle(
        color: widget.titleConfig!.titleColor != null
            ? widget.titleConfig!.titleColor!
            : Colors.black,
        fontSize: Dimens.font_size_16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBack() {
    if (widget.showDefaultBack!)
      return Positioned(
        left: 0,
        child: Container(
          height: 57,
          child: Material(
            type: MaterialType.circle,
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            child: IconButton(
                color: widget.backColor != null
                    ? widget.backColor
                    : Colors.black,
                onPressed: widget.onClickBackBtn != null
                    ? widget.onClickBackBtn
                    : () {
                        Get.back();
                      },
                icon: widget.backIcon != null
                    ? widget.backIcon!
                    : BackButtonIcon()),
          ),
        ),
      );
    else if (widget.backWidget != null)
      return Positioned(
        left: 0,
        child: SizedBox(
          height: 57,
          child: Center(child: Builder(builder: widget.backWidget!,)),
        ),
      );
    else
      return emptyWidget;
  }

  Widget _buildRightAction() {
    return widget.rightAction != null
        ? Positioned(
            right: 10,
            child: SizedBox(
              height: 57,
              child: Center(child: widget.rightAction!),
            ),
          )
        : emptyWidget;
  }
}

class WAppBarTitleConfig {
  String title;
  Color? titleColor;

  WAppBarTitleConfig({
    required this.title,
    this.titleColor,
  });
}
