import 'package:flutter_utils/utils/request.dart';

/// jacokwu
/// 7/28/21 4:15 PM

class CSDNPostHttp {

  static Request _request = Request();
  static String _name = 'jacoox';

  static init(String name) {
    _request = Request();
    _name = name;
    _request.init('https://blog.csdn.net/', null);
  }

  static Future getListPage(String? name) async {
    return _request.get(name ?? _name);
  }
}
