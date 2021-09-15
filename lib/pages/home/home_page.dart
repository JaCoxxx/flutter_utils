import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/home/home_config.dart';
import 'package:flutter_utils/pages/home/slide_menu_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

final GlobalKey _scaffoldKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> menuList = [];

  bool _showAnimation = false;

  Offset _animationBoxOffset = Offset.zero;

  Size _animationBoxSize = Size(0, 0);

  Map<String, dynamic> _currentItem = {};

  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    menuList
      ..addAll(HomeConfig.menuList)
      ..forEach((element) {
        element['key'] = GlobalKey(debugLabel: element['path']);
      });
  }

  _startAnimation() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0, end: 1).animate(_animationController!);
    Size _curSize = Size.copy(_animationBoxSize);
    Offset _curOffset = Offset(_animationBoxOffset.dx, _animationBoxOffset.dy);
    double _oneWidth = (ScreenUtil().screenWidth - _animationBoxSize.width);
    double _oneHeight = (ScreenUtil().screenHeight - _animationBoxSize.height);
    Offset _oneOffset = _animationBoxOffset;
    _animation!
      ..addListener(() {
        print(_animationController!.value);
        _animationBoxSize = Size(_curSize.width + _oneWidth * _animationController!.value,
            _curSize.height + _oneHeight * _animationController!.value);
        _animationBoxOffset = _curOffset - _oneOffset * _animationController!.value;
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController!.dispose();
          _animationController = null;
          _animation = null;
          Future.delayed(Duration(milliseconds: 300)).then((value) {
            _showAnimation = false;
            setState(() {});
          });
          Get.toNamed(_currentItem['path']);
        }
      });
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    final SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            SliderMenuContainer(
              isShadow: true,
              appBarPadding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: Dimens.pd8),
              appBarHeight: MediaQuery.of(context).padding.top + 8 + 46,
              title: Text(
                '首页',
                style: TextStyle(fontSize: Dimens.font_size_18, fontWeight: FontWeight.w600),
              ),
              sliderMain: _buildSlideMain(),
              sliderMenu: SlideMenuWidget(),
            ),
            if (_showAnimation)
              Positioned(
                left: _animationBoxOffset.dx,
                top: _animationBoxOffset.dy,
                child: Container(
                  width: _animationBoxSize.width,
                  height: _animationBoxSize.height,
                  child: _buildMainItemWidget(_currentItem, false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideMain() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16, vertical: Dimens.pd8),
      child: MediaQuery.removeViewPadding(
        context: context,
        removeTop: true,
        child: SingleChildScrollView(
          child: GridView.builder(
            itemCount: menuList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Dimens.pd4,
              mainAxisSpacing: Dimens.pd4,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (_, int index) {
              return _buildMainItemWidget(menuList[index], true);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainItemWidget(dynamic item, bool needKey) {
    return Card(
      shadowColor: Colors.transparent,
      key: needKey ? item['key'] : null,
      child: InkWell(
        child: Container(width: double.infinity, height: double.infinity, child: Center(child: Text(item['title']))),
        onTap: needKey
            ? () {
                // Get.toNamed(item['path']);
                RenderBox box = item['key'].currentContext.findRenderObject();
                _animationBoxSize = Size(box.size.width - Dimens.pd4 * 2, box.size.height - Dimens.pd4 * 2);
                _animationBoxOffset = Offset(
                    box.localToGlobal(Offset.zero).dx + Dimens.pd4, box.localToGlobal(Offset.zero).dy + Dimens.pd4);
                _showAnimation = true;
                _currentItem = item;
                _startAnimation();
                setState(() {});
              }
            : null,
      ),
    );
  }
}
