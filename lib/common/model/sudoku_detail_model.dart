import 'package:flutter_utils/common/constants.dart';

/// jacokwu
/// 8/5/21 2:36 PM

class SudokuDetailModel {
  /// 是否高亮
  late bool isHighlight;

  /// 值
  late int value;

  /// 是否初始值
  late bool isInitial;

  /// 是否被选中
  late bool isSelected;

  /// 坐标
  late List<int> rc;

  /// 正确答案
  late int answer;

  /// 是否是标记状态
  late bool isMarkStatus;

  /// 标记值
  late List<int> markList;

  SudokuDetailModel({
    this.isHighlight = false,
    required this.value,
    required this.isInitial,
    required this.rc,
    this.isSelected = false,
    required this.answer,
    this.isMarkStatus = false,
    this.markList = Constants.defaultIntList
  });

  SudokuDetailModel.fromJson(Map<String, dynamic> json) {
    assert(json['value'] != null);
    assert(json['isInitial'] != null);
    assert(json['isHighlight'] != null);
    assert(json['rc'] != null);
    assert(json['answer'] != null);
    assert(json['isMarkStatus'] != null);
    isHighlight = json['isHighlight'];
    value = json['value'];
    isInitial = json['isInitial'];
    isSelected = json['isSelected'];
    answer = json['answer'];
    isMarkStatus = json['isMarkStatus'];
    markList = json['markList'].cast<int>();
    rc = json['rc'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isHighlight'] = this.isHighlight;
    data['value'] = this.value;
    data['isInitial'] = this.isInitial;
    data['rc'] = this.rc;
    data['isSelected'] = this.isSelected;
    data['answer'] = this.answer;
    data['isMarkStatus'] = this.isMarkStatus;
    data['markList'] = this.markList;
    return data;
  }
}
