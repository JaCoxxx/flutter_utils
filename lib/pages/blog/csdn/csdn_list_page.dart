import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/blog/csdn/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 7/28/21 3:43 PM

class CSDNListPage extends StatefulWidget {
  const CSDNListPage({Key? key}) : super(key: key);

  @override
  _CSDNListPageState createState() => _CSDNListPageState();
}

class _CSDNListPageState extends State<CSDNListPage> {
  List _listData = [];

  @override
  void initState() {
    super.initState();
    CSDNPostHttp.init('jacoox');
    _getListPage();
  }

  _getListPage() async {
    showLoading();
    CSDNPostHttp.getListPage(null).then((value) {
      _getListData(value);
    }).catchError((err) {
      print(err);
      dismissLoading();
    });
  }

  _getListData(String value) async {
    RegExp _scriptExp =
        RegExp(r"\<script\> window\.__INITIAL_STATE__= (.*)\<\/script\>");
    RegExp _valueExp = RegExp(r"{.*}");
    String? _result = _valueExp.stringMatch(_scriptExp.stringMatch(value)!);
    Map<String, dynamic> _listPageData = jsonDecode(_result!);
    _listData = _listPageData['pageData']['data']['baseInfo']['latelyList'].where((element) => element['type'] == 'blog').toList();
    dismissLoading();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: 'CSDN'),
        showDefaultBack: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.pd8, vertical: Dimens.pd8),
        child: ListView.builder(
            itemBuilder: (_, index) => _buildItemWidget(_listData[index], index),
            itemCount: _listData.length),
      ),
    );
  }

  Widget _buildItemWidget(Map item, int index) {
    return Card(
      shadowColor: Colors.transparent,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'], style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_18),),
                  Dimens.hGap4,
                  Text(item['description'], style: TextStyle(color: Colors.grey.shade600, fontSize: Dimens.font_size_14),),
                  Dimens.hGap4,
                  Row(
                    children: [
                      _buildItemTap(item['hasOriginal']),
                      _buildItemCountWidget('${item['viewCount']}阅读'),
                      Dimens.wGap8,
                      _buildItemCountWidget('${item['commentCount']}评论'),
                      Dimens.wGap8,
                      _buildItemCountWidget('${item['diggCount']}点赞'),
                      Spacer(),
                      _buildItemCountWidget('发布于${item['formatTime']}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            print(item);
            Get.toNamed('/csdn-detail', arguments: {
              'url': item['url'],
              'title': item['title'],
            });
          },
        ),
      ),
    );
  }
  
  Widget _buildItemTap(bool hasOriginal) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd4, vertical: Dimens.pd2),
      margin: EdgeInsets.only(right: Dimens.pd8),
      color: hasOriginal ? Color.fromRGBO(227, 62, 51, .1) : Color.fromRGBO(103, 187, 85, .1),
      child: Text(hasOriginal ? '原创' : '转载', style: TextStyle(
        fontSize: Dimens.font_size_14,
        color: hasOriginal ? Color(0xffe33e33) : Color(0xff67bb55),
      ),),
    );
  }

  Widget _buildItemCountWidget(String value) {
    return Text(value, style: TextStyle(
      fontSize: Dimens.font_size_14,
      color: Color.fromRGBO(85, 86, 102, 1),
    ));
  }
}
