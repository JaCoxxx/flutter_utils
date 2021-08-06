import 'package:flutter/material.dart';
import 'package:flutter_utils/common/custom_type.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/juhe/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/timeline_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 7/30/21 4:22 PM

class TodayHistoryPage extends StatefulWidget {
  const TodayHistoryPage({Key? key}) : super(key: key);

  @override
  _TodayHistoryPageState createState() => _TodayHistoryPageState();
}

class _TodayHistoryPageState extends State<TodayHistoryPage> {
  late List<Map<String, dynamic>> _todayHistoryList;
  late String _toDay;

  @override
  initState() {
    super.initState();

    _todayHistoryList = [];

    _getNowDay();
    _getTodayHistoryList();
  }

  _getTodayHistoryList() async {
    showLoading();
    JuHePostHttp.getTodayHistoryList(_toDay).then((value) {
      if (value['error_code'] == 0) {
        _todayHistoryList
          ..clear()
          ..addAll(value['result']
              .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
        setState(() {});
      } else {
        showToast(value['reason'] ?? '');
      }
      dismissLoading();
    }).catchError((err) {
      print(err);
      dismissLoading();
    });
  }

  _getNowDay() {
    DateTime date = new DateTime.now();
    _toDay = '${date.month}/${date.day}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        showDefaultBack: true,
        titleConfig: WAppBarTitleConfig(title: '历史上的今天'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          Card(
            shadowColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(_toDay.split('/')[1], style: TextStyle(color: Colors.black54, fontSize: 80),),
                Text('/${_toDay.split('/')[0]}')
              ],
            ),
          ),
          Expanded(
            child: TimeLineWidget(
              childList: _todayHistoryList.reversed.toList(),
              buildRight: _buildRight,
              buildLeft: _buildLeft,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRight(int index, dynamic item) {
    return InkWell(
      child: Card(
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Dimens.pd16, horizontal: Dimens.pd8),
          child: Text(item['title']),
        ),
      ),
      onTap: () {
        Get.toNamed('/today-history-detail',arguments: item);
      },
    );
  }

  Widget _buildLeft(int index, dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(left: Dimens.pd8),
      child: Text('${item['date'].split('年')[0]}年'),
    );
  }
}
