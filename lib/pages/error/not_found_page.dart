import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '404'),
        showDefaultBack: true,
      ),
      body: Container(
        child: Center(
          child: Text('页面不存在', style: TextStyle(color: Colors.grey.shade400),),
        ),
      ),
    );
  }
}
