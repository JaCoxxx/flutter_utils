import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/base_column_model.dart';
import 'package:flutter_utils/widget/grid_table/grid_table_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// jacokwu
/// 8/4/21 4:00 PM

class CustomDataGridSource extends DataGridSource {
  CustomDataGridSource(
      {required List<Map<String, dynamic>> dataSource,
      required List<BaseColumnModel> columns,
      Widget Function(DataGridCell dataGridCell)? buildContent}) {
    _dataSource = dataSource
        .map<DataGridRow>((element) => DataGridRow(
            cells: columns
                .map<DataGridCell>(
                    (e) => DataGridCell(columnName: e.title, value: {
                          ...e.toJson(),
                          'value': element[e.key],
                        }))
                .toList()))
        .toList();
    _buildContent = buildContent;
  }

  List<DataGridRow> _dataSource = [];

  Widget Function(DataGridCell dataGridCell)? _buildContent;

  @override
  List<DataGridRow> get rows => _dataSource;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: GridTableUtils.getAlignment(dataGridCell.value['align']),
        padding: EdgeInsets.only(
            left: dataGridCell.value['pl'] ?? Dimens.pd16,
            right: dataGridCell.value['pr'] ?? Dimens.pd16,
            top: dataGridCell.value['pt'] ?? Dimens.pd16,
            bottom: dataGridCell.value['pb'] ?? Dimens.pd16),
        child: _buildContent == null
            ? Text(dataGridCell.value['value'].toString())
            : _buildContent!(dataGridCell),
      );
    }).toList());
  }
}
