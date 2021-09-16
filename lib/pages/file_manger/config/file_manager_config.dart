import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/local_file_item_model.dart';
import 'package:flutter_utils/common/strings.dart';
import 'package:flutter_utils/pages/file_manger/model/file_setting_model.dart';
import 'package:flutter_utils/pages/file_manger/widget/file_detail_dialog_widget.dart';
import 'package:flutter_utils/utils/cache_utils.dart';
import 'package:flutter_utils/utils/clear_cache_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// jacokwu
/// 9/10/21 3:31 PM

class FileManagerConfig {
  /// 设置默认值
  static FileSettingModel defaultSettingValue = FileSettingModel(showHiddenFile: false, fileLayoutType: true);

  /// 文件图标
  static IconData getFileIcon(String? suffix) {
    switch (suffix) {
      case 'pdf':
        return FontAwesomeIcons.filePdf;
      case 'doc':
      case 'docx':
        return FontAwesomeIcons.fileWord;
      case 'xls':
      case 'xlsx':
        return FontAwesomeIcons.fileExcel;
      case 'html':
      case 'htm':
      case 'js':
      case 'json':
      case 'dart':
      case 'java':
      case 'class':
      case 'c':
      case 'css':
        return FontAwesomeIcons.fileCode;
      case 'mp3':
      case 'MP3':
      case 'flac':
      case 'ncm':
        return FontAwesomeIcons.fileAudio;
      case 'zip':
      case '7z':
      case 'rar':
        return FontAwesomeIcons.fileArchive;
      case 'jpg':
      case 'png':
      case 'jpeg':
      case 'gif':
      case 'bmp':
      case 'webp':
        return FontAwesomeIcons.fileImage;
      default:
        return FontAwesomeIcons.file;
    }
  }

  static void showBottomDetailDialog(BuildContext context, LocalFileItemModel itemModel) async {
    showDialog(
        context: context,
        builder: (_) => FileDetailDialogWidget(itemModel: itemModel));
  }

  static Future<void> saveSetting(FileSettingModel value) async {
    await CacheUtils.remove(Strings.FILE_SETTING);
    await CacheUtils.setString(Strings.FILE_SETTING, jsonEncode(value.toJson()));
  }

  static Future<FileSettingModel?> getSetting() async {
    String? cacheValue = await CacheUtils.getString(Strings.FILE_SETTING);
    return cacheValue == null ? null : FileSettingModel.fromJson(jsonDecode(cacheValue));
  }

  static Future<void> removeSetting() async {
    await CacheUtils.remove(Strings.FILE_SETTING);
  }

  /// 文件打开类型
  static const Map<String, dynamic> fileOpenType = {
    ".3gp": "video/3gpp",
    ".torrent": "application/x-bittorrent",
    ".kml": "application/vnd.google-earth.kml+xml",
    ".gpx": "application/gpx+xml",
    ".csv": "application/vnd.ms-excel",
    ".apk": "application/vnd.android.package-archive",
    ".asf": "video/x-ms-asf",
    ".avi": "video/x-msvideo",
    ".bin": "application/octet-stream",
    ".bmp": "image/bmp",
    ".c": "text/plain",
    ".class": "application/octet-stream",
    ".conf": "text/plain",
    ".cpp": "text/plain",
    ".doc": "application/msword",
    ".docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    ".xls": "application/vnd.ms-excel",
    ".xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    ".exe": "application/octet-stream",
    ".flac": "audio/x-mpeg",
    ".gif": "image/gif",
    ".gtar": "application/x-gtar",
    ".gz": "application/x-gzip",
    ".h": "text/plain",
    ".htm": "text/html",
    ".html": "text/html",
    ".jar": "application/java-archive",
    ".java": "text/plain",
    ".jpeg": "image/jpeg",
    ".jpg": "image/jpeg",
    ".js": "application/x-javascript",
    ".log": "text/plain",
    ".m3u": "audio/x-mpegurl",
    ".m4a": "audio/mp4a-latm",
    ".m4b": "audio/mp4a-latm",
    ".m4p": "audio/mp4a-latm",
    ".m4u": "video/vnd.mpegurl",
    ".m4v": "video/x-m4v",
    ".mov": "video/quicktime",
    ".mp2": "audio/x-mpeg",
    ".mp3": "audio/x-mpeg",
    ".mp4": "video/mp4",
    ".mpc": "application/vnd.mpohun.certificate",
    ".mpe": "video/mpeg",
    ".mpeg": "video/mpeg",
    ".mpg": "video/mpeg",
    ".mpg4": "video/mp4",
    ".mpga": "audio/mpeg",
    ".msg": "application/vnd.ms-outlook",
    ".ncm": "audio/x-mpeg",
    ".ogg": "audio/ogg",
    ".pdf": "application/pdf",
    ".png": "image/png",
    ".pps": "application/vnd.ms-powerpoint",
    ".ppt": "application/vnd.ms-powerpoint",
    ".pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    ".prop": "text/plain",
    ".rc": "text/plain",
    ".rmvb": "audio/x-pn-realaudio",
    ".rtf": "application/rtf",
    ".sh": "text/plain",
    ".tar": "application/x-tar",
    ".tgz": "application/x-compressed",
    ".txt": "text/plain",
    ".wav": "audio/x-wav",
    ".wma": "audio/x-ms-wma",
    ".wmv": "audio/x-ms-wmv",
    ".wps": "application/vnd.ms-works",
    ".xml": "text/plain",
    ".z": "application/x-compress",
    ".zip": "application/x-zip-compressed",
    "": "*/*"
  };
}
