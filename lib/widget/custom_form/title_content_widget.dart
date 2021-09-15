import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';

import '../widgets.dart';

/// jacokwu
/// 8/20/21 2:41 PM

class TitleContentWidget extends StatelessWidget {
  /// 是否必输
  final bool required;

  /// 是否只读
  final bool readOnly;

  /// 值集合
  final Map model;

  /// id
  final String id;

  /// 组合值id
  final String? endId;

  /// 拼接值的符号
  final String joinCode;

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

  /// 容器高度
  final double height;

  final VoidCallback? onTap;

  final IconData? icons;

  const TitleContentWidget({
    Key? key,
    this.required = false,
    this.readOnly = false,
    required this.model,
    required this.id,
    this.endId,
    required this.label,
    this.joinCode = ',',
    this.placeholder = '请选择',
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.decoration,
    this.height = Dimens.itemHeight,
    this.onTap,
    this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(model[id] == null);
    return GestureDetector(
      onTap: readOnly ? null : onTap,
      child: Container(
        padding: padding,
        color: backgroundColor,
        decoration: decoration,
        height: height,
        child: Row(
          children: [
            Dimens.wGap10,
            Text(
              label,
              textAlign: TextAlign.left,
              style: TextStyle(color: Constants.black_3, fontSize: Dimens.font_size_16),
            ),
            if (required) requiredText(),
            Dimens.wGap10,
            Expanded(
              child: _buildValue(),
            ),
            Dimens.wGap4,
            Icon(icons ?? Icons.keyboard_arrow_right, color: Constants.gray_8e, size: Dimens.font_size_18,),
            Dimens.wGap10,
          ],
        ),
      ),
    );
  }

  Widget _buildValue() {
    if (endId != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              model[id] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimens.font_size_16, color: valueColor),
            ),
          ),
          Dimens.wGap10,
          Text(
            joinCode,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: Dimens.font_size_16, color: valueColor),
          ),
          Dimens.wGap10,
          Expanded(
            child: Text(
              model[endId] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimens.font_size_16, color: valueColor),
            ),
          )
        ],
      );
    } else {
      return Text(
        value,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: Dimens.font_size_16, color: valueColor),
      );
    }
}

  String get value {
    dynamic _value = model[id];
    if (_value == null)
      return readOnly ? '' : placeholder;
    else if (_value is List)
      return _value.join(joinCode);
    return _value;
  }

  Color get valueColor => model[id] == null ? Constants.gray_c : Constants.contentColor;
}
