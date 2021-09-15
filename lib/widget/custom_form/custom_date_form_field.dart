import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/custom_form/sf_date_picker_panel.dart';
import 'package:flutter_utils/widget/custom_form/title_content_widget.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// jacokwu
/// 8/20/21 2:37 PM

/// 日期选择
/// 当 [selectionMode == DateRangePickerSelectionMode.single] 时，值类型为 [String]，只有一个id;
/// 当 [selectionMode == DateRangePickerSelectionMode.multiple] 时，值类型为 [List<String>]，只有一个id;
/// 当 [selectionMode == DateRangePickerSelectionMode.range || selectionMode == DateRangePickerSelectionMode.extendableRange] 时，
/// 值类型为 [String]，有两个id;
/// 当 [selectionMode == DateRangePickerSelectionMode.multiRange] 时，值类型为 [List<List<String>>]，只有一个id
class CustomDateFormField extends StatefulWidget {
  /// 是否必输
  final bool required;

  /// 是否只读
  final bool readOnly;

  /// 值集合
  final Map model;

  /// id
  final String id;

  /// 如果是单个范围选择，则需要此id
  final String? endId;

  /// 显示title
  final String label;

  /// 提示
  final String placeholder;

  /// 整体padding
  final EdgeInsets padding;

  /// 整体背景色
  final Color? backgroundColor;

  /// 整体容器样式
  final Decoration? decoration;

  /// 日期选择类型
  final DateRangePickerSelectionMode selectionMode;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 确认回调
  final void Function(Object)? onSubmit;

  /// 链接符
  final String joinCode;

  /// 右侧图标
  final IconData? icons;

  /// 是否允许点击，点击前调用
  final Future<bool> Function()? canTap;

  const CustomDateFormField({
    Key? key,
    this.required = false,
    this.readOnly = false,
    required this.model,
    required this.id,
    required this.label,
    this.placeholder = '请选择日期',
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.decoration,
    this.selectionMode = DateRangePickerSelectionMode.single,
    this.endId,
    this.onCancel,
    this.onSubmit,
    this.joinCode = '-',
    this.icons = Icons.date_range,
    this.canTap,
  }) : super(key: key);

  @override
  _CustomDateFormFieldState createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  @override
  Widget build(BuildContext context) {
    return TitleContentWidget(
      model: widget.model,
      id: widget.id,
      endId: widget.endId,
      joinCode: widget.joinCode,
      label: widget.label,
      required: widget.required,
      readOnly: widget.readOnly,
      placeholder: widget.placeholder,
      backgroundColor: widget.backgroundColor,
      padding: widget.padding,
      decoration: widget.decoration,
      icons: widget.icons,
      onTap: () async {
        if (widget.canTap != null &&  !(await widget.canTap!())) return;
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            builder: (_) {
              return Container(
                decoration: BoxDecoration(
                  color: Constants.backgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                ),
                height: 360,
                padding: EdgeInsets.only(
                    left: Dimens.pd12, right: Dimens.pd12, bottom: MediaQuery.of(context).padding.bottom),
                child: SfDatePickerPanel(
                  selectionMode: widget.selectionMode,
                  initialSelectedDate: _initialSelectedDate,
                  initialSelectedDates: _initialSelectedDates,
                  initialSelectedRange: _initialSelectedRange,
                  initialSelectedRanges: _initialSelectedRanges,
                  onCancel: () {
                    Get.back();
                    if (widget.onCancel != null) widget.onCancel!();
                  },
                  onSubmit: (value) {
                    if (value is DateTime || value is List<DateTime>) {
                      widget.model[widget.id] = value.toString().substring(0, 11);
                    } else if (value is PickerDateRange) {
                      widget.model[widget.id] = value.startDate.toString().substring(0, 11);
                      widget.model[widget.endId] = value.endDate.toString().substring(0, 11);
                    } else if (value is List<PickerDateRange>) {
                      widget.model[widget.id] = value
                          .map<List<String>>(
                              (e) => [e.startDate.toString().substring(0, 11), e.endDate.toString().substring(0, 11)])
                          .toList();
                    }
                    setState(() {});
                    Get.back();
                    if (widget.onSubmit != null) widget.onSubmit!(value);
                  },
                ),
              );
            });
      },
    );
  }

  DateTime? get _initialSelectedDate => widget.selectionMode == DateRangePickerSelectionMode.single
      ? (widget.model[widget.id] == null ? DateTime.now() : DateTime.tryParse(widget.model[widget.id] ?? ''))
      : null;

  List<DateTime>? get _initialSelectedDates => widget.selectionMode == DateRangePickerSelectionMode.multiple
      ? (widget.model[widget.id] == null
          ? [DateTime.now()]
          : widget.model[widget.id].map<DateTime>((e) => DateTime.tryParse(e)).toList())
      : null;

  PickerDateRange? get _initialSelectedRange =>
      [DateRangePickerSelectionMode.range, DateRangePickerSelectionMode.extendableRange].contains(widget.selectionMode)
          ? PickerDateRange(
              DateTime.tryParse(widget.model[widget.id] ?? ''), DateTime.tryParse(widget.model[widget.endId] ?? ''))
          : null;

  List<PickerDateRange>? get _initialSelectedRanges => DateRangePickerSelectionMode.multiRange == widget.selectionMode
      ? widget.model[widget.id]
          .map<PickerDateRange>((e) => PickerDateRange(DateTime.tryParse(e[0]), DateTime.tryParse(e[0])))
          .toList()
      : null;
}
