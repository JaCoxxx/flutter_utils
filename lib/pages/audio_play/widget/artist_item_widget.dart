import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/pages/audio_play/artist/artist_detail_page.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 9/1/21 2:58 PM

class ArtistItemWidget extends StatelessWidget {
  final Map<String, dynamic> artistItem;

  const ArtistItemWidget({Key? key, required this.artistItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListItem(
      title: CustomText.title(artistItem['name']),
      minLeadingWidth: 60,
      leading: CircleAvatar(
        backgroundImage: isStringNotEmpty(artistItem['pic']) ? CachedNetworkImageProvider(artistItem['pic']) : null,
        backgroundColor: Constants.lightLineColor,
        radius: 25,
      ),
      onTap: () {
        Get.toNamed('/artist-detail', arguments: artistItem['artistCode']);
      },
    );
  }
}
