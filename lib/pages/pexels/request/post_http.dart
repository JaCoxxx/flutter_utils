import 'package:flutter_utils/pages/douban/request/request_url.dart';
import 'package:flutter_utils/pages/juhe/request/request_url.dart';
import 'package:flutter_utils/pages/pexels/request/request_url.dart';
import 'package:flutter_utils/utils/request.dart';
import 'package:flutter_utils/utils/utils.dart';

/// jacokwu
/// 7/28/21 4:15 PM

class PexelsPostHttp {
  static Request _request = Request();

  static init() {
    _request.init('https://api.pexels.com', '563492ad6f917000010000012bf324bd1c894725a2d599a8bacdae12');
  }

  /// 搜索图片
  static Future searchPhoto(String query, int page, int perPage, {String? orientation, String? size}) async {
    return await _request.get(assemblyLink(PexelsRequestUrl.searchPhoto, {
      'query': query,
      'orientation': orientation,
      'size': size,
      'locale': 'zh-CN',
      'page': page,
      'per_page': perPage,
    }));
  }

  /// 获取热门图片
  static Future getFeaturedPhoto(int page, int perPage) async {
    return await _request.get(assemblyLink(PexelsRequestUrl.getFeaturedPhoto, {
      'page': page,
      'per_page': perPage,
    }));
  }

  /// 获取热门视频
  static Future getPopularVideo(int page, int perPage) async {
    return await _request.get(assemblyLink(PexelsRequestUrl.getPopularVideo, {
      'page': page,
      'per_page': perPage,
    }));
  }
}
