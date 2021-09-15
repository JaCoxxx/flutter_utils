import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/custom_divider.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// 显示loading
void showLoading({String? msg, Color msgColor = Colors.white}) {
  BotToast.showCustomLoading(
      toastBuilder: (_) => Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                if (msg != null) Dimens.hGap10,
                if (msg != null)
                  Text(
                    msg,
                    style: TextStyle(fontSize: Dimens.font_size_16, color: msgColor),
                  ),
              ],
            ),
          ));
}

/// 显示toast
void showToast(String text, {bool isLong = false, bool clickClose = false, bool onlyOne = false}) {
  BotToast.showText(
    text: text,
    duration: isLong ? Duration(milliseconds: 4000) : Duration(milliseconds: 2000),
    clickClose: clickClose,
    onlyOne: onlyOne,
  );
}

/// 清除loading
void dismissLoading() {
  BotToast.cleanAll();
}

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
