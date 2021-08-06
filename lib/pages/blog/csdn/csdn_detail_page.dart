import 'package:flutter/material.dart';
import 'package:flutter_utils/utils/utils.dart';
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
  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    print(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: Get.arguments['title']),
        showDefaultBack: true,
      ),
      body: CustomWebView(
        initialUrl: Get.arguments['url'],
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
