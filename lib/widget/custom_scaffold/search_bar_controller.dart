import 'package:flutter/material.dart';

/// jacokwu
/// 9/1/21 10:03 AM

class SearchBarController extends ChangeNotifier {
  SearchBarController({String? text, Duration? duration})
      : focusNode = FocusNode(),
        editingController = TextEditingController(text: text),
        _value = text,
        duration = duration ?? Duration(milliseconds: 1000);

  FocusNode focusNode;

  TextEditingController editingController;

  String? _value;

  bool _isNotify = false;

  Duration duration;

  void init() {
    if (!focusNode.hasListeners) focusNode.addListener(_notify);
    if (!editingController.hasListeners) editingController.addListener(_editNotify);
  }

  void _notify() {
    notifyListeners();
  }

  void _editNotify() async {
    if (_value != editingController.text && !_isNotify) {
      _isNotify = true;
      _value = editingController.text;
      await Future.delayed(duration);
      notifyListeners();
      _isNotify = false;
    }
  }

  /// 获取焦点
  void focus(context) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// 失去焦点
  void unFocus() {
    focusNode.unfocus();
  }

  /// 输入框是否有焦点
  bool get isFocus => focusNode.hasFocus;

  /// 是否有值
  bool get hasValue => editingController.text.isNotEmpty;

  /// 输入框的值
  String get value => editingController.text;
  set value(String value) => editingController.text = value;

  @override
  void dispose() {
    super.dispose();
    focusNode
      ..removeListener(_notify)
      ..dispose();
    editingController
      ..removeListener(_editNotify)
      ..dispose();
  }
}
