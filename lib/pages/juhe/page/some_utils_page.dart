import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// jacokwu
/// 8/10/21 3:31 PM

class SomeUtilsPage extends StatefulWidget {
  const SomeUtilsPage({Key? key}) : super(key: key);

  @override
  _SomeUtilsPageState createState() => _SomeUtilsPageState();
}

class _SomeUtilsPageState extends State<SomeUtilsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(titleConfig: WAppBarTitleConfig(title: '一些功能'), showDefaultBack: true,),
      body: Container(
        child: Center(
          child: Column(
            children: [
              TextButton(onPressed: () async {
                String url = '';
                String qq = '10001';
                if(Platform.isAndroid){
                  url = 'mqqwpa://im/chat?chat_type=wpa&uin=$qq';
                }else{
                  url = 'http://maps.apple.com/?ll=116.3,39.95';
                }
                await canLaunch(url) ? await launch(url) : showToast('无法打开');
              }, child: Text('调起QQ')),
            ],
          ),
        ),
      ),
    );
  }
}

