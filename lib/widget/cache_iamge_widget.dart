import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:octo_image/octo_image.dart';

/// jacokwu
/// 8/6/21 9:36 AM

class CacheImageWidget extends StatefulWidget {
  const CacheImageWidget({Key? key}) : super(key: key);

  @override
  _CacheImageWidgetState createState() => _CacheImageWidgetState();
}

class _CacheImageWidgetState extends State<CacheImageWidget> {
  @override
  Widget build(BuildContext context) {
    return OctoImage(
      width: 60,
      fit: BoxFit.cover,
      image: CachedNetworkImageProvider(
          'https://jacokwu.cn/images/public/ocr2.jp'),
      imageBuilder: OctoImageTransformer.circleAvatar(),
      progressIndicatorBuilder: (context, progress) {
        double? value;
        var expectedBytes = progress?.expectedTotalBytes;
        if (progress != null && expectedBytes != null) {
          value = progress.cumulativeBytesLoaded / expectedBytes;
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(value: value),
          ),
        );
      },
      errorBuilder: (_, error, stackTrace) {
        return Container(
          child: Center(
            child: Icon(Icons.error),
          ),
        );
      },
    );
  }
}
