import 'package:flutter/material.dart';

/// jacokwu
/// 9/9/21 5:13 PM

class ExPageTwo extends StatelessWidget {
  const ExPageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('测试子路由2'),
        ),
      ),
    );
  }
}
