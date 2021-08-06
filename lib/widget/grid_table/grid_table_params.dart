import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// jacokwu
/// 8/4/21 5:00 PM

class GridTableParams {
  /// The height of each row except the column header.
  ///
  /// Defaults to 49.0
  final double rowHeight;

  /// The height of the column header row.
  ///
  /// Defaults to 56.0
  final double headerRowHeight;

  /// The width of each column.
  ///
  /// If the [columnWidthMode] is set for [SfDataGrid] or [GridColumn], or
  /// [GridColumn.width] is set, [defaultColumnWidth] will not be considered.
  ///
  /// Defaults to 90.0 for Android & iOS and 100.0 for Web.
  final double defaultColumnWidth;

  /// How the column widths are determined.
  ///
  /// Defaults to [ColumnWidthMode.none]
  ///
  /// Also refer [ColumnWidthMode]
  final ColumnWidthMode columnWidthMode;

  /// How the row count should be considered when calculating the width of a
  /// column.
  ///
  /// Provides options to consider only visible rows or all the rows which are
  /// available in [SfDataGrid].
  ///
  /// Defaults to [ColumnWidthCalculationRange.visibleRows]
  ///
  /// Also refer [ColumnWidthCalculationRange]
  final ColumnWidthCalculationRange columnWidthCalculationRange;

  /// The [ColumnSizer] used to control the column width sizing operation of
  /// each columns.
  ///
  /// You can override the available methods and customize the required
  /// operations in the custom [ColumnSizer].
  final ColumnSizer? columnSizer;

  /// How the border should be visible.
  ///
  /// Decides whether vertical, horizontal, both the borders and no borders
  /// should be drawn.
  ///
  /// Defaults to [GridLinesVisibility.horizontal]
  ///
  /// Also refer [GridLinesVisibility]
  final GridLinesVisibility gridLinesVisibility;

  /// How the border should be visible in header cells.
  ///
  /// Decides whether vertical or horizontal or both the borders or no borders
  /// should be drawn.
  ///
  /// [GridLinesVisibility.horizontal] will be useful if you are using
  /// [stackedHeaderRows] to improve the readability.
  ///
  /// Defaults to [GridLinesVisibility.horizontal]
  ///
  /// Also refer [GridLinesVisibility].
  ///
  /// See also, [gridLinesVisibility] – To set the border for cells other than
  /// header cells.
  final GridLinesVisibility headerGridLinesVisibility;

  /// Invoked when the row height for each row is queried.
  final QueryRowHeightCallback? onQueryRowHeight;

  /// How the rows should be selected.
  ///
  /// Provides options to select single row or multiple rows.
  ///
  /// Defaults to [SelectionMode.none].
  ///
  /// Also refer [SelectionMode]
  final SelectionMode selectionMode;

  /// Invoked when the row is selected.
  ///
  /// This callback never be called when the [onSelectionChanging] is returned
  /// as false.
  final void Function(
          List<DataGridRow> addedRows, List<DataGridRow> removedRows)?
      onSelectionChanged;

  /// Invoked when the row is being selected or being unselected
  ///
  /// This callback's return type is [bool]. So, if you want to cancel the
  /// selection on a row based on the condition, return false.
  /// Otherwise, return true.
  final SelectionChangingCallback? onSelectionChanging;

  /// The [SelectionManagerBase] used to control the selection operations
  /// in [SfDataGrid].
  ///
  /// You can override the available methods and customize the required
  /// operations in the custom [RowSelectionManager].
  ///
  /// Defaults to null
  final SelectionManagerBase? selectionManager;

  /// The [DataGridController] used to control the current cell navigation and
  /// selection operation.
  ///
  /// Defaults to null.
  ///
  /// This object is expected to be long-lived, not recreated with each build.
  final DataGridController? controller;

  /// Called when the cell renderers are created for each column.
  ///
  /// This method is called once when the [SfDataGrid] is loaded. Users can
  /// provide the custom cell renderer to the existing collection.
  final CellRenderersCreatedCallback? onCellRenderersCreated;

