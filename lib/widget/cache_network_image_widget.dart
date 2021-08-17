import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/photo_view_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/2/21 4:08 PM

class CacheNetworkImageWidget extends StatefulWidget {
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, DownloadProgress)?
      progressIndicatorBuilder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Duration? fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final BaseCacheManager? cacheManager;
  final bool useOldImageOnUrlChange;
  final Color? color;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final Duration? placeholderFadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final ImageRenderMethodForWeb imageRenderMethodForWeb;
  final VoidCallback? onTap;

  const CacheNetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.httpHeaders,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheManager,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage, this.onTap,
  }) : super(key: key);

  @override
  _CacheNetworkImageWidgetState createState() =>
      _CacheNetworkImageWidgetState();
}

class _CacheNetworkImageWidgetState extends State<CacheNetworkImageWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null ? () {
        Get.to(PhotoViewWidget(urlList: [widget.imageUrl]));
      } : widget.onTap,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        httpHeaders: widget.httpHeaders,
        imageBuilder: widget.imageBuilder,
        placeholder: widget.placeholder,
        progressIndicatorBuilder:
            widget.progressIndicatorBuilder ?? _defaultProgressIndicatorBuilder,
        errorWidget: widget.errorWidget ?? _defaultErrorWidget,
        fadeOutDuration: widget.fadeOutDuration,
        fadeOutCurve: widget.fadeOutCurve,
        fadeInDuration: widget.fadeInDuration,
        fadeInCurve: widget.fadeInCurve,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        matchTextDirection: widget.matchTextDirection,
        cacheManager: widget.cacheManager,
        useOldImageOnUrlChange: widget.useOldImageOnUrlChange,
        color: widget.color,
        filterQuality: widget.filterQuality,
        colorBlendMode: widget.colorBlendMode,
        placeholderFadeInDuration: widget.placeholderFadeInDuration,
        memCacheWidth: widget.memCacheWidth,
        memCacheHeight: widget.memCacheHeight,
        cacheKey: widget.cacheKey,
        maxWidthDiskCache: widget.maxWidthDiskCache,
        maxHeightDiskCache: widget.maxHeightDiskCache,
        imageRenderMethodForWeb: widget.imageRenderMethodForWeb,
      ),
    );
  }

  Widget _defaultProgressIndicatorBuilder(
    BuildContext context,
    String url,
    DownloadProgress progress,
  ) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: progress.progress,
        ),
      ),
    );
  }

  Widget _defaultErrorWidget(
    BuildContext context,
    String url,
    dynamic error,
  ) {
    return Container(
      child: Center(
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: Dimens.font_size_14,
            ),
            Text(
              error.toString(),
              style: TextStyle(
                color: Colors.red,
                fontSize: Dimens.font_size_14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
