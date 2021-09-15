import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_utils/pages/audio_play/request/request_url.dart';
import 'package:flutter_utils/utils/cache_utils.dart';
import 'package:flutter_utils/utils/request.dart';
import 'package:flutter_utils/utils/utils.dart';

/// jacokwu
/// 7/28/21 4:15 PM

class AudioPostHttp {
  static Request _request = Request();

  /// 千千音乐appid
  static String taiheAppId = '16073360';
  /// 千千音乐appsecret
  static String taiheAppSecret = '0b50b02fd0d73a9c4c8c3a781c30845f';
  /// 千千音乐加密算法
  static String taiheMusicSign(String path, Map<String, dynamic> params) {
    int unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    params['timestamp'] = unixTime;
    params['appid'] = taiheAppId;
    List<String> keys = params.keys.toList();
    keys.sort();
    String sign = '';
    for (int i = 0; i < keys.length; i ++) {
      sign += (i == 0 ? '' : '&') + keys[i] + '=' + (params[keys[i]] ?? '').toString();
    }
    sign = md5.convert(utf8.encode('$sign$taiheAppSecret')).toString();
    params['sign'] = sign;
    return assemblyLink(path, params);
  }

  static init() {
    _request = Request();
    _request.init(null, null);
  }

  /// 歌单列表
  static Future getTrackList(int pageNo, int pageSize, String? subCateId) async {
    // await CacheUtils.remove('tracklist');
    String? tracklist = await CacheUtils.getString('tracklist');
    if (tracklist != null) return jsonDecode(tracklist);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getTrackList, {
      'pageNo': pageNo,
      'pageSize': pageSize,
      'subCateId': subCateId
    })).then((value) {
      CacheUtils.setString('tracklist', jsonEncode(value));
      return value;
    });
  }

  /// 获取全部流派
  static Future getTrackCategory() async {
    String? category = await CacheUtils.getString('category');
    if (category != null) return jsonDecode(category);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getTrackCategory, {})).then((value) {
      CacheUtils.setString('category', jsonEncode(value));
      return value;
    });
  }

  /// 轮播图
  static Future getBannerList() async {
    return await _request.get(taiheMusicSign(AudioRequestUrl.getBannerList, {}));
  }

  /// 歌曲列表
  static Future getSongList(int pageNo, int pageSize) async {
    return await _request.get(taiheMusicSign(AudioRequestUrl.getSongList, {
      'pageNo': pageNo,
      'pageSize': pageSize,
    }));
  }

  /// 获取首页整合数据
  static Future getHomeData() async {
    String? homeData = await CacheUtils.getString('homeData');
    if (homeData != null) return jsonDecode(homeData);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getHomeData, {})).then((value) {
      CacheUtils.setString('homeData', jsonEncode(value));
      return value;
    });
  }

  /// 获取最新专辑
  static Future getNewAlbumList(int pageNo, int pageSize) async {
    String? newAlbum = await CacheUtils.getString('newAlbum');
    if (newAlbum != null) return jsonDecode(newAlbum);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getNewAlbumList, {
      'pageNo': pageNo,
      'pageSize': pageSize,
    })).then((value) {
      CacheUtils.setString('newAlbum', jsonEncode(value));
      return value;
    });
  }

  /// 获取歌手列表
  static Future getArtistList(int? pageNo, int? pageSize, String? artistRegion, String? artistGender) async {
    String? artistList = await CacheUtils.getString('artistList');
    if (artistList != null) return jsonDecode(artistList);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getArtistList, {
      'pageNo': pageNo,
      'pageSize': pageSize,
      'artistRegion': artistRegion,
      'artistGender': artistGender,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('artistList', jsonEncode(value));
      return value;
    });
  }

  /// 获取歌手详情
  static Future getArtistInfo(String artistCode) async {
    // await CacheUtils.remove('artistInfo');
    String? artistInfo = await CacheUtils.getString('artistInfo');
    if (artistInfo != null) return jsonDecode(artistInfo);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getArtistInfo, {
      'artistCode': artistCode,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('artistInfo', jsonEncode(value));
      return value;
    });
  }

  /// 获取歌手歌曲列表
  static Future getArtistSongList(int pageNo, int pageSize, String artistCode) async {
    String? artistSong = await CacheUtils.getString('artistSong');
    if (artistSong != null) return jsonDecode(artistSong);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getArtistSongList, {
      'pageNo': pageNo,
      'pageSize': pageSize,
      'artistCode': artistCode,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('artistSong', jsonEncode(value));
      return value;
    });
  }

  /// 获取歌手专辑列表
  static Future getArtistAlbumList(int pageNo, int pageSize, String artistCode) async {
    String? artistAlbum = await CacheUtils.getString('artistAlbum');
    if (artistAlbum != null) return jsonDecode(artistAlbum);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getArtistAlbumList, {
      'pageNo': pageNo,
      'pageSize': pageSize,
      'artistCode': artistCode,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('artistAlbum', jsonEncode(value));
      return value;
    });
  }

  /// 获取榜单分类
  static Future getTopCategory() async {
    String? topCategory = await CacheUtils.getString('topCategory');
    if (topCategory != null) return jsonDecode(topCategory);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getTopCategory, {}), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('topCategory', jsonEncode(value));
      return value;
    });
  }

  /// 获取榜单列表数据
  static Future getTopList(String bdid, int pageNo, int pageSize) async {
    String? topList = await CacheUtils.getString('topList');
    if (topList != null) return jsonDecode(topList);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getTopList, {
      'bdid': bdid,
      'pageNo': pageNo,
      'pageSize': pageSize,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('topList', jsonEncode(value));
      return value;
    });
  }

  /// 获取歌单详情
  static Future getTrackInfo(String id, int pageNo, int pageSize) async {
    // await CacheUtils.remove('trackInfo');
    String? trackInfo = await CacheUtils.getString('trackInfo');
    if (trackInfo != null) return jsonDecode(trackInfo);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getTrackInfo, {
      'id': id,
      'pageNo': pageNo,
      'pageSize': pageSize,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('trackInfo', jsonEncode(value));
      return value;
    });
  }

  /// 获取专辑详情
  static Future getAlbumInfo(String albumAssetCode) async {
    // await CacheUtils.remove('albumInfo');
    String? albumInfo = await CacheUtils.getString('albumInfo');
    if (albumInfo != null) return jsonDecode(albumInfo);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getAlbumInfo, {
      'albumAssetCode': albumAssetCode,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('albumInfo', jsonEncode(value));
      return value;
    });
  }

  /// 获取搜索推荐
  static Future getSearchSug(String word, String? type) async {
    // await CacheUtils.remove('searchSug');
    String? searchSug = await CacheUtils.getString('searchSug');
    if (searchSug != null) return jsonDecode(searchSug);
    return await _request.get(taiheMusicSign(AudioRequestUrl.searchSug, {
      'word': word,
      'type': type,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('searchSug', jsonEncode(value));
      return value;
    });
  }

  /// 搜索
  static Future search(String word, int pageNo, int pageSize, String? type) async {
    // await CacheUtils.remove('search');
    String? search = await CacheUtils.getString('search');
    if (search != null) return jsonDecode(search);
    return await _request.get(taiheMusicSign(AudioRequestUrl.search, {
      'word': word,
      'pageNo': pageNo,
      'pageSize': pageSize,
      'type': type,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('search', jsonEncode(value));
      return value;
    });
  }

  /// 获取歌曲详细链接
  static Future getSongTrackLink(String id) async {
    await CacheUtils.remove('trackLink');
    String? trackLink = await CacheUtils.getString('trackLink');
    if (trackLink != null) return jsonDecode(trackLink);
    return await _request.get(taiheMusicSign(AudioRequestUrl.getSongTrackLink, {
      'TSID': id,
    }), headers: {
      'app-version': 'v8.2.3.5',
      'channel': 'Huawei',
      'from': 'android'
    }).then((value) {
      CacheUtils.setString('trackLink', jsonEncode(value));
      return value;
    });
  }
}
