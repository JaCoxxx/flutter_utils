import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/album/album_detail_page.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/30/21 2:30 PM

class AlbumItemWidget extends StatelessWidget {
  final Map<String, dynamic> albumItem;

  final bool showArtist;

  const AlbumItemWidget({Key? key, required this.albumItem, this.showArtist = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListItem(
      title: CustomText.title(albumItem['title']),
      subtitle: CustomText.content(
        _getContentString(),
        fontSize: Dimens.font_size_12,
      ),
      minLeadingWidth: 60,
      leading: CacheNetworkImageWidget(
        imageUrl: albumItem['pic'],
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Get.to(AlbumDetailPage(albumAssetCode: albumItem['albumAssetCode']));
      },
    );
  }

  String _getContentString() {
    String content = '';
    if (showArtist) content += '${albumItem['artist'].map((e) => e['name']).join('/')}  ';
    content += isStringNotEmpty(albumItem['releaseDate']) ? albumItem['releaseDate'].toString().substring(0, 10) : '';
    if (!showArtist) content += '  ${albumItem['trackList'].length}首';
    return content;
  }
}
