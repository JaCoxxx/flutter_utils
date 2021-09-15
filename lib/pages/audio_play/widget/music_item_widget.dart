import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/album/album_detail_page.dart';
import 'package:flutter_utils/pages/audio_play/artist/artist_detail_info_page.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/30/21 1:57 PM

class MusicItemWidget extends StatelessWidget {
  final Map<String, dynamic> musicItem;

  final int? index;

  final Widget? leading;

  final double? minLeadingWidth;

  final Color? backgroundColor;

  const MusicItemWidget({
    Key? key,
    required this.musicItem,
    this.index,
    this.leading,
    this.minLeadingWidth,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AudioPlayController _controller = BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController;
    return CustomListItem(
      onTap: () {
        _controller..replacePlayList([musicItem], musicItem['TSID']);
        // _controller..addNextPlay(musicItem)..playNext();
      },
      backgroundColor: backgroundColor,
      title: CustomText.title(
        musicItem['title'],
        fontSize: Dimens.font_size_14,
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            if (musicItem['isVip'] == 1)
              TextSpan(
                  text: ' VIP ',
                  style: TextStyle(color: Colors.white, fontSize: Dimens.font_size_12, backgroundColor: Colors.red)),
            if (musicItem['isVip'] == 1) TextSpan(text: '  '),
            TextSpan(
                text: (musicItem['artist'] ?? []).map((e) => e['name']).join('/'),
                style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_12)),
            if (musicItem['albumTitle'] != null) TextSpan(text: ' - ', style: TextStyle(color: Constants.gray_9)),
            if (musicItem['albumTitle'] != null)
              TextSpan(
                  text: musicItem['albumTitle'],
                  style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_12)),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      minLeadingWidth: minLeadingWidth != null
          ? minLeadingWidth
          : index == null
              ? null
              : 50,
      leading: leading != null
          ? leading
          : index == null
              ? null
              : Center(
                  child: CustomText(
                    fillInNum(index! + 1),
                    color: [1, 2, 3].contains(index! + 1) ? Colors.black : Constants.gray_9,
                    fontSize: Dimens.font_size_20,
                  ),
                ),
      trailing: InkWell(
          onTap: () {
            AudioConfig.showBottomCustomSheetDialog(
              context,
              needCancel: false,
              menuList: [
                if (_controller.playList.length > 0) {
                  'key': 'nextPlay',
                  'title': '下一首播放',
                  'icon': Icons.play_circle_outline,
                },
                {
                  'key': 'download',
                  'title': '下载',
                  'icon': Icons.download_outlined,
                },
                {
                  'key': 'collect',
                  'title': '收藏',
                  'icon': Icons.star_border_outlined,
                },
                {
                  'key': 'share',
                  'title': '分享',
                  'icon': Icons.share_outlined,
                },
                {
                  'key': 'artist',
                  'title': '歌手: ${musicItem['artist'].map((e) => e['name']).join('/')}',
                  'image': 'assets/images/artist.png',
                },
                if (musicItem['albumTitle'] != null) {
                  'key': 'album',
                  'title': '专辑: ${musicItem['albumTitle']}',
                  'image': 'assets/images/album.png',
                },
              ],
              onTap: (key) {
                switch(key) {
                  case 'artist':
                    AudioConfig.getToArtistPage(context, musicItem['artist'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList());
                    break;
                  case 'album':
                    Get.to(AlbumDetailPage(albumAssetCode: musicItem['albumAssetCode']));
                    break;
                  case 'nextPlay':
                    _controller.addNextPlay(musicItem);
                    showToast('添加下一首播放成功');
                    break;
                  default:
                    showToast('暂未开放');
                    break;
                }
              },
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.more_vert,
              size: Dimens.font_size_16,
              color: Constants.gray_9,
            ),
          )),
    );
  }
}
