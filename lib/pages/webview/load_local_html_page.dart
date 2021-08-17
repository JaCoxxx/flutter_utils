import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// jacokwu
/// 8/9/21 2:53 PM

class LoadLocalHtmlPage extends StatefulWidget {
  const LoadLocalHtmlPage({Key? key}) : super(key: key);

  @override
  _LoadLocalHtmlPageState createState() => _LoadLocalHtmlPageState();
}

class _LoadLocalHtmlPageState extends State<LoadLocalHtmlPage> {

  late WebViewController _viewController;
  String _title = '测试网页';

  _getTitle() async {
    String? title = await _viewController.getTitle();
    print(title);
    if (title != null && title != '') _title = title;
  }

  String getAssetsPath(String path) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'file:///android_asset/flutter_assets/' + path;
    } else {
      return 'file://Frameworks/App.framework/flutter_assets/' + path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: _title),
        showDefaultBack: true,
        rightAction: IconButton(onPressed: () {
          _viewController.reload();
        }, icon: Icon(CupertinoIcons.refresh)),
      ),
      body: CustomWebView(
        initialUrl: getAssetsPath('assets/h5/index.html?url=https://jacokwu.cn/images/public/IR02114178.pdf'),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          _viewController = controller;
          await _getTitle();
          setState(() { });
        },
      ),
    );
  }
}
