import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// jacokwu
/// 8/20/21 2:16 PM

class SfDatePickerPanel extends StatelessWidget {
  final DateRangePickerSelectionMode selectionMode;
  final bool showActionButtons;
  final VoidCallback? onCancel;
  final Function(Object)? onSubmit;
  final DateTime? initialSelectedDate;
  final List<DateTime>? initialSelectedDates;
  final PickerDateRange? initialSelectedRange;
  final List<PickerDateRange>? initialSelectedRanges;

  const SfDatePickerPanel(
      {Key? key,
      this.selectionMode = DateRangePickerSelectionMode.multiple,
      this.showActionButtons = true,
      this.onCancel,
      this.onSubmit,
      this.initialSelectedDate,
      this.initialSelectedDates,
      this.initialSelectedRange,
      this.initialSelectedRanges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      selectionMode: selectionMode,
      view: DateRangePickerView.month,
      todayHighlightColor: Theme.of(context).primaryColor,
      enableMultiView: _enableMultiView,
      showActionButtons: showActionButtons,
      selectionColor: Theme.of(context).primaryColor,
      rangeSelectionColor: Theme.of(context).primaryColor.withAlpha(50),
      startRangeSelectionColor: Theme.of(context).primaryColor,
      endRangeSelectionColor: Theme.of(context).primaryColor,
      monthCellStyle: DateRangePickerMonthCellStyle(todayTextStyle: TextStyle(color: Theme.of(context).primaryColor)),
      yearCellStyle: DateRangePickerYearCellStyle(todayTextStyle: TextStyle(color: Theme.of(context).primaryColor)),
      initialSelectedDate: initialSelectedDate,
      initialSelectedDates: initialSelectedDates,
      initialSelectedRange: initialSelectedRange,
      initialSelectedRanges: initialSelectedRanges,
      confirmText: '确定',
      cancelText: '取消',
      onCancel: onCancel,
      onSubmit: onSubmit,
    );
  }

  bool get _enableMultiView => [
        DateRangePickerSelectionMode.range,
        DateRangePickerSelectionMode.extendableRange,
        DateRangePickerSelectionMode.multiRange
      ].contains(selectionMode);
}
