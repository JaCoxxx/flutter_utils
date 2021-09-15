import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/main_theme_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_utils/pages/error/not_found_page.dart';
import 'package:flutter_utils/router/main_router.dart';
import 'package:flutter_utils/utils/my_navigator.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = Get.key;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      builder: () => GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: GetMaterialApp(
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
          navigatorObservers: [BotToastNavigatorObserver(), MyNavigator(context)],
        ),
      ),
    );
  }
}
