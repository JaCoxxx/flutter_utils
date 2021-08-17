/// jacokwu
/// 8/9/21 5:57 PM

class MSDetailModel {
  /// 是否是雷
  late bool isMine;
  /// 是否标记
  late bool isMark;
  /// 是否已点击
  late bool isTap;
  /// 坐标
  late List<int> xy;
  /// 周围雷的个数
  late int mineNum;

  MSDetailModel({this.isMine = false, this.isMark = false, this.isTap = false, required this.xy, this.mineNum = 0});

  MSDetailModel.fromJson(Map<String, dynamic> json) {
    isMine = json['isMine'];
    isMark = json['isMark'];
    isTap = json['isTap'];
    xy = json['xy'].cast<int>();
    mineNum = json['mineNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isMine'] = this.isMine;
    data['isMark'] = this.isMark;
    data['isTap'] = this.isTap;
    data['xy'] = this.xy;
    data['mineNum'] = this.mineNum;
    return data;
  }
}
