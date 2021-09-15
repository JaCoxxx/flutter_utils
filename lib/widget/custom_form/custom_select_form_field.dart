import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/custom_form/title_content_widget.dart';

import 'multi_select/custom_multi_select_bottom_sheet.dart';
import 'multi_select/multi_select_item.dart';

/// jacokwu
/// 8/23/21 11:01 AM

class CustomSelectFormField extends StatefulWidget {
  /// 是否必输
  final bool required;

  /// 是否只读
  final bool readOnly;

  /// 值集合
  final Map model;

  /// id
  final String id;

  /// 显示title
  final String label;

  /// 提示
  final String? placeholder;

  /// 整体padding
  final EdgeInsets padding;

  /// 整体背景色
  final Color? backgroundColor;

  /// 整体容器样式
  final Decoration? decoration;

  /// 容器高度
  final double height;

  /// 选择项
  final List<MultiSelectItem> options;

  /// 下拉刷新接口
  final Future<List<MultiSelectItem>> Function(String? keywords)? onRefresh;

  /// 上拉加载接口
  final Future<List<MultiSelectItem>> Function(String? keywords)? onLoad;

  /// 是否单选
  final bool isSingle;

  /// 是否需要搜索
  final bool searchable;

  /// 搜索提示
  final String? searchHint;

  /// 是否使用本地搜索方法
  final bool localSearch;

  /// 是否是modal
  final bool isModal;

  /// 右侧图标
  final IconData? icons;

  /// 是否允许点击,点击前调用
  final Future<bool> Function()? canTap;

  const CustomSelectFormField({
    Key? key,
    this.required = false,
    this.readOnly = false,
    required this.model,
    required this.id,
    required this.label,
    this.placeholder,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.decoration,
    this.height = Dimens.itemHeight,
    required this.options,
    this.onRefresh,
    this.onLoad,
    this.isSingle = false,
    this.searchable = false,
    this.searchHint,
    this.localSearch = true,
    this.isModal = true,
    this.icons = Icons.keyboard_arrow_right,
    this.canTap,
  }) : super(key: key);

  @override
  _CustomSelectFormFieldState createState() => _CustomSelectFormFieldState();
}

class _CustomSelectFormFieldState extends State<CustomSelectFormField> {
  @override
  Widget build(BuildContext context) {
    return TitleContentWidget(
      model: widget.model,
      id: widget.id,
      label: widget.label,
      readOnly: widget.readOnly,
      required: widget.required,
      placeholder: widget.placeholder ?? '请选择${widget.label}',
      padding: widget.padding,
      backgroundColor: widget.backgroundColor,
      decoration: widget.decoration,
      height: widget.height,
      icons: widget.icons,
      onTap: () async {
        if (widget.canTap != null &&  !(await widget.canTap!())) return;
        !widget.isModal ? showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          builder: (_) {
            return _buildSelectContainer();
          },
        ) : showDialog(
          context: context,
          builder: (_) => Container(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 40),
            child: Material(child: _buildSelectContainer()),
          ),
        );
      },
    );
  }

  Widget _buildSelectContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Constants.backgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: MultiSelectBottomSheet(
        items: widget.options,
        initialValue: widget.model[widget.id] ?? [],
        searchable: widget.searchable,
        isSingle: widget.isSingle,
        onRefresh: widget.onRefresh,
        onLoad: widget.onLoad,
        localSearch: widget.localSearch,
        searchHint: widget.searchHint,
        onConfirm: (value) {
          widget.model[widget.id] = value;
          setState(() {});
        },
      ),
    );
  }
}