  /// Decides whether the navigation in the [SfDataGrid] should be cell wise
  /// or row wise.
  final GridNavigationMode navigationMode;

  /// Invoked when the cell is activated.
  ///
  /// This callback never be called when the [onCurrentCellActivating] is
  /// returned as false.
  final CurrentCellActivatedCallback? onCurrentCellActivated;

  /// Invoked when the cell is being activated.
  ///
  /// This callback's return type is [bool]. So, if you want to cancel cell
  /// activation based on the condition, return false. Otherwise,
  /// return true.
  final CurrentCellActivatingCallback? onCurrentCellActivating;

  /// Called when a tap with a cell has occurred.
  final DataGridCellTapCallback? onCellTap;

  /// Called when user is tapped a cell with a primary button at the same cell
  /// twice in quick succession.
  final DataGridCellDoubleTapCallback? onCellDoubleTap;

  /// Called when a long press gesture with a primary button has been
  /// recognized for a cell.
  final DataGridCellTapCallback? onCellSecondaryTap;

  /// Called when a tap with a cell has occurred with a secondary button.
  final DataGridCellLongPressCallback? onCellLongPress;

  /// The number of non-scrolling columns at the left side of [SfDataGrid].
  ///
  /// In Right To Left (RTL) mode, this count refers to the number of
  /// non-scrolling columns at the right side of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [footerFrozenColumnsCount]
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line
  final int frozenColumnsCount;

  /// The number of non-scrolling columns at the right side of [SfDataGrid].
  ///
  /// In Right To Left (RTL) mode, this count refers to the number of
  /// non-scrolling columns at the left side of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int footerFrozenColumnsCount;

  /// The number of non-scrolling rows at the top of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [footerFrozenRowsCount]
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int frozenRowsCount;

  /// The number of non-scrolling rows at the bottom of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int footerFrozenRowsCount;

  /// Decides whether user can sort the column simply by tapping the column
  /// header.
  ///
  /// Defaults to false.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfDataGrid(
  ///     source: _employeeDataSource,
  ///     allowSorting: true,
  ///     columns: [
  ///         GridColumn(columnName: 'id', label: Text('ID')),
  ///         GridColumn(columnName: 'name', label: Text('Name')),
  ///         GridColumn(columnName: 'designation', label: Text('Designation')),
  ///         GridColumn(columnName: 'salary', label: Text('Salary')),
  ///   ]);
  /// }
  ///
  /// class EmployeeDataSource extends DataGridSource {
  ///   @override
  ///   List<DataGridRow> get rows => _employees
  ///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
  ///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
  ///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
  ///             DataGridCell<String>(
  ///                 columnName: 'designation', value: dataRow.designation),
  ///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
  ///           ]))
  ///       .toList();
  ///
  ///   @override
  ///   DataGridRowAdapter? buildRow(DataGridRow row) {
  ///     return DataGridRowAdapter(
  ///         cells: row.getCells().map<Widget>((dataCell) {
  ///       return Text(dataCell.value.toString());
  ///     }).toList());
  ///   }
  /// }
  ///
  /// ```
  ///
  ///
  /// See also:
  ///
  /// * [GridColumn.allowSorting] - which allows users to sort the columns in
  /// [SfDataGrid].
  /// * [sortingGestureType] – which allows users to sort the column in tap or
  /// double tap.
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowSorting;

  /// Decides whether user can sort more than one column.
  ///
  /// Defaults to false.
  ///
  /// This is applicable only if the [allowSorting] is set as true.
  ///
  /// See also:
  ///
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowMultiColumnSorting;

  /// Decides whether user can sort the column in three states: ascending,
  /// descending, unsorted.
  ///
  /// Defaults to false.
  ///
  /// This is applicable only if the [allowSorting] is set as true.
  ///
  /// See also:
  ///
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowTriStateSorting;

