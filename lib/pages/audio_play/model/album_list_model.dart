/// jacokwu
/// 8/25/21 3:32 PM

class AlbumListModel {
  late int recommendSort;
  late int type;
  late int baseId;
  late String albumAssetCode;
  late List<Artist> artist;
  late String releaseDate;
  late int cpId;
  late String introduce;
  late String upc;
  late String pic;
  late String title;
  late int payModel;
  late String genre;
  late String lang;
  late String pushTime;
  late String downTime;
  late bool available;
  late String availableErrMsg;
  late List<TrackList> trackList;
  late int isFavorite;

  AlbumListModel(
      {required this.recommendSort,
      required this.type,
      required this.baseId,
      required this.albumAssetCode,
      required this.artist,
      required this.releaseDate,
      required this.cpId,
      required this.introduce,
      required this.upc,
      required this.pic,
      required this.title,
      required this.payModel,
      required this.genre,
      required this.lang,
      required this.pushTime,
      required this.downTime,
      required this.available,
      required this.availableErrMsg,
      required this.trackList,
      required this.isFavorite});

  AlbumListModel.fromJson(Map<String, dynamic> json) {
    recommendSort = json['recommendSort'];
    type = json['type'];
    baseId = json['baseId'];
    albumAssetCode = json['albumAssetCode'];
    if (json['artist'] != null) {
      artist = [];
      json['artist'].forEach((v) {
        artist.add(new Artist.fromJson(v));
      });
    }
    releaseDate = json['releaseDate'];
    cpId = json['cpId'];
    introduce = json['introduce'];
    upc = json['upc'];
    pic = json['pic'];
    title = json['title'];
    payModel = json['pay_model'];
    genre = json['genre'];
    lang = json['lang'];
    pushTime = json['pushTime'];
    downTime = json['downTime'];
    available = json['available'];
    availableErrMsg = json['availableErrMsg'];
    if (json['trackList'] != null) {
      trackList = [];
      json['trackList'].forEach((v) {
        trackList.add(new TrackList.fromJson(v));
      });
    }
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommendSort'] = this.recommendSort;
    data['type'] = this.type;
    data['baseId'] = this.baseId;
    data['albumAssetCode'] = this.albumAssetCode;
    if (this.artist != null) {
      data['artist'] = this.artist.map((v) => v.toJson()).toList();
    }
    data['releaseDate'] = this.releaseDate;
    data['cpId'] = this.cpId;
    data['introduce'] = this.introduce;
    data['upc'] = this.upc;
    data['pic'] = this.pic;
    data['title'] = this.title;
    data['pay_model'] = this.payModel;
    data['genre'] = this.genre;
    data['lang'] = this.lang;
    data['pushTime'] = this.pushTime;
    data['downTime'] = this.downTime;
    data['available'] = this.available;
    data['availableErrMsg'] = this.availableErrMsg;
    if (this.trackList != null) {
      data['trackList'] = this.trackList.map((v) => v.toJson()).toList();
    }
    data['isFavorite'] = this.isFavorite;
    return data;
  }
}

/// 歌手信息
class Artist {
  late String artistCode;
  late String birthday;
  late String gender;
  late String name;
  late int artistType;
  late String artistTypeName;
  late String pic;
  late String region;

  Artist(
      {required this.artistCode,
      required this.birthday,
      required this.gender,
      required this.name,
      required this.artistType,
      required this.artistTypeName,
      required this.pic,
      required this.region});

  Artist.fromJson(Map<String, dynamic> json) {
    artistCode = json['artistCode'];
    birthday = json['birthday'];
    gender = json['gender'];
    name = json['name'];
    artistType = json['artistType'];
    artistTypeName = json['artistTypeName'];
    pic = json['pic'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artistCode'] = this.artistCode;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['artistType'] = this.artistType;
    data['artistTypeName'] = this.artistTypeName;
    data['pic'] = this.pic;
    data['region'] = this.region;
    return data;
  }
}

/// 专辑制作信息
class TrackList {
  late int duration;
  late List<Artist> artist;
  late String assetId;
  late String isrc;
  late int sort;
  late String title;

  TrackList(
      {required this.duration,
      required this.artist,
      required this.assetId,
      required this.isrc,
      required this.sort,
      required this.title});

  TrackList.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    if (json['artist'] != null) {
      artist = [];
      json['artist'].forEach((v) {
        artist.add(new Artist.fromJson(v));
      });
    }
    assetId = json['assetId'];
    isrc = json['isrc'];
    sort = json['sort'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    if (this.artist != null) {
      data['artist'] = this.artist.map((v) => v.toJson()).toList();
    }
    data['assetId'] = this.assetId;
    data['isrc'] = this.isrc;
    data['sort'] = this.sort;
    data['title'] = this.title;
    return data;
  }
}
