import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/yyb_list_model.dart';
import 'package:flutter_utils/pages/games/yingyongbao/request/post_http.dart';
import 'package:flutter_utils/pages/games/yingyongbao/widget/yyb_list_item_widget.dart';
import 'package:flutter_utils/pages/games/yingyongbao/yyb_detail_page.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/search_app_bar.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/12/21 2:30 PM

class YYBListPage extends StatefulWidget {
  const YYBListPage({Key? key}) : super(key: key);

  @override
  _YYBListPageState createState() => _YYBListPageState();
}

class _YYBListPageState extends State<YYBListPage> {
  /// 列表查询参数
  String _pageContext = '0';

  List<YYBListModel> _allGameList = [];

  @override
  void initState() {
    super.initState();
    YYBPostHttp.init();
    _getAllGameList();
  }

  Future<List<YYBListModel>> _getAllGameList() async {
    return await YYBPostHttp.getAllGameList(pageContext: _pageContext).then((value) {
      if (value['success']) {
        if (_pageContext == '0') _allGameList.clear();
        _allGameList.addAll(value['obj'].map<YYBListModel>((e) => YYBListModel.fromJson(e)));
        _pageContext = value['pageContext'];
        setState(() {});
        List<YYBListModel> fetchList = value['obj'].map<YYBListModel>((e) => YYBListModel.fromJson(e)).toList();
        return fetchList;
      } else {
        showToast(value['msg'] ?? '请求失败');
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(showDefaultBack: true, onSearchBoxTap: () {
        Get.toNamed('/yyb-search');
      },),
      body: RefreshListWidget(
        itemBuilder: _buildItemWidget,
        onRefresh: () async {
          _pageContext = '0';
          return _getAllGameList();
        },
        onLoad: _getAllGameList,
        separatorBuilder: (index, item) => Dimens.hGap6,
      ),
    );
  }

  Widget _buildItemWidget(int index, YYBListModel item) {
    return YYBListItemWidget(detail: item);
  }
}
