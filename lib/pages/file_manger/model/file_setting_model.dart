/// jacokwu
/// 9/10/21 3:52 PM

class FileSettingModel {
  /// 是否显示隐藏文件
  late bool showHiddenFile;
  /// 文件布局方式,true:list/false:grid
  late bool fileLayoutType;

  FileSettingModel({this.showHiddenFile = false, this.fileLayoutType = true});

  FileSettingModel.fromJson(Map<String, dynamic> json) {
    showHiddenFile = json['showHiddenFile'];
    fileLayoutType = json['fileLayoutType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['showHiddenFile'] = this.showHiddenFile;
    data['fileLayoutType'] = this.fileLayoutType;
    return data;
  }
}
