import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';

/// jacokwu
/// 8/2/21 10:59 AM

class SlideWidget extends StatefulWidget {
  final List list;

  const SlideWidget({Key? key, required this.list}) : super(key: key);

  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(MediaQuery.of(context).size.width, 180)),
      child: Swiper(
        autoplay: true,
        itemCount: widget.list.length,
        itemBuilder: (_, index) => _buildItemWidget(index, widget.list[index]),
        pagination: SwiperPagination(builder: DotSwiperPaginationBuilder()),
      ),
    );
  }

  Widget _buildItemWidget(int index, dynamic item) {
    return CacheNetworkImageWidget(imageUrl: item['url'], fit: BoxFit.fill,);
  }
}