  /// Decides whether the sequence number should be displayed on the header cell
  ///  of sorted column during multi-column sorting.
  ///
  /// Defaults to false
  ///
  /// This is applicable only if the [allowSorting] and
  /// [allowMultiColumnSorting] are set as true.
  ///
  /// See also:
  ///
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool showSortNumbers;

  /// Decides whether the sorting should be applied on tap or double tap the
  /// column header.
  ///
  /// Default to [SortingGestureType.tap]
  ///
  /// see also:
  ///
  /// [allowSorting]
  final SortingGestureType sortingGestureType;

  /// The collection of [StackedHeaderRow].
  ///
  /// Stacked headers enable you to display headers that span across multiple
  /// columns and rows. These rows are displayed above to the regular column
  /// headers.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfDataGrid(source: _employeeDataSource, columns: <GridColumn>[
  ///     GridColumn(columnName: 'id', label: Text('ID')),
  ///     GridColumn(columnName: 'name', label: Text('Name')),
  ///     GridColumn(columnName: 'designation', label: Text('Designation')),
  ///     GridColumn(columnName: 'salary', label: Text('Salary'))
  ///   ], stackedHeaderRows: [
  ///     StackedHeaderRow(cells: [
  ///       StackedHeaderCell(
  ///         columnNames: ['id', 'name', 'designation', 'salary'],
  ///         child: Center(
  ///           child: Text('Order Details'),
  ///         ),
  ///       ),
  ///     ])
  ///   ]);
  /// }
  /// ```
  final List<StackedHeaderRow> stackedHeaderRows;

  /// Indicates whether the horizontal and vertical scrollbars should always
  /// be visible. When false, both the scrollbar will be shown during scrolling
  /// and will fade out otherwise. When true, both the scrollbar will always be
  /// visible and never fade out.
  ///
  /// Defaults to false
  final bool isScrollbarAlwaysShown;

  /// How the horizontal scroll view should respond to user input.
  /// For example, determines how the horizontal scroll view continues to animate after the user stops dragging the scroll view.
  ///
  /// Defaults to [AlwaysScrollableScrollPhysics].
  final ScrollPhysics horizontalScrollPhysics;

  /// How the vertical scroll view should respond to user input.
  /// For example, determines how the vertical scroll view continues to animate after the user stops dragging the scroll view.
  ///
  /// Defaults to [AlwaysScrollableScrollPhysics].
  final ScrollPhysics verticalScrollPhysics;

