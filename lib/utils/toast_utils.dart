import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';

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
