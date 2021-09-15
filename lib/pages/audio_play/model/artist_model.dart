/// jacokwu
/// 8/25/21 3:43 PM

/// 歌手
class ArtistModel {
  late int recommendSort;
  late int type;
  late int baseId;
  late String birthday;
  late List<String> pictorialList;
  late String gender;
  late String introduce;
  late int weight;
  late String pic;
  late String blood;
  late String artistCode;
  late String birthPlace;
  late String name;
  late String region;
  late int height;
  late int albumTotal;
  late int trackTotal;
  late int isFavorite;
  late int favoriteCount;

  ArtistModel(
      {required this.recommendSort,
      required this.type,
      required this.baseId,
      required this.birthday,
      required this.pictorialList,
      required this.gender,
      required this.introduce,
      required this.weight,
      required this.pic,
      required this.blood,
      required this.artistCode,
      required this.birthPlace,
      required this.name,
      required this.region,
      required this.height,
      required this.albumTotal,
      required this.trackTotal,
      required this.isFavorite,
      required this.favoriteCount});

  ArtistModel.fromJson(Map<String, dynamic> json) {
    recommendSort = json['recommendSort'];
    type = json['type'];
    baseId = json['baseId'];
    birthday = json['birthday'];
    pictorialList = json['pictorialList'].cast<String>();
    gender = json['gender'];
    introduce = json['introduce'];
    weight = json['weight'];
    pic = json['pic'];
    blood = json['blood'];
    artistCode = json['artistCode'];
    birthPlace = json['birthPlace'];
    name = json['name'];
    region = json['region'];
    height = json['height'];
    albumTotal = json['albumTotal'];
    trackTotal = json['trackTotal'];
    isFavorite = json['isFavorite'];
    favoriteCount = json['favoriteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommendSort'] = this.recommendSort;
    data['type'] = this.type;
    data['baseId'] = this.baseId;
    data['birthday'] = this.birthday;
    data['pictorialList'] = this.pictorialList;
    data['gender'] = this.gender;
    data['introduce'] = this.introduce;
    data['weight'] = this.weight;
    data['pic'] = this.pic;
    data['blood'] = this.blood;
    data['artistCode'] = this.artistCode;
    data['birthPlace'] = this.birthPlace;
    data['name'] = this.name;
    data['region'] = this.region;
    data['height'] = this.height;
    data['albumTotal'] = this.albumTotal;
    data['trackTotal'] = this.trackTotal;
    data['isFavorite'] = this.isFavorite;
    data['favoriteCount'] = this.favoriteCount;
    return data;
  }
}