  /// A builder that sets the widget to display at the bottom of the datagrid
  /// when vertical scrolling reaches the end of the datagrid.
  ///
  /// You should override [DataGridSource.handleLoadMoreRows] method to load
  /// more rows and then notify the datagrid about the changes. The
  /// [DataGridSource.handleLoadMoreRows] can be called to load more rows from
  /// this builder using `loadMoreRows` function which is passed as a parameter
  /// to this builder.
  ///
  /// ## Infinite scrolling
  ///
  /// The example below demonstrates infinite scrolling by showing the circular
  /// progress indicator until the rows are loaded when vertical scrolling
  /// reaches the end of the datagrid,
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(title: Text('Syncfusion Flutter DataGrid')),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       loadMoreViewBuilder:
  ///           (BuildContext context, LoadMoreRows loadMoreRows) {
  ///         Future<String> loadRows() async {
  ///           await loadMoreRows();
  ///           return Future<String>.value('Completed');
  ///         }
  ///
  ///         return FutureBuilder<String>(
  ///           initialData: 'loading',
  ///           future: loadRows(),
  ///           builder: (context, snapShot) {
  ///             if (snapShot.data == 'loading') {
  ///               return Container(
  ///                   height: 98.0,
  ///                   color: Colors.white,
  ///                   width: double.infinity,
  ///                   alignment: Alignment.center,
  ///                   child: CircularProgressIndicator(valueColor:
  ///                             AlwaysStoppedAnimation(Colors.deepPurple)));
  ///             } else {
  ///               return SizedBox.fromSize(size: Size.zero);
  ///             }
  ///           },
  ///         );
  ///       },
  ///       columns: <GridColumn>[
  ///           GridColumn(columnName: 'id', label: Text('ID')),
  ///           GridColumn(columnName: 'name', label: Text('Name')),
  ///           GridColumn(columnName: 'designation', label: Text('Designation')),
  ///           GridColumn(columnName: 'salary', label: Text('Salary')),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// ## Load more button
  ///
  /// The example below demonstrates how to show the button when vertical
  /// scrolling is reached at the end of the datagrid and display the circular
  /// indicator when you tap that button. In the onPressed flatbutton callback,
  /// you can call the `loadMoreRows` function to add more rows.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(title: Text('Syncfusion Flutter DataGrid')),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       loadMoreViewBuilder:
  ///           (BuildContext context, LoadMoreRows loadMoreRows) {
  ///         bool showIndicator = false;
  ///         return StatefulBuilder(
  ///             builder: (BuildContext context, StateSetter setState) {
  ///           if (showIndicator) {
  ///             return Container(
  ///                 height: 98.0,
  ///                 color: Colors.white,
  ///                 width: double.infinity,
  ///                 alignment: Alignment.center,
  ///                 child: CircularProgressIndicator(valueColor:
  ///                           AlwaysStoppedAnimation(Colors.deepPurple)));
  ///           } else {
  ///             return Container(
  ///               height: 98.0,
  ///               color: Colors.white,
  ///               width: double.infinity,
  ///               alignment: Alignment.center,
  ///               child: Container(
  ///                 height: 36.0,
  ///                 width: 142.0,
  ///                 child: FlatButton(
  ///                   color: Colors.deepPurple,
  ///                   child: Text('LOAD MORE',
  ///                       style: TextStyle(color: Colors.white)),
  ///                   onPressed: () async {
  ///                     if (context is StatefulElement &&
  ///                         context.state != null &&
  ///                         context.state.mounted) {
  ///                       setState(() {
  ///                         showIndicator = true;
  ///                       });
  ///                     }
  ///                     await loadMoreRows();
  ///                     if (context is StatefulElement &&
  ///                         context.state != null &&
  ///                         context.state.mounted) {
  ///                       setState(() {
  ///                         showIndicator = false;
  ///                       });
  ///                     }
  ///                   },
  ///                 ),
  ///               ),
  ///             );
  ///           }
  ///         });
  ///       },
  ///       columns: <GridColumn>[
  ///           GridColumn(columnName: 'id', label: Text('ID')),
  ///           GridColumn(columnName: 'name', label: Text('Name')),
  ///           GridColumn(columnName: 'designation', label: Text('Designation')),
  ///           GridColumn(columnName: 'salary', label: Text('Salary')),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final LoadMoreViewBuilder? loadMoreViewBuilder;

  /// Decides whether refresh indicator should be shown when datagrid is pulled
  /// down.
  ///
  /// See also,
  ///
  /// [DataGridSource.handleRefresh] – This will be called when datagrid
  /// is pulled down to refresh the data.
  final bool allowPullToRefresh;

  /// The distance from the [SfDataGrid]’s top or bottom edge to where the refresh
  /// indicator will settle. During the drag that exposes the refresh indicator,
  /// its actual displacement may significantly exceed this value.
  ///
  /// By default, the value of `refreshIndicatorDisplacement` is 40.0.
  final double refreshIndicatorDisplacement;

  /// Defines `strokeWidth` for `RefreshIndicator` used by [SfDataGrid].
  ///
  /// By default, the value of `refreshIndicatorStrokeWidth` is 2.0 pixels.
  final double refreshIndicatorStrokeWidth;

  /// Decides whether to swipe a row “right to left” or “left to right” for custom
  /// actions such as deleting, editing, and so on. When the user swipes a row,
  /// the row will be moved, and swipe view will be shown for custom actions.
  ///
  /// You can show the widgets for left or right swipe view using
  /// [SfDataGrid.startSwipeActionsBuilder] and [SfDataGrid.endSwipeActionsBuilder].
  ///
  /// See also,
  ///
  /// [SfDataGrid.onSwipeStart]
  /// [SfDataGrid.onSwipeUpdate]
  /// [SfDataGrid.onSwipeEnd]
  final bool allowSwiping;

