import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/dialog_utils.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

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

  /// 设置壁纸用，需要设置壁纸必传
  final BaseCacheManager? cacheManager;

  const PhotoViewWidget({
    Key? key,
    required this.urlList,
    this.initialIndex = 0,
    this.backgroundDecoration,
    this.loadingBuilder,
    this.minScale,
    this.maxScale,
    this.scrollDirection = Axis.horizontal,
    this.cacheManager,
  }) : super(key: key);

  @override
  _PhotoViewWidgetState createState() => _PhotoViewWidgetState();
}

class _PhotoViewWidgetState extends State<PhotoViewWidget> {
  late int currentIndex = widget.initialIndex;
  late PageController _pageController;
  late List<Map<String, dynamic>> _menuList;

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
    _menuList = [
      {
        'title': '下载',
        'key': 'download',
      },
      {
        'title': '分享',
        'key': 'shared',
      },
    ];
    _getExpandMenuList();
  }

  _getExpandMenuList() {
    print(widget.cacheManager != null && Platform.isAndroid);
    if (widget.cacheManager != null && Platform.isAndroid)
      _menuList.addAll([
        {
          'title': '设为桌面壁纸',
          'key': 'home',
        },
        {
          'title': '设为锁屏壁纸',
          'key': 'lock',
        },
        {
          'title': '设为桌面/锁屏壁纸',
          'key': 'both',
        },
      ]);
    setState(() {});
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
            showBottomMenuDialog(context, _menuList, (int index, String key) async {
              String fileName = getNameByUrl(widget.urlList[currentIndex]);
              String path = await getDownloadPath();
              switch (key) {
                case 'download':
                  if (await getStoragePower()) {
                    Dio().download(widget.urlList[currentIndex], '$path/$fileName').then((value) {
                      showToast('文件已保存至：$path/$fileName');
                    });
                  }
                  break;
                case 'shared':
                  if (checkFileExist('$path/$fileName')) {
                    Share.shareFiles(['$path/$fileName']);
                  } else {
                    if (await getStoragePower()) {
                      Dio().download(widget.urlList[currentIndex], path).then((value) {
                        Share.shareFiles(['$path/$fileName']);
                      });
                    }
                  }
                  break;
                case 'home':
                  if (widget.cacheManager == null) break;

                  File cachedImage = await widget.cacheManager!.getSingleFile(widget.urlList[currentIndex]);

                  int location = WallpaperManagerFlutter.HOME_SCREEN;

                  WallpaperManagerFlutter().setwallpaperfromFile(cachedImage, location).then((value) {
                    showToast('设置成功');
                  }).catchError((err) {
                    print(err);
                    showToast('设置失败');
                  });
                  break;
                case 'lock':
                  if (widget.cacheManager == null) break;

                  File cachedImage = await widget.cacheManager!.getSingleFile(widget.urlList[currentIndex]);

                  int location = WallpaperManagerFlutter.LOCK_SCREEN;

                  WallpaperManagerFlutter().setwallpaperfromFile(cachedImage, location).then((value) {
                    showToast('设置成功');
                  }).catchError((err) {
                    print(err);
                    showToast('设置失败');
                  });
                  break;
                case 'both':
                  if (widget.cacheManager == null) break;

                  File cachedImage = await widget.cacheManager!.getSingleFile(widget.urlList[currentIndex]);

                  int location = WallpaperManagerFlutter.BOTH_SCREENS;

                  WallpaperManagerFlutter().setwallpaperfromFile(cachedImage, location).then((value) {
                    showToast('设置成功');
                  }).catchError((err) {
                    print(err);
                    showToast('设置失败');
                  });
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
      minScale: PhotoViewComputedScale.contained * 0.5,
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
