import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/main_theme_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_utils/pages/error/not_found_page.dart';
import 'package:flutter_utils/router/main_router.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

final GlobalKey<NavigatorState> navigatorKey = Get.key;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'utils',
      navigatorKey: navigatorKey,
      theme: MainThemeData.currentTheme,
      getPages: MainRouter.routerConfig,
      initialRoute: '/splash',
      unknownRoute: GetPage(name: '/404', page: () => NotFoundPage()),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
      ],
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      // builder: (context, widget) => ResponsiveWrapper.builder(
      //     BouncingScrollWrapper.builder(context, widget!),
      //     maxWidth: 1200,
      //     minWidth: 480,
      //     defaultScale: true,
      //     breakpoints: [
      //       ResponsiveBreakpoint.resize(450, name: MOBILE),
      //       ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //       ResponsiveBreakpoint.autoScale(1000, name: TABLET),
      //       ResponsiveBreakpoint.resize(1200, name: DESKTOP),
      //       ResponsiveBreakpoint.autoScale(2460, name: "4K"),
      //     ],
      //     background: Container(color: Color(0xFFF5F5F5))),
    );
  }
}
