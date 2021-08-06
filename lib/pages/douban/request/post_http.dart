import 'package:flutter_utils/pages/douban/request/request_url.dart';
import 'package:flutter_utils/utils/request.dart';

/// jacokwu
/// 7/28/21 4:15 PM

class DouBanPostHttp {
  static Request _request = Request();

  static init() {
    _request = Request();
    _request.init(null, null);
  }

  /// 登录
  static Future login(String name, String password) async {
    return _request.post(DouBanRequestUrl.login, {
      'name': name,
      'password': password,
      'ck': 'uInJ'
    }, headers: {
      'USER-AGENT':
      'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36'
    });
  }

  /// 获取标签列表
  static Future getTagsList(String type) async {
    print('${DouBanRequestUrl.getMovieTags}?type=$type&tag=热门&source=index');
    return _request.get(
        Uri.encodeFull(
            '${DouBanRequestUrl.getMovieTags}?type=$type&tag=热门&source=index'),
        headers: {
          'USER-AGENT':
              'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36'
        }).catchError((err) {
      print(err);
    });
  }

  /// 获取热门列表
  static Future getHotList(
      String type, String tag, int pageSize, int page) async {
    return _request.get(
        Uri.encodeFull(
            '${DouBanRequestUrl.getHotMovieList}?type=$type&tag=$tag&page_limit=$pageSize&page_start=$page'),
        headers: {
          'USER-AGENT':
              'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36'
        });
  }
}
