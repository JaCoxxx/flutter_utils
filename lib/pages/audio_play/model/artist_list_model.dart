import 'package:azlistview/azlistview.dart';

/// jacokwu
/// 8/26/21 10:52 AM

class ArtistListModel extends ISuspensionBean {
  late String artistCode;
  late String name;
  late String pic;
  late int isFavorite;
  late String firstletter;
  late int favoriteCount;

  ArtistListModel(
      {required this.artistCode,
      required this.name,
      required this.pic,
      required this.isFavorite,
      required this.firstletter,
      required this.favoriteCount});

  ArtistListModel.fromJson(Map<String, dynamic> json) {
    artistCode = json['artistCode'];
    name = json['name'];
    pic = json['pic'];
    isFavorite = json['isFavorite'];
    firstletter = json['firstletter'];
    favoriteCount = json['favoriteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artistCode'] = this.artistCode;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['isFavorite'] = this.isFavorite;
    data['firstletter'] = this.firstletter;
    data['favoriteCount'] = this.favoriteCount;
    data['isShowSuspension'] = this.isShowSuspension;
    return data;
  }

  @override
  String getSuspensionTag() => firstletter;
}
