import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:jaguar/jaguar.dart';

class WebviewUnzipPage extends StatefulWidget {
  const WebviewUnzipPage({Key? key}) : super(key: key);

  @override
  _WebviewUnzipPageState createState() => _WebviewUnzipPageState();
}

class _WebviewUnzipPageState extends State<WebviewUnzipPage> {
  late String _savePath;
  late bool _canShow;

  @override
  void initState() {
    super.initState();
    _downloadFile();
    _canShow = false;
  }

  _startServe() {
    final serve = Jaguar(address: '127.0.0.1');
    serve.addRoute(serveFlutterAssets());
  }

  _downloadFile() async {
    showLoading();
    // _savePath = await _getSavePath();
    _savePath = 'assets';
    String filePath = '$_savePath/dist.zip';
    if (File(filePath).existsSync()) {
      _unZipFile(filePath);
    } else {
      await Dio().download(
          'https://jacokwu.cn/images/public/dist.zip', '$_savePath/dist.zip',
          onReceiveProgress: (int count, int total) {
        print('$total/$count');
      }).then((value) {
        _unZipFile(filePath);
      });
    }
  }

  _unZipFile(String filePath) async {
    final bytes = File(filePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$_savePath/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$_savePath/' + filename)..create(recursive: true);
      }
    }
    _canShow = true;
    setState(() {});
    dismissLoading();
  }

  Future<String> _getSavePath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory!.path;
  }

  Future<String> _loadHtmlFile() async {
    // return await rootBundle.loadString('$_savePath/dist/dist/index.html');
    return '$_savePath/dist/dist/index.html';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '解压缩'),
      ),
      body: Container(
        child: _canShow
            ? emptyWidget
            : emptyWidget,
      ),
    );
  }
}
