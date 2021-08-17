import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_webview.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// jacokwu
/// 8/9/21 10:06 AM

class PreviewPage extends StatefulWidget {
  final String initialUrl;

  const PreviewPage({Key? key, required this.initialUrl}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late WebViewController _viewController;
  String? _title = '';

  _getTitle() async {
    _title = await _viewController.getTitle();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig:
            WAppBarTitleConfig(title: _title!.isEmpty ? '预览' : _title!),
        showDefaultBack: true,
        onClickBackBtn: () async {
          if (await _viewController.canGoBack()) {
            _viewController.goBack();
          } else {
            Get.back();
          }
        },
        rightAction: PopupMenuButton(
          itemBuilder: (_) {
            return [
              PopupMenuItem(
                child: Text('复制链接'),
                value: 'copy',
              ),
            ];
          },
          onSelected: (value) {
            switch (value) {
              case 'copy':
                Clipboard.setData(ClipboardData(text: widget.initialUrl));
                showToast('复制成功');
                break;
              default:
                break;
            }
          },
        ),
      ),
      body: CustomWebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          _viewController = controller;
          print(await _viewController.getTitle());
          _getTitle();
          setState(() {});
        },
      ),
    );
  }
}
