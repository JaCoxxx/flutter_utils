import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/model/artist_list_model.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/artist_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/25/21 9:13 AM

class ArtistListPage extends StatefulWidget {
  const ArtistListPage({Key? key}) : super(key: key);

  @override
  _ArtistListPageState createState() => _ArtistListPageState();
}

class _ArtistListPageState extends State<ArtistListPage> {
  List<ArtistListModel> _artistList = [];
  List<String> _barData = [];

  int pageNo = 1;

  int pageSize = 15;

  late String _currentArtistRegion;
  late String _currentArtistGender;

  bool get isAll => _currentArtistGender == '全部' && _currentArtistRegion == '全部';

  @override
  void initState() {
    super.initState();
    _currentArtistGender = AudioConfig.artistGenderList[0];
    _currentArtistRegion = AudioConfig.artistRegionList[0];
    _getArtistList();
  }

  Future<List<ArtistListModel>> _getArtistList() async {
    return await AudioPostHttp.getArtistList(isAll ? null : pageNo, isAll ? null : pageSize,
            isAll ? null : _currentArtistRegion, isAll ? null : _currentArtistGender)
        .then((value) {
      if (value['state'] == true) {
        if (pageNo == 1) _artistList.clear();
        List<ArtistListModel> fetchList = [];
        fetchList
          ..addAll(value['data']['recommend'].map<ArtistListModel>((e) => ArtistListModel.fromJson({
                ...e,
                'firstletter': '热',
              })))
          ..addAll(value['data']['result'].map<ArtistListModel>((e) => ArtistListModel.fromJson({
            ...e,
            'firstletter': e['firstletter'] ?? '',
          })));
        _artistList.addAll(fetchList.map((e) => e));
        if (isAll) {
          _artistList.forEach((element) {
            if (!_barData.contains(element.firstletter)) _barData.add(element.firstletter);
          });
          _barData
            ..sort()
            ..remove('热')
            ..insert(0, '热');
          SuspensionUtil.setShowSuspensionStatus(_artistList);
        }
        setState(() {});
        return fetchList;
      } else {
        showToast(value['errmsg']);
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        showDefaultBack: true,
        titleConfig: WAppBarTitleConfig(title: '歌手列表'),
      ),
      body: PublicBottomPlayWidget(
        child: _buildContainer(),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (_, index) =>
                    _buildTagItem(AudioConfig.artistRegionList[index], _currentArtistRegion, (value) {
                      _currentArtistRegion = value;
                      pageNo = 1;
                      _getArtistList();
                    }),
                separatorBuilder: (_, index) => Dimens.wGap12,
                itemCount: AudioConfig.artistRegionList.length),
          ),
          SizedBox(
            height: 50,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (_, index) =>
                    _buildTagItem(AudioConfig.artistGenderList[index], _currentArtistGender, (value) {
                      _currentArtistGender = value;
                      pageNo = 1;
                      _getArtistList();
                    }),
                separatorBuilder: (_, index) => Dimens.wGap12,
                itemCount: AudioConfig.artistGenderList.length),
          ),
          if (isAll)
            Expanded(
              child: AzListView(
                data: _artistList,
                indexBarData: _barData,
                itemCount: _artistList.length,
                itemBuilder: (_, index) => _buildItemWidget(index, true),
              ),
            ),
          if (!isAll)
            Expanded(
              child: RefreshListWidget(
                onLoad: () async {
                  pageNo++;
                  return _getArtistList();
                },
                itemBuilder: (index, value) => _buildItemWidget(index, false),
                dataSource: _artistList,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemWidget(int index, bool showSus) {
    return Column(
      children: [
        if (showSus)
          Offstage(
            offstage: _artistList[index].isShowSuspension != true,
            child: _buildSusWidget(_artistList[index].getSuspensionTag()),
          ),
        ArtistItemWidget(artistItem: _artistList[index].toJson()),
      ],
    );
  }

  Widget _buildSusWidget(String susTag) {
    if (susTag == '热') {
      susTag = '热门';
    }
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: Dimens.font_size_14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTagItem(String item, String currentValue, void Function(String) onTap) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: Chip(
          labelPadding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
          backgroundColor: currentValue == item ? Color(0xFFB29B81) : Constants.lightLineColor,
          label: Text(
            item,
            style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_14),
          )),
    );
  }
}
