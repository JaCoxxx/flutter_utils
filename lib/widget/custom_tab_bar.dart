import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';

/// jacokwu
/// 7/29/21 4:23 PM

const Color defaultColor = Colors.transparent;

class CustomTabBar extends StatefulWidget {
  /// 标题栏背景色
  final Color backgroundColor;

  /// 默认选中的index
  final int initialIndex;

  /// 标题列表
  final List<CustomTabBarItemBean> menuList;

  /// 主区域显示多少个菜单项
  final int initialShowNum;

  /// 切换页面的回调
  final Function(int index)? onChangeIndex;

  /// 是否需要尽量占满
  final bool isExpanded;

  const CustomTabBar({
    Key? key,
    required this.menuList,
    this.backgroundColor = defaultColor,
    this.initialIndex = 0,
    this.initialShowNum = 3,
    this.onChangeIndex,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late List<CustomTabBarItemBean> _menuList;

  late int _currentIndex;
  late int _initialShowNum;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex, keepPage: true);
    _menuList = widget.menuList.toList();
    _currentIndex = widget.initialIndex;
    _initialShowNum = widget.initialShowNum;
  }

  @override
  dispose() {
    super.dispose();
    _pageController.dispose();
  }

  /// 计算展示区域的起始下标
  int _getRangeStart() {
    int index = 0;
    if (_menuList.length > _initialShowNum) {
      if (_currentIndex != 0) {
        if (_menuList.length - _currentIndex < _initialShowNum) {
          index = _menuList.length - _initialShowNum;
        } else {
          index = _currentIndex - 1;
        }
      }
    }
    return index;
  }

  /// 计算展示区域的结束下标
  int _getRangeEnd() {
    int index = _menuList.length;
    int startIndex = _getRangeStart();
    if (_menuList.length > _initialShowNum) {
      index = startIndex + _initialShowNum;
    }
    return index;
  }

  /// 切换主体区域
  _onClickItem(int index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 38,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black.withOpacity(.6), width: 1)),
            color: widget.backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: widget.isExpanded
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ..._menuList
                  .sublist(_getRangeStart(), _getRangeEnd())
                  .toList()
                  .asMap()
                  .keys
                  .map((e) => _buildItem(
                      e + _getRangeStart(), _menuList[e + _getRangeStart()]))
                  .toList(),
              if (widget.isExpanded)
                Spacer(),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              PageView(
                  physics: NeverScrollableScrollPhysics(),
                  children: _menuList.map<Widget>((e) {
                    if (e.renderFn != null) {
                      return e.renderFn!();
                    } else {
                      return e.value!;
                    }
                  }).toList(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    _currentIndex = index;
                    if (widget.onChangeIndex != null)
                      widget.onChangeIndex!(index);
                    setState(() {});
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int index, dynamic item) {
    return widget.isExpanded
        ? Expanded(
            child: _buildMenuBtn(index, item),
          )
        : _buildMenuBtn(index, item);
  }

  Widget _buildMenuBtn(int index, CustomTabBarItemBean item) {
    bool isSelected = _currentIndex == index;
    return MaterialButton(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Text(
            item.title ?? '',
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.black.withAlpha(0xB2),
              fontSize: Dimens.font_size_14,
            ),
          ),
          Dimens.hGap4,
          if (isSelected)
            Container(
              width: 25,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        _onClickItem(index);
      },
    );
  }
}

class CustomTabBarItemBean {
  String? title;
  Widget? value;
  Function? renderFn;

  CustomTabBarItemBean({this.title, this.value, this.renderFn});

  CustomTabBarItemBean.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    renderFn = json['renderFn'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['value'] = this.value;
    data['renderFn'] = this.renderFn;
    return data;
  }
}
