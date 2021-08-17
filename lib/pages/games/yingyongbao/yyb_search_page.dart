import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_utils/common/model/yyb_list_model.dart';
import 'package:flutter_utils/pages/games/yingyongbao/request/post_http.dart';
import 'package:flutter_utils/pages/games/yingyongbao/widget/yyb_list_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/search_app_bar.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';

/// jacokwu
/// 8/16/21 1:38 PM

class YYBSearchPage extends StatefulWidget {
  const YYBSearchPage({Key? key}) : super(key: key);

  @override
  _YYBSearchPageState createState() => _YYBSearchPageState();
}

class _YYBSearchPageState extends State<YYBSearchPage> {
  late String _keywords;
  String? pns;
  int? sid;

  late List<YYBListModel> _dataSource;

  bool _hasNext = false;

  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _dataSource = [];
    _controller = EasyRefreshController();
    _keywords = '';
  }

  Future<List<YYBListModel>> search() async {
    return await YYBPostHttp.searchAppList(_keywords, pns, sid).then((value) {
      if (value['success'] == true || value['msg'] == null) {
        pns = value['obj']['pageNumberStack'];
        sid = value['obj']['searchId'];
        _hasNext = value['obj']['hasNext'] == 1;
        List<YYBListModel> fetchList = value['obj']['items'] == null
            ? []
            : value['obj']['items'].map<YYBListModel>((e) => YYBListModel.fromJson(e['appDetail'])).toList();
        _dataSource.addAll(fetchList);
        setState(() { });
        return fetchList;
      } else {
        showToast(value['msg']);
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        showDefaultBack: true,
        isSearch: true,
        onSearch: (text) {
          print(text);
          _keywords = text;
          pns = null;
          sid = null;
          _dataSource.clear();
          search();
        },
      ),
      body: RefreshListWidget(
        dataSource: _dataSource,
        controller: _controller,
        firstRefresh: false,
        onLoad: _hasNext ? search : null,
        itemBuilder: (int index, YYBListModel value) {
          return YYBListItemWidget(detail: value);
        },
      ),
    );
  }
}
