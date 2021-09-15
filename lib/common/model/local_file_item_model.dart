import 'dart:io';

/// jacokwu
/// 8/17/21 5:38 PM

class LocalFileItemModel {
  late FileSystemEntity file;
  late bool isFolder;
  late String fileName;
  String? suffix;

  LocalFileItemModel({required this.file, this.isFolder = false, required this.fileName, this.suffix});

  LocalFileItemModel.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    isFolder = json['isFolder'];
    fileName = json['fileName'];
    suffix = json['suffix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['isFolder'] = this.isFolder;
    data['fileName'] = this.fileName;
    data['suffix'] = this.suffix;
    return data;
  }
}
