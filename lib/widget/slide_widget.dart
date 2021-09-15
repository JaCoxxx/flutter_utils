import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/photo_view_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/2/21 10:59 AM

class SlideWidget extends StatefulWidget {
  final List? list;

  final Future<List> Function()? getList;

  final String urlKey;

  final void Function(int, dynamic)? onTap;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final bool autoPlay;

  final bool loop;

  final SwiperPlugin? control;

  final Axis scrollDirection;

  final SwiperController? controller;

  final SwiperPlugin? paginationBuilder;

  const SlideWidget({
    Key? key,
    this.list,
    this.getList,
    this.urlKey = 'url',
    this.onTap,
    this.width,
    this.height,
    this.fit,
    this.autoPlay = true,
    this.loop = true,
    this.control,
    this.scrollDirection = Axis.horizontal,
    this.controller,
    this.paginationBuilder,
  }) : assert(list != null || getList != null), super(key: key);

  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(widget.width ?? MediaQuery.of(context).size.width, widget.height ?? ScreenUtil().setWidth(300)),
      ),
      child: FutureBuilder<List>(
        future: widget.getList == null ? Future.value(widget.list!) : widget.getList!(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          else return Swiper(
            autoplay: widget.autoPlay,
            loop: widget.loop,
            control: widget.control,
            scrollDirection: widget.scrollDirection,
            controller: widget.controller,
            containerWidth: widget.width ?? MediaQuery.of(context).size.width,
            containerHeight: widget.height ?? ScreenUtil().setWidth(300),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) => _buildItemWidget(index, snapshot.data![index], snapshot.data),
            pagination: SwiperPagination(
                builder: widget.paginationBuilder != null ? widget.paginationBuilder! : DotSwiperPaginationBuilder()),
          );
        }
      ),
    );
  }

  Widget _buildItemWidget(int index, dynamic item, List? list) {
    return CacheNetworkImageWidget(
      imageUrl: item[widget.urlKey],
      fit: widget.fit ?? BoxFit.fitHeight,
      onTap: widget.onTap == null
          ? () {
              Get.to(PhotoViewWidget(
                urlList: list!.map<String>((e) => e[widget.urlKey]).toList(),
                initialIndex: index,
              ));
            }
          : () => widget.onTap!(index, item),
    );
  }
}

class CustomSwiperPaginationBuilder extends SwiperPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  /// Space between rects
  final double space;

  final Key? key;

  const CustomSwiperPaginationBuilder({
    this.activeColor,
    this.color,
    this.key,
    this.size: const Size(20.0, 10.0),
    this.activeSize: const Size(20.0, 10.0),
    this.space: 3.0,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    List<Widget> list = [];

    if (config.itemCount > 20) {
      print(
          "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
    }

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      Size size = active ? this.activeSize : this.size;
      list.add(SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          key: Key("pagination_$i"),
          margin: EdgeInsets.all(space),
          decoration: BoxDecoration(
            color: active ? activeColor : color,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return new Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return new Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}
