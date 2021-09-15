import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_fake.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/main_theme_data.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/search_bar_controller.dart';
import 'package:get/get.dart';

import '../widgets.dart';

/// jacokwu
/// 8/16/21 1:59 PM

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  static final double appBarHeight = 57;

  /// 状态栏UI亮度
  final Brightness brightness;

  /// 状态栏底色
  final Color? statusBarBackgroundColor;

  /// 标题栏底色
  final Color? backgroundColor;

  /// 是否显示默认返回按钮，默认为false
  final bool showDefaultBack;

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

  /// 搜索文案
  final String searchHint;

  /// 搜索框点击事件
  final VoidCallback? onSearchBoxTap;

  /// 是否是搜索页面
  final bool isSearch;

  /// 搜索事件
  final void Function(String text)? onSearch;

  /// 是否需要右侧默认按钮，仅在 [isSearch == true] 时生效
  final bool needDefaultRightAction;

  final SearchBarController? controller;

  /// 列表页面使用，搜索框不可输入
  const SearchAppBar({
    Key? key,
    this.brightness = Brightness.light,
    this.statusBarBackgroundColor = Colors.white,
    this.backgroundColor,
    this.showDefaultBack = false,
    this.backWidget,
    this.backIcon,
    this.backColor,
    this.onClickBackBtn,
    this.rightAction,
    this.searchHint = '搜索',
    this.onSearchBoxTap,
    this.onSearch,
    this.isSearch = false,
    this.needDefaultRightAction = true, this.controller,
  })  : assert(onSearchBoxTap == null || isSearch == false),
        assert((onSearch != null && isSearch == true) || isSearch == false),
        super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _editingController;

  bool searchInputHasValue = false;

  late SearchBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SearchBarController()..init();
    _initFocusNode();
    _editingController = _controller.editingController
      ..addListener(() {
        searchInputHasValue = _editingController.text.isNotEmpty;
        setState(() {});
      });
  }

  _initFocusNode() async {
    await Future.delayed(Duration(milliseconds: 100));
    _controller.focus(context);
    setState(() {});
  }

  _onSearch() {
    _controller.unFocus();
    if (_editingController.text.isEmpty && !widget.searchHint.contains('搜索')) {
      _editingController.text = widget.searchHint;
      setState(() {});
    }
    widget.onSearch!(_editingController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SystemUiOverlayStyle overlayStyle =
        widget.brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

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
          child: Row(
            children: [
              _buildBack(),
              Expanded(child: widget.isSearch ? _buildSearchInputBox() : _buildSearchBox()),
              _buildRightAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInputBox() {
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.pd8, vertical: Dimens.pd12),
        child: TextField(
          style: TextStyle(fontSize: Dimens.font_size_14),
          decoration: InputDecoration(
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00FF0000)),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00000000)),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            hintText: widget.searchHint,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Dimens.pd12),
            suffixIcon: searchInputHasValue
                ? IconButton(
                    onPressed: () {
                      _editingController.clear();
                    },
                    icon: Icon(
                      Icons.cancel,
                      size: Dimens.font_size_16,
                      color: Color(0xFFB3B3B3),
                    ))
                : emptyWidget,
          ),
          textInputAction: TextInputAction.search,
          focusNode: _controller.focusNode,
          controller: _editingController,
          onChanged: (value) {

          },
          onSubmitted: (value) {
            _onSearch();
          },
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
      child: GestureDetector(
        onTap: widget.onSearchBoxTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd12),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: Dimens.font_size_12,
                color: Color(0xFF848484),
              ),
              Text(
                widget.searchHint,
                style: TextStyle(color: Color(0xFF848484), fontSize: Dimens.font_size_12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBack() {
    if (widget.showDefaultBack)
      return Container(
        height: 57,
        child: Material(
          type: MaterialType.circle,
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: IconButton(
              color: widget.backColor != null ? widget.backColor : Colors.black,
              onPressed: widget.onClickBackBtn != null
                  ? widget.onClickBackBtn
                  : () {
                      Get.back();
                    },
              icon: widget.backIcon != null ? widget.backIcon! : BackButtonIcon()),
        ),
      );
    else if (widget.backWidget != null)
      return Positioned(
        left: 0,
        child: SizedBox(
          height: 57,
          child: Center(
              child: Builder(
            builder: widget.backWidget!,
          )),
        ),
      );
    else
      return emptyWidget;
  }

  Widget _buildRightAction() {
    if (widget.isSearch && widget.needDefaultRightAction)
      return Padding(
        padding: EdgeInsets.only(right: Dimens.pd10),
        child: SizedBox(
          height: 57,
          child: Center(child: TextButton(onPressed: debounceFunc(func: () => _onSearch()), child: Text('搜索'))),
        ),
      );
    else if (widget.rightAction != null)
      return Padding(
        padding: EdgeInsets.only(right: Dimens.pd10),
        child: SizedBox(
          height: 57,
          child: Center(child: widget.rightAction!),
        ),
      );
    else
      return emptyWidget;
  }
}