  /// Defines the maximum offset in which a row can be swiped.
  ///
  /// Defaults to 200.
  final double swipeMaxOffset;

  /// Controls a horizontal scrolling in DataGrid.
  ///
  /// You can use addListener method to listen whenever you do the horizontal scrolling.
  ///
  final ScrollController? horizontalScrollController;

  /// Controls a vertical scrolling in DataGrid.
  ///
  /// You can use addListener method to listen whenever you do the vertical scrolling.
  ///
  final ScrollController? verticalScrollController;

  /// Called when row swiping is started.
  ///
  /// You can disable the swiping for specific row by returning false.
  final DataGridSwipeStartCallback? onSwipeStart;

  /// Called when row is being swiped.
  ///
  /// You can disable the swiping for specific requirement on swiping itself by
  /// returning false.
  final DataGridSwipeUpdateCallback? onSwipeUpdate;

  /// Called when swiping of a row is ended (i.e. when reaches the max offset).
  final DataGridSwipeEndCallback? onSwipeEnd;

  /// A builder that sets the widget for the background view in which a row is
  /// swiped in the reading direction (e.g., from left to right in left-to-right
  /// languages).
  final DataGridSwipeActionsBuilder? startSwipeActionsBuilder;

  /// A builder that sets the widget for the background view in which a row is
  /// swiped in the reverse of reading direction (e.g., from right to left in
  /// left-to-right languages).
  final DataGridSwipeActionsBuilder? endSwipeActionsBuilder;

  /// Decides whether to highlight a row when mouse hovers over it.
  ///
  /// see also,
  /// [SfDataGridThemeData.rowHoverColor] – This helps you to change row highlighting color on hovering.
  /// [SfDataGridThemeData.rowHoverTextStyle] – This helps you to change the [TextStyle] of row on hovering.
  final bool highlightRowOnHover;

