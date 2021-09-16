import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_divider.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 9/16/21 10:58 AM

/// 提示框
Future<T?> showSimpleAlertDialog<T>(
  BuildContext context, {
  String title = '提示',
  required String content,
  bool showCancel = false,
  String cancelText = '取消',
  Color cancelTextColor = Constants.gray_9,
  void Function()? cancelFunc,
  bool showConfirm = true,
  String confirmText = '确定',
  Color confirmTextColor = Colors.black,
  void Function()? confirmFunc,
  List<Widget>? expandActions,
  bool autoDismiss = true,
  bool disabledBack = false,
}) async {
  return await showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            return Future.value(!disabledBack);
          },
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if (expandActions != null) ...expandActions,
              if (showCancel)
                TextButton(
                    onPressed: () {
                      Get.back();
                      if (cancelFunc != null) cancelFunc();
                    },
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        color: cancelTextColor,
                      ),
                    )),
              if (showConfirm)
                TextButton(
                    onPressed: () {
                      if (autoDismiss) Get.back();
                      if (confirmFunc != null) confirmFunc();
                    },
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        color: confirmTextColor,
                      ),
                    )),
            ],
          ),
        );
      });
}

/// 底部列表
showBottomMenuDialog(BuildContext context, List menuList, void Function(int, String) onTapMenu) {
  showModalBottomSheet(
      context: context,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return Container(
          height: 46 * (menuList.length + 1) + 3 + 4 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(top: 0, bottom: MediaQuery.of(context).padding.bottom),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Constants.backgroundColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                removeTop: true,
                child: ListView.separated(
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      Get.back();
                      onTapMenu(index, menuList[index]['key']);
                    },
                    child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: Dimens.pd12),
                        child: Center(
                            child: Text(
                          menuList[index]['title'],
                          style: TextStyle(
                              color: Colors.black, fontSize: Dimens.font_size_16, fontWeight: FontWeight.w300),
                        ))),
                  ),
                  separatorBuilder: (_, index) => CustomDivider(),
                  itemCount: menuList.length,
                  shrinkWrap: true,
                ),
              ),
              Dimens.hGap4,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: Dimens.pd12),
                    child: Center(
                        child: Text(
                      '取消',
                      style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_16, fontWeight: FontWeight.w300),
                    ))),
              ),
            ],
          ),
        );
      });
}

/// 底部输入框
showBottomInputDialog(
  BuildContext context, {
  required String title,
  String? initialValue,
  bool readOnly = false,

  /// 是否是数字
  bool isNum = false,

  /// 是否是手机号
  bool isPhone = false,

  /// 是否是整数
  bool isPositiveInteger = false,

  /// 最大值，只在 [isNum == true] 或 [isPositiveInteger == true] 时生效
  String? maxNum,

  /// 最小值，只在 [isNum == true] 或 [isPositiveInteger == true] 时生效
  String? minNum,

  /// 值改变的回调
  void Function(String value)? onChanged,
  void Function(String value)? onConfirm,

  /// 提示
  String? placeholder,

  /// 校验规则
  List<TextInputFormatter>? inputFormatters,
  TextEditingController? controller,
}) {
  TextEditingController _controller = controller == null
      ? (TextEditingController()..text = initialValue ?? '')
      : (controller..text = initialValue ?? '');
  showDialog(
      context: context,
      builder: (_) => _BottomInputDialogContainer(
            title: title,
            controller: _controller,
            readOnly: readOnly,
            isNum: isNum,
            isPositiveInteger: isPositiveInteger,
            isPhone: isPhone,
            minNum: minNum,
            maxNum: maxNum,
            onChanged: onChanged,
            onConfirm: onConfirm,
            placeholder: placeholder,
            inputFormatters: inputFormatters,
          ));
}

class _BottomInputDialogContainer extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool readOnly;

  /// 是否是数字
  final bool isNum;

  /// 是否是手机号
  final bool isPhone;

  /// 是否是整数
  final bool isPositiveInteger;

  /// 最大值，只在 [isNum == true] 或 [isPositiveInteger == true] 时生效
  final String? maxNum;

  /// 最小值，只在 [isNum == true] 或 [isPositiveInteger == true] 时生效
  final String? minNum;

  /// 值改变的回调
  final void Function(String value)? onChanged;

  final void Function(String value)? onConfirm;

  /// 提示
  final String? placeholder;

  /// 校验规则
  final List<TextInputFormatter>? inputFormatters;

  const _BottomInputDialogContainer(
      {Key? key,
      required this.title,
      required this.controller,
      this.readOnly = false,
      this.isNum = false,
      this.isPhone = false,
      this.isPositiveInteger = false,
      this.maxNum,
      this.minNum,
      this.onChanged,
      this.placeholder,
      this.inputFormatters,
      this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: Container(
            padding: EdgeInsets.only(bottom: Dimens.pd16),
            margin: EdgeInsets.only(
                left: Dimens.pd16, right: Dimens.pd16, bottom: MediaQuery.of(context).padding.bottom + Dimens.pd16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Dimens.pd16, top: Dimens.pd16, bottom: Dimens.pd25),
                  child: Material(
                    child: CustomText(
                      title,
                      fontSize: Dimens.font_size_18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.left,
                      readOnly: readOnly,
                      autofocus: true,
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
                        if (onChanged != null) onChanged!(controller.text);
                      },
                      style: TextStyle(color: Constants.contentColor, fontSize: Dimens.font_size_16),
                      decoration: new InputDecoration(
                        hintText: readOnly ? null : placeholder,
                        border: UnderlineInputBorder(),
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
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(100),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('取消'))),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimens.pd12),
                        child: CustomDivider(
                          type: DividerType.vertical,
                        ),
                      ),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                if (onConfirm != null) onConfirm!(controller.text);
                              },
                              child: Text('确定'))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
