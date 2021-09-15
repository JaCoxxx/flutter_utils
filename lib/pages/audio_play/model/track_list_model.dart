/// jacokwu
/// 8/25/21 3:26 PM

/// 歌单model
class TrackListModel {
  /// 推荐排序
  int? recommendSort;
  int? type;
  int? baseId;
  /// 标签
  late List<String?> tagList;
  /// 封面
  late String pic;
  late int id;
  late List<String?> cateList;
  /// 标题
  late String title;
  late List<String?> menu;
  late String addDate;
  /// 简介
  late String desc;
  late int resourceType;
  double? dScore;
  /// 音乐数量
  late int trackCount;
  /// 是否喜欢
  late int isFavorite;

  TrackListModel(
      {this.recommendSort,
        this.type,
        this.baseId,
        required this.tagList,
        required this.pic,
        required this.id,
        required this.cateList,
        required this.title,
        required this.menu,
        required this.addDate,
        required this.desc,
        required this.resourceType,
        this.dScore,
        required this.trackCount,
        required this.isFavorite});

  TrackListModel.fromJson(Map<String, dynamic> json) {
    recommendSort = json['recommendSort'];
    type = json['type'];
    baseId = json['baseId'];
    tagList = json['tagList'].cast<String>();
    pic = json['pic'];
    id = json['id'];
    cateList = json['cateList'].cast<String>();
    title = json['title'];
    menu = json['menu'].cast<String>();
    addDate = json['addDate'];
    desc = json['desc'];
    resourceType = json['resourceType'];
    dScore = json['_score'];
    trackCount = json['trackCount'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommendSort'] = this.recommendSort;
    data['type'] = this.type;
    data['baseId'] = this.baseId;
    data['tagList'] = this.tagList;
    data['pic'] = this.pic;
    data['id'] = this.id;
    data['cateList'] = this.cateList;
    data['title'] = this.title;
    data['menu'] = this.menu;
    data['addDate'] = this.addDate;
    data['desc'] = this.desc;
    data['resourceType'] = this.resourceType;
    data['_score'] = this.dScore;
    data['trackCount'] = this.trackCount;
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}