  /// Decides whether cell should be moved into edit mode based on
  /// [editingGestureType].
  ///
  /// Defaults to false.
  ///
  /// Editing can be enabled only if the [selectionMode] is other than none and
  /// [navigationMode] is cell.
  ///
  /// You can load the required widget on editing using [DataGridSource.buildEditWidget] method.
  ///
  /// The following example shows how to load the [TextField] for `id` column
  /// by overriding the `onCellSubmit` and `buildEditWidget` methods in
  /// [DataGridSource] class.
  ///
  /// ```dart
  ///
  /// class EmployeeDataSource extends DataGridSource {
  ///
  ///  TextEditingController editingController = TextEditingController();
  ///
  ///  dynamic newCellValue;
  ///
  ///  /// Creates the employee data source class with required details.
  ///   EmployeeDataSource({required List<Employee> employeeData}) {
  ///     employees = employeeData;
  ///     _employeeData = employeeData
  ///         .map<DataGridRow>((e) => DataGridRow(cells: [
  ///               DataGridCell<int>(columnName: 'id', value: e.id),
  ///               DataGridCell<String>(columnName: 'name', value: e.name),
  ///               DataGridCell<String>(
  ///                   columnName: 'designation', value: e.designation),
  ///               DataGridCell<int>(columnName: 'salary', value: e.salary),
  ///             ]))
  ///         .toList();
  ///   }
  ///
  ///   List<DataGridRow> _employeeData = [];
  ///
  ///   List<Employee> employees = [];
  ///
  ///   @override
  ///   List<DataGridRow> get rows => _employeeData;
  ///
  ///   @override
  ///   DataGridRowAdapter buildRow(DataGridRow row) {
  ///     return DataGridRowAdapter(
  ///         cells: row.getCells().map<Widget>((e) {
  ///       return Container(
  ///         alignment: (e.columnName == 'id' || e.columnName == 'salary')
  ///             ? Alignment.centerRight
  ///             : Alignment.centerLeft,
  ///         padding: EdgeInsets.all(8.0),
  ///         child: Text(e.value.toString()),
  ///       );
  ///     }).toList());
  ///   }
  ///
  ///   @override
  ///   Widget? buildEditWidget(DataGridRow dataGridRow,
  ///       RowColumnIndex rowColumnIndex, GridColumn column, submitCell) {
  ///     // To set the value for TextField when cell is moved into edit mode.
  ///     final String displayText = dataGridRow
  ///             .getCells()
  ///             .firstWhere((DataGridCell dataGridCell) =>
  ///                 dataGridCell.columnName == column.columnName)
  ///             .value
  ///             ?.toString() ??
  ///         '';
  ///
  ///     /// Returning the TextField with the numeric keyboard configuration.
  ///     if (column.columnName == 'id') {
  ///       return Container(
  ///           padding: const EdgeInsets.all(8.0),
  ///           alignment: Alignment.centerRight,
  ///           child: TextField(
  ///             autofocus: true,
  ///             controller: editingController..text = displayText,
  ///             textAlign: TextAlign.right,
  ///             decoration: const InputDecoration(
  ///                 contentPadding: EdgeInsets.all(0),
  ///                 border: InputBorder.none,
  ///                 isDense: true),
  ///             inputFormatters: [
  ///               FilteringTextInputFormatter.allow(RegExp('[0-9]'))
  ///             ],
  ///             keyboardType: TextInputType.number,
  ///             onChanged: (String value) {
  ///               if (value.isNotEmpty) {
  ///                 print(value);
  ///                 newCellValue = int.parse(value);
  ///               } else {
  ///                 newCellValue = null;
  ///               }
  ///             },
  ///             onSubmitted: (String value) {
  ///               /// Call [CellSubmit] callback to fire the canSubmitCell and
  ///               /// onCellSubmit to commit the new value in single place.
  ///               submitCell();
  ///             },
  ///           ));
  ///     }
  ///   }
  ///
  ///   @override
  ///   void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
  ///       GridColumn column) {
  ///     final dynamic oldValue = dataGridRow
  ///             .getCells()
  ///             .firstWhereOrNull((DataGridCell dataGridCell) =>
  ///                 dataGridCell.columnName == column.columnName)
  ///             ?.value ??
  ///         '';
  ///
  ///     final int dataRowIndex = rows.indexOf(dataGridRow);
  ///
  ///     if (newCellValue == null || oldValue == newCellValue) {
  ///       return;
  ///     }
  ///
  ///     if (column.columnName == 'id') {
  ///       rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
  ///           DataGridCell<int>(columnName: 'id', value: newCellValue);
  ///
  ///       // Save the new cell value to model collection also.
  ///       employees[dataRowIndex].id = newCellValue as int;
  ///     }
  ///
  ///     // To reset the new cell value after successfully updated to DataGridRow
  ///     //and underlying mode.
  ///     newCellValue = null;
  ///   }
  /// }
  ///
  /// ```
  /// The following example shows how to enable editing and set the
  /// [DataGridSource] for [SfDataGrid].
  /// ```dart
  ///
  /// List<Employee> employees = <Employee>[];
  ///
  /// late EmployeeDataSource employeeDataSource;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   employees = getEmployeeData();
  ///   employeeDataSource = EmployeeDataSource(employeeData: employees);
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Syncfusion Flutter DataGrid'),
  ///     ),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       allowEditing: true,
  ///       columnWidthMode: ColumnWidthMode.fill,
  ///       selectionMode: SelectionMode.single,
  ///       navigationMode: GridNavigationMode.cell,
  ///       columns: <GridColumn>[
  ///         GridColumn(
  ///             columnName: 'id',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(16.0),
  ///                 alignment: Alignment.centerRight,
  ///                 child: Text(
  ///                   'ID',
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'name',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.centerLeft,
  ///                 child: Text('Name'))),
  ///         GridColumn(
  ///             columnName: 'designation',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.centerLeft,
  ///                 child: Text(
  ///                   'Designation',
  ///                   overflow: TextOverflow.ellipsis,
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'salary',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.centerRight,
  ///                 child: Text('Salary'))),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  /// See also,
  /// * [GridColumn.allowEditing] – You can enable or disable editing for an
  /// individual column.
  /// * [DataGridSource.onCellBeginEdit]- This will be triggered when a cell is
  /// moved to edit mode.
  /// * [DataGridSource.canSubmitCell]- This will be triggered before
  /// [DataGridSource.onCellSubmit] method is called. You can use this method
  /// if you want to not end the editing based on any criteria.
  /// * [DataGridSource.onCellSubmit] – This will be triggered when the cell’s
  /// editing is completed.
  final bool allowEditing;

