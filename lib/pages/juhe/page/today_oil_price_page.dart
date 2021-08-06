import 'package:flutter/material.dart';
import 'package:flutter_utils/common/model/base_column_model.dart';
import 'package:flutter_utils/pages/juhe/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/grid_table/grid_table_params.dart';
import 'package:flutter_utils/widget/grid_table/grid_table_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// jacokwu
/// 8/3/21 1:43 PM

class TodayOilPricePage extends StatefulWidget {
  const TodayOilPricePage({Key? key}) : super(key: key);

  @override
  _TodayOilPricePageState createState() => _TodayOilPricePageState();
}

class _TodayOilPricePageState extends State<TodayOilPricePage> {
  late List<Map<String, dynamic>> _oilPriceList;
  late List<BaseColumnModel> _columns;

  @override
  initState() {
    super.initState();
    _oilPriceList = [];
    _columns = [];
    _getOilPrice();
  }

  _getOilPrice() async {
    showLoading();
    JuHePostHttp.getTodayOilPrice().then((value) {
      if (value['error_code'] == 0) {
        _oilPriceList
          ..clear()
          ..addAll(value['result']
              .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
        _columns = generateColumns();
        setState(() {});
      } else {
        showToast(value['reason']);
      }
      dismissLoading();
    });
  }

  List<BaseColumnModel> generateColumns() {
    List<BaseColumnModel> columns = [];
    _oilPriceList[0].keys.forEach((element) {
      columns.add(BaseColumnModel.fromJson({
        'title': element == 'city' ? '城市城市城市城市' : element,
        'key': element,
        'width': element == 'city' ? 140.00 : null,
      }));
    });
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '今日国内油价'),
        showDefaultBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridTableWidget(
                columns: _columns,
                dataSource: _oilPriceList,
                params: GridTableParams(
                  frozenColumnsCount: 1,
                ),
              ),
            ),
          ),
          safeAreaBottom(context),
        ],
      ),
    );
  }
}
