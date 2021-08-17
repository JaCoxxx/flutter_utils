/// jacokwu
/// 8/12/21 2:05 PM

class YYBListModel {
  String? description;
  int? flag;
  late int fileSize;
  late int authorId;
  late int categoryId;
  late String apkMd5;
  late String categoryName;
  late String apkUrl;
  late int appDownCount;
  late int appId;
  late String appName;
  late String authorName;
  late String iconUrl;
  late String newFeature;
  late String pkgName;
  late int versionCode;
  late String versionName;
  late double averageRating;
  late String editorIntro;
  late List<String> images;
  late int apkPublishTime;
  late AppRatingInfo appRatingInfo;

  YYBListModel(
      {this.description,
        this.flag,
        required this.fileSize,
        required this.authorId,
        required this.categoryId,
        required this.apkMd5,
        required this.categoryName,
        required this.apkUrl,
        required this.appDownCount,
        required this.appId,
        required this.appName,
        required this.authorName,
        required this.iconUrl,
        required this.newFeature,
        required this.pkgName,
        required this.versionCode,
        required this.versionName,
        required this.averageRating,
        required this.editorIntro,
        required this.images,
        required this.apkPublishTime,
        required this.appRatingInfo});

  YYBListModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    flag = json['flag'];
    fileSize = json['fileSize'];
    authorId = json['authorId'];
    categoryId = json['categoryId'];
    apkMd5 = json['apkMd5'];
    categoryName = json['categoryName'];
    apkUrl = json['apkUrl'];
    appDownCount = json['appDownCount'];
    appId = json['appId'];
    appName = json['appName'];
    authorName = json['authorName'];
    iconUrl = json['iconUrl'];
    newFeature = json['newFeature'];
    pkgName = json['pkgName'];
    versionCode = json['versionCode'];
    versionName = json['versionName'];
    averageRating = json['averageRating'];
    editorIntro = json['editorIntro'];
    images = json['images'].cast<String>();
    apkPublishTime = json['apkPublishTime'];
    appRatingInfo = (json['appRatingInfo'] != null
        ? new AppRatingInfo.fromJson(json['appRatingInfo'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['flag'] = this.flag;
    data['fileSize'] = this.fileSize;
    data['authorId'] = this.authorId;
    data['categoryId'] = this.categoryId;
    data['apkMd5'] = this.apkMd5;
    data['categoryName'] = this.categoryName;
    data['apkUrl'] = this.apkUrl;
    data['appDownCount'] = this.appDownCount;
    data['appId'] = this.appId;
    data['appName'] = this.appName;
    data['authorName'] = this.authorName;
    data['iconUrl'] = this.iconUrl;
    data['newFeature'] = this.newFeature;
    data['pkgName'] = this.pkgName;
    data['versionCode'] = this.versionCode;
    data['versionName'] = this.versionName;
    data['averageRating'] = this.averageRating;
    data['editorIntro'] = this.editorIntro;
    data['images'] = this.images;
    data['apkPublishTime'] = this.apkPublishTime;
    data['appRatingInfo'] = this.appRatingInfo.toJson();
    return data;
  }
}

class AppRatingInfo {
  late double averageRating;
  late int ratingCount;
  late RatingDistribution ratingDistribution;

  AppRatingInfo(
      {required this.averageRating, required this.ratingCount, required this.ratingDistribution});

  AppRatingInfo.fromJson(Map<String, dynamic> json) {
    averageRating = json['averageRating'];
    ratingCount = json['ratingCount'];
    ratingDistribution = (json['ratingDistribution'] != null
        ? new RatingDistribution.fromJson(json['ratingDistribution'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['averageRating'] = this.averageRating;
    data['ratingCount'] = this.ratingCount;
    data['ratingDistribution'] = this.ratingDistribution.toJson();
    return data;
  }
}

class RatingDistribution {
  late int i1;
  late int i2;
  late int i3;
  late int i4;
  late int i5;

  RatingDistribution({required this.i1, required this.i2, required this.i3, required this.i4, required this.i5});

  RatingDistribution.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    i5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.i1;
    data['2'] = this.i2;
    data['3'] = this.i3;
    data['4'] = this.i4;
    data['5'] = this.i5;
    return data;
  }
}