  /// Decides whether the editing should be triggered on tap or double tap
  /// the cells.
  ///
  /// Defaults to [EditingGestureType.doubleTap].
  ///
  /// See also,
  /// * [allowEditing] – This will enable the editing option for cells.
  final EditingGestureType editingGestureType;

  /// The widget to show over the bottom of the [SfDataGrid].
  ///
  /// This footer will be displayed like normal row and shown below to last row.
  ///
  /// See also,
  ///
  /// [SfDataGrid.footerHeight] – This enables you to change the height of the
  /// footer.
  final Widget? footer;

  /// The height of the footer.
  ///
  /// Defaults to 49.0.
  final double footerHeight;

  const GridTableParams(
      {this.rowHeight = double.nan,
      this.headerRowHeight = double.nan,
      this.defaultColumnWidth = double.nan,
      this.gridLinesVisibility = GridLinesVisibility.horizontal,
      this.headerGridLinesVisibility = GridLinesVisibility.horizontal,
      this.columnWidthMode = ColumnWidthMode.none,
      this.columnSizer,
      this.columnWidthCalculationRange =
          ColumnWidthCalculationRange.visibleRows,
      this.selectionMode = SelectionMode.none,
      this.navigationMode = GridNavigationMode.row,
      this.frozenColumnsCount = 0,
      this.footerFrozenColumnsCount = 0,
      this.frozenRowsCount = 0,
      this.footerFrozenRowsCount = 0,
      this.allowSorting = false,
      this.allowMultiColumnSorting = false,
      this.allowTriStateSorting = false,
      this.showSortNumbers = false,
      this.sortingGestureType = SortingGestureType.tap,
      this.stackedHeaderRows = const <StackedHeaderRow>[],
      this.selectionManager,
      this.controller,
      this.onQueryRowHeight,
      this.onSelectionChanged,
      this.onSelectionChanging,
      this.onCellRenderersCreated,
      this.onCurrentCellActivating,
      this.onCurrentCellActivated,
      this.onCellTap,
      this.onCellDoubleTap,
      this.onCellSecondaryTap,
      this.onCellLongPress,
      this.isScrollbarAlwaysShown = false,
      this.horizontalScrollPhysics = const AlwaysScrollableScrollPhysics(),
      this.verticalScrollPhysics = const AlwaysScrollableScrollPhysics(),
      this.loadMoreViewBuilder,
      this.allowPullToRefresh = false,
      this.refreshIndicatorDisplacement = 40.0,
      this.refreshIndicatorStrokeWidth = 2.0,
      this.allowSwiping = false,
      this.swipeMaxOffset = 200.0,
      this.horizontalScrollController,
      this.verticalScrollController,
      this.onSwipeStart,
      this.onSwipeUpdate,
      this.onSwipeEnd,
      this.startSwipeActionsBuilder,
      this.endSwipeActionsBuilder,
      this.highlightRowOnHover = true,
      this.allowEditing = false,
      this.editingGestureType = EditingGestureType.doubleTap,
      this.footer,
      this.footerHeight = 0.0})
      : assert(frozenColumnsCount >= 0),
        assert(footerFrozenColumnsCount >= 0),
        assert(frozenRowsCount >= 0),
        assert(footerFrozenRowsCount >= 0);
}
