import 'package:flutter/animation.dart';
import 'package:flutter_utils/pages/audio_play/artist/artist_detail_page.dart';
import 'package:flutter_utils/pages/audio_play/artist/artist_list_page.dart';
import 'package:flutter_utils/pages/audio_play/search/audio_search_page.dart';
import 'package:flutter_utils/pages/audio_play/top/audio_top_list_page.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../audio_home_page.dart';
import '../audio_list_page.dart';
import '../play/audio_play_page.dart';

/// jacokwu
/// 8/30/21 10:46 AM

class AudioRouter {
  static List<GetPage<dynamic>> routerConfig = [
    GetPage(
        name: '/audio-home',
        page: () => AudioHomePage(),
        transition: Transition.noTransition,),
    GetPage(name: '/artist-list', page: () => ArtistListPage()),
    GetPage(name: '/artist-detail', page: () => ArtistDetailPage()),
    GetPage(name: '/audio-list', page: () => AudioListPage()),
    GetPage(name: '/audio-play', page: () => AudioPlayPage()),
    GetPage(name: '/audio-top', page: () => AudioTopListPage()),
    GetPage(name: '/audio-search', page: () => AudioSearchPage()),
  ];
}
