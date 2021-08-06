import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/base_column_model.dart';
import 'package:flutter_utils/widget/grid_table/custom_data_grid_source.dart';
import 'package:flutter_utils/widget/grid_table/grid_table_params.dart';
import 'package:flutter_utils/widget/grid_table/grid_table_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// jacokwu
/// 8/4/21 3:58 PM

class GridTableWidget extends StatefulWidget {
  final List<BaseColumnModel> columns;
  final List<Map<String, dynamic>> dataSource;
  final GridTableParams? params;

  const GridTableWidget(
      {Key? key, required this.columns, required this.dataSource, this.params})
      : super(key: key);

  @override
  _GridTableWidgetState createState() => _GridTableWidgetState();
}

class _GridTableWidgetState extends State<GridTableWidget> {

  late GridTableParams _params;

  @override
  void initState() {
    super.initState();
    _params = widget.params ?? GridTableParams();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
        source: CustomDataGridSource(
            dataSource: widget.dataSource, columns: widget.columns),
        columns: _buildColumns(),
        rowHeight: _params.rowHeight,
        headerRowHeight: _params.headerRowHeight,
        defaultColumnWidth: _params.defaultColumnWidth,
        gridLinesVisibility: _params.gridLinesVisibility,
        headerGridLinesVisibility: _params.headerGridLinesVisibility,
        columnWidthMode: _params.columnWidthMode,
        columnSizer: _params.columnSizer,
        columnWidthCalculationRange: _params.columnWidthCalculationRange,
        selectionMode: _params.selectionMode,
        navigationMode: _params.navigationMode,
        frozenColumnsCount: _params.frozenColumnsCount,
        footerFrozenColumnsCount: _params.footerFrozenColumnsCount,
        frozenRowsCount: _params.frozenRowsCount,
        footerFrozenRowsCount: _params.footerFrozenRowsCount,
        allowSorting: _params.allowSorting,
        allowMultiColumnSorting: _params.allowMultiColumnSorting,
        allowTriStateSorting: _params.allowTriStateSorting,
        showSortNumbers: _params.showSortNumbers,
        sortingGestureType: _params.sortingGestureType,
        stackedHeaderRows: _params.stackedHeaderRows,
        selectionManager: _params.selectionManager,
        controller: _params.controller,
        onQueryRowHeight: _params.onQueryRowHeight,
        onSelectionChanged: _params.onSelectionChanged,
        onSelectionChanging: _params.onSelectionChanging,
        onCellRenderersCreated: _params.onCellRenderersCreated,
        onCurrentCellActivating: _params.onCurrentCellActivating,
        onCurrentCellActivated: _params.onCurrentCellActivated,
        onCellTap: _params.onCellTap,
        onCellDoubleTap: _params.onCellDoubleTap,
        onCellSecondaryTap: _params.onCellSecondaryTap,
        onCellLongPress: _params.onCellLongPress,
        isScrollbarAlwaysShown: _params.isScrollbarAlwaysShown,
        horizontalScrollPhysics: _params.horizontalScrollPhysics,
        verticalScrollPhysics: _params.verticalScrollPhysics,
        loadMoreViewBuilder: _params.loadMoreViewBuilder,
        allowPullToRefresh: _params.allowPullToRefresh ,
        refreshIndicatorDisplacement: _params.refreshIndicatorDisplacement,
        refreshIndicatorStrokeWidth: _params.refreshIndicatorStrokeWidth,
        allowSwiping: _params.allowSwiping,
        swipeMaxOffset: _params.swipeMaxOffset,
        horizontalScrollController: _params.horizontalScrollController,
        verticalScrollController: _params.verticalScrollController,
        onSwipeStart: _params.onSwipeStart,
        onSwipeUpdate: _params.onSwipeUpdate,
        onSwipeEnd: _params.onSwipeEnd,
        startSwipeActionsBuilder: _params.startSwipeActionsBuilder,
        endSwipeActionsBuilder: _params.endSwipeActionsBuilder,
        highlightRowOnHover: _params.highlightRowOnHover,
        allowEditing: _params.allowEditing,
        editingGestureType: _params.editingGestureType,
        footer: _params.footer,
        footerHeight: _params.footerHeight,
    );
  }

  List<GridColumn> _buildColumns() {
    List<GridColumn> columns = [];
    widget.columns.forEach((element) {
      columns.add(GridColumn(
        autoFitPadding: EdgeInsets.only(
            left: element.pl ?? Dimens.pd16,
            right: element.pr ?? Dimens.pd16,
            top: element.pt ?? Dimens.pd16,
            bottom: element.pb ?? Dimens.pd16),
          columnName: element.title,
          label: _buildColumnsTitle(element),
          minimumWidth: element.width != null && element.width! < 100 ? element.width! : 100,
          maximumWidth: element.width != null && element.width! > 150 ? element.width! : 150,
          width: element.width ?? double.nan));
    });
    return columns;
  }

  Widget _buildColumnsTitle(BaseColumnModel item) {
    return Container(
        alignment: GridTableUtils.getAlignment(item.align),
        child: Text(
          item.title,
          textAlign: TextAlign.center,
        ));
  }
}
