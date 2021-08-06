import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/juhe/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/slide_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/2/21 10:32 AM

class ToDayHistoryDetailPage extends StatefulWidget {
  const ToDayHistoryDetailPage({Key? key}) : super(key: key);

  @override
  _ToDayHistoryDetailPageState createState() => _ToDayHistoryDetailPageState();
}

class _ToDayHistoryDetailPageState extends State<ToDayHistoryDetailPage> {
  late dynamic _headerValue;
  dynamic _detailValue = {};

  @override
  void initState() {
    super.initState();
    _headerValue = Get.arguments;
    _getDetailValue();
  }

  _getDetailValue() async {
    showLoading();
    JuHePostHttp.getTodayHistoryDetail(_headerValue['e_id']).then((value) {
      if (value['error_code'] == 0) {
        _detailValue = value['result'][0];
        setState(() {});
      } else {
        showToast(value['reason'] ?? '');
      }
      dismissLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: _headerValue['title'] ?? ''),
        showDefaultBack: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd8),
      child: Column(
        children: [
          if (_detailValue['picUrl'] != null && _detailValue['picUrl'].length > 0)
            SlideWidget(list: _detailValue['picUrl']),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_detailValue['content'] == null
                  ? ''
                  : _detailValue['content'].replaceAll('&#13;', '')),
            ),
          ),
          safeAreaBottom(context),
        ],
      ),
    );
  }
}
