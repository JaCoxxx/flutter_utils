import 'package:flutter/material.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';

/// jacokwu
/// 8/24/21 10:54 AM

class MyNavigator extends GetObserver {

  final context;

  /// 路由变化监听，处理输入框失焦问题
  MyNavigator(this.context);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    hideKeyboard(context);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    hideKeyboard(context);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    hideKeyboard(context);
  }
}
