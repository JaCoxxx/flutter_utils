import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/blog/csdn/preview_page.dart';
import 'package:flutter_utils/pages/blog/csdn/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_webview.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// jacokwu
/// 7/29/21 10:28 AM

class CSDNDetailPage extends StatefulWidget {
  const CSDNDetailPage({Key? key}) : super(key: key);

  @override
  _CSDNDetailPageState createState() => _CSDNDetailPageState();
}

class _CSDNDetailPageState extends State<CSDNDetailPage> {
  Html? _html;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    print(Get.arguments);
    _getDetailPage();
  }

  _getDetailPage() async {
    showLoading();
    await CSDNPostHttp.getDetailPage(Get.arguments['url']).then((value) {
      _getDetailData(value);
    });
  }

  _getDetailData(String value) async {
    RegExp _scriptExp =
        RegExp(r'<article class="baidu_pl">((.|\n)*)</article>');
    String? _result = _scriptExp.stringMatch(value);
    print(_result);
    _html = Html(
      shrinkWrap: true,
      data: _result,
      onLinkTap: (url, _, attributes, element) {
        print(url!);
        print(attributes);
        Get.to(PreviewPage(initialUrl: url));
      },
      onImageTap: (url, _, attributes, element) {
        print(url);
        print(attributes);
      },
      customRender: {
        'pre': (_, parsedChild) {
          return MediaQuery.removePadding(
            context: context,
            removeRight: true,
            removeLeft: true,
            removeBottom: true,
            removeTop: true,
            child: Container(
              width: double.infinity,
              child: Card(
                child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.pd8, vertical: Dimens.pd2),
                      child: parsedChild),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          );
        },
        'blockquote': (_, parsedChild) {  
          parsedChild
            ..marginZero
            ..paddingZero;
          return MediaQuery.removeViewPadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            removeLeft: true,
            removeRight: true,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffeef0f4),
                border: Border(
                    left: BorderSide(
                        color: Color(0xffdddfe4), width: Dimens.pd8)),
              ),
              child: parsedChild,
            ),
          );
        },
      },
      customImageRenders: {
        networkSourceMatcher(): (context, attributes, element) {
          return Container(
              child: Center(
                  child: CacheNetworkImageWidget(
                      imageUrl: attributes["src"] ?? "about:blank")));
        }
      },
    );
    dismissLoading();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: Get.arguments['title']),
        showDefaultBack: true,
      ),
      body: SingleChildScrollView(
        child: _html == null ? Container() : _html,
      ),
    );
  }
}
