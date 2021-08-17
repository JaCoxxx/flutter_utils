import 'package:flutter/material.dart';

/// jacokwu
/// 8/16/21 4:36 PM

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset('assets/images/empty.png'),
          ),
          Text(
            '没有数据',
            style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
          ),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
        ],
      ),
    );
  }
}

