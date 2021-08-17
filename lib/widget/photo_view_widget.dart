import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

/// jacokwu
/// 8/10/21 4:04 PM

class PhotoViewWidget extends StatefulWidget {
  final List<String> urlList;
  final int initialIndex;
  final BoxDecoration? backgroundDecoration;
  final LoadingBuilder? loadingBuilder;
  final dynamic minScale;
  final dynamic maxScale;
  final Axis scrollDirection;

  const PhotoViewWidget(
      {Key? key,
      required this.urlList,
      this.initialIndex = 0,
      this.backgroundDecoration,
      this.loadingBuilder,
      this.minScale,
      this.maxScale,
      this.scrollDirection = Axis.horizontal})
      : super(key: key);

  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  late int currentIndex = widget.initialIndex;
  late PageController _pageController;

  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: light,
      child: Scaffold(
        body: GestureDetector(
          onLongPress: () {
            showBottomMenuDialog(context, [
              {
                'title': '下载',
                'key': 'download',
              },
              {
                'title': '分享',
                'key': 'shared',
              }
            ], (int index, String key) async {
              switch (key) {
                case 'download':
                  if (await getStoragePower()) {
                    String path = await getDownloadPath();
                    Dio().download(widget.urlList[currentIndex], '$path/ocr2.jpg').then((value) {
                      showToast('文件已保存至：$path/ocr2.jpg');
                    });
                  }
                  break;
                case 'shared':
                  String path = await getDownloadPath();
                  if (checkFileExist('$path/ocr2.jpg')) {
                    Share.shareFiles(['$path/ocr2.jpg']);
                  } else {
                    if (await getStoragePower()) {
                      Dio().download(widget.urlList[currentIndex], path).then((value) {
                        Share.shareFiles(['$path/ocr2.jpg']);
                      });
                    }
                  }

                  break;
                default:
                  break;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: widget.backgroundDecoration ?? BoxDecoration(color: Colors.black),
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: widget.urlList.length,
                  loadingBuilder: widget.loadingBuilder,
                  backgroundDecoration: widget.backgroundDecoration,
                  pageController: _pageController,
                  onPageChanged: onPageChanged,
                  scrollDirection: widget.scrollDirection,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "${currentIndex + 1}/${widget.urlList.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      decoration: null,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 20,
                  child: InkWell(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: Dimens.font_size_24,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.urlList[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
