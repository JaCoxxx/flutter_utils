import 'package:flutter_utils/pages/blog/csdn/request/request_url.dart';
import 'package:flutter_utils/utils/request.dart';

/// jacokwu
/// 7/28/21 4:15 PM

class CSDNPostHttp {

  static Request _request = Request();
  static String _name = 'jacoox';

  static init(String name) {
    _request = Request();
    _name = name;
    _request.init(null, null);
  }

  static Future getListPage(String? name) async {
    return _request.get('${CSDNRequestUrl.getListPage}${name ?? _name}');
  }

  static Future getDetailPage(String? path) async {
    return _request.get(path!);
  }
}
