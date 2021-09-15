/// jacokwu
/// 9/4/21 10:15 AM

class LyricItemModel {
  Duration? startTime;
  Duration? endTime;
  late String lyric;
  double? offset;

  LyricItemModel({this.startTime, this.endTime, required this.lyric, this.offset = 0});

  LyricItemModel.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    lyric = json['lyric'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['lyric'] = this.lyric;
    return data;
  }
}
