import 'package:flutter_utils/pages/audio_play/audio_list_page.dart';
import 'package:flutter_utils/pages/audio_play/audio_play_page.dart';
import 'package:flutter_utils/pages/home/home_page.dart';
import 'package:flutter_utils/pages/setting/settings_page.dart';
import 'package:flutter_utils/pages/splash/splash_page.dart';
import 'package:flutter_utils/pages/video_play/video_list_page.dart';
import 'package:flutter_utils/pages/video_play/video_play_page.dart';
import 'package:flutter_utils/pages/webview/webview_unzip_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class MainRouter {
  static List<GetPage<dynamic>> routerConfig = [
    GetPage(name: '/splash', page: () => SplashPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/setting', page: () => SettingsPage()),
    GetPage(name: '/video-list', page: () => VideoListPage()),
    GetPage(name: '/video-play', page: () => VideoPlayPage()),
    GetPage(name: '/audio-list', page: () => AudioListPage()),
    GetPage(name: '/audio-play', page: () => AudioPlayPage()),
    GetPage(name: '/unzip', page: () => WebviewUnzipPage()),
  ];
}