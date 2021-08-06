import 'package:flutter/material.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// jacokwu
/// 7/28/21 3:32 PM

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '我的博客'),
        showDefaultBack: true,
      ),
      body: WebView(
        onPageStarted: (_) {
          showLoading();
        },
        onPageFinished: (_) {
          dismissLoading();
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://jacokwu.cn/blog/',
      ),
    );
  }
}

