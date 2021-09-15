import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/widgets.dart';

/// jacokwu
/// 8/20/21 10:57 AM

class CustomTextFormField extends StatelessWidget {
  /// 控制器
  final TextEditingController controller;

  /// 是否是数字
  final bool isNum;

  /// 是否是手机号
  final bool isPhone;

  /// 是否是整数
  final bool isPositiveInteger;

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

  /// 最大值，只在 [isNum == true] 或 [isPositiveInteger == true] 时生效
  final String? maxNum;

  /// 最小值，只在 [isNum == true] 或 [isPositiveInteger == true] 时生效
  final String? minNum;

  /// 值改变的回调
  final void Function(String value)? onChanged;

  /// 提示
  final String? placeholder;

  /// 校验规则
  final List<TextInputFormatter>? inputFormatters;

  /// 整体padding
  final EdgeInsets? padding;

  /// 整体背景色
  final Color? backgroundColor;

  /// 整体容器样式
  final Decoration? decoration;

  /// 容器高度
  final double? height;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.isNum = false,
    this.isPhone = false,
    this.isPositiveInteger = false,
    this.required = false,
    this.readOnly = false,
    required this.model,
    required this.id,
    required this.label,
    this.maxNum,
    this.minNum,
    this.onChanged,
    this.placeholder,
    this.inputFormatters,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.decoration,
    this.height = Dimens.itemHeight,
  })  : assert(decoration == null || backgroundColor == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: TextField(
              focusNode: FocusNode(),
              controller: controller,
              textAlign: TextAlign.right,
              readOnly: readOnly,
              keyboardType: isNum || isPositiveInteger
                  ? TextInputType.number
                  : isPhone
                      ? TextInputType.phone
                      : TextInputType.text,
              onChanged: (value) {
                if (!isStringEmpty(maxNum) && (isNum || isPositiveInteger)) {
                  if (int.parse(controller.text) > int.parse(maxNum!)) {
                    controller.text = maxNum!;
                  }
                }
                if (!isStringEmpty(minNum) && (isNum || isPositiveInteger)) {
                  if (int.parse(controller.text) < int.parse(minNum!)) {
                    controller.text = minNum!;
                  }
                }
                model[id] = controller.text;
                if (onChanged != null) onChanged!(controller.text);
              },
              style: TextStyle(color: Constants.contentColor, fontSize: Dimens.font_size_16),
              decoration: new InputDecoration(
                hintText: readOnly ? null : placeholder ?? '请输入$label',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Constants.gray_c, fontSize: Dimens.font_size_16),
              ),
              inputFormatters: [
                if (inputFormatters != null) ...inputFormatters!,
                if (isNum) FilteringTextInputFormatter.allow(RegExp('^0\$|^[1-9][0-9]*')),
                if (isPhone) FilteringTextInputFormatter.allow(RegExp('^[1-9][0-9]*')),
                if (isPositiveInteger) FilteringTextInputFormatter.allow(RegExp('^[1-9][0-9]*')),
              ],
            ),
          ),
          Dimens.wGap22,
          Dimens.wGap10,
        ],
      ),
    );
  }
}
