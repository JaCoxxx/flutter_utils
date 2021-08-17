import 'package:flutter_utils/pages/games/yingyongbao/request/request_url.dart';
import 'package:flutter_utils/utils/request.dart';

/// jacokwu
/// 7/28/21 4:15 PM

class YYBPostHttp {
  static Request _request = Request();

  static init() {
    _request = Request();
    _request.init(null, null);
  }

  static Future getAllGameList({
    int categoryId = 0,
    int pageSize = 20,
    required String pageContext,
  }) async {
    return _request.get(Uri.encodeFull(
        '${YYBRequestUrl.getAllGameList}?orgame=2&categoryId=$categoryId&pageSize=$pageSize&pageContext=$pageContext'));
  }

  static Future searchAppList(String kw, String? pns, int? sid) async {
    return _request.post(
        Uri.encodeFull(
            '${YYBRequestUrl.searchAppList}?kw=$kw${pns == null ? '' : '&pns=$pns'}${sid == null ? '' : '&sid=$sid'}'),
        null,
        headers: {
          'user-agent':
              'Mozilla/5.0 (Linux; Android 8.0.0; Pixel 2 XL Build/OPD1.170816.004) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Mobile Safari/537.36'
        });
  }
}
