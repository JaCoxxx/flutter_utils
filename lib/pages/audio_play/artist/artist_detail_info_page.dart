import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/utils.dart';

/// jacokwu
/// 8/30/21 10:30 AM

class ArtistDetailInfoPage extends StatefulWidget {

  final Map<String, dynamic> artistInfo;

  const ArtistDetailInfoPage({Key? key, required this.artistInfo}) : super(key: key);

  @override
  _ArtistDetailInfoPageState createState() => _ArtistDetailInfoPageState();
}

class _ArtistDetailInfoPageState extends State<ArtistDetailInfoPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
      child: SingleChildScrollView(child: Text(isStringEmpty(widget.artistInfo['introduce']) ? '暂无简介' : widget.artistInfo['introduce'])),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

