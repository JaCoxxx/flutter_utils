import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:flutter_utils/pages/audio_play/play/audio_play_page.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// jacokwu
/// 9/1/21 4:20 PM

class PublicBottomPlayWidget extends StatefulWidget {
  final Widget child;

  const PublicBottomPlayWidget({Key? key, required this.child}) : super(key: key);

  @override
  _PublicBottomPlayWidgetState createState() => _PublicBottomPlayWidgetState();
}

class _PublicBottomPlayWidgetState extends State<PublicBottomPlayWidget> {
  late AudioPlayController _controller;

  Map<String, dynamic> get _curSong =>
      _controller.currentId == null ? {} : _controller.getSongDetailInfoById(_controller.currentId!);

  @override
  void initState() {
    super.initState();
    _controller = BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController
      ..init()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: widget.child),
            SizedBox(height: ScreenUtil().setWidth(100)),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: ScreenUtil().setWidth(120) + MediaQuery.of(context).padding.bottom,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: ScreenUtil().setWidth(100) + MediaQuery.of(context).padding.bottom,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                      color: Colors.white,
                      child: CustomListItem(
                        onTap: () {
                          if (_controller.currentId == null) return;
                          Get.to(AudioPlayPage());
                        },
                        title: Container(
                          padding: EdgeInsets.only(left: 16 + ScreenUtil().setWidth(80)),
                          child: _curSong['title'] == null
                              ? null
                              : RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: _curSong['title'] ?? '',
                                        style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_14)),
                                    TextSpan(text: ' - '),
                                    TextSpan(
                                        text: _curSong['artist'] != null && _curSong['artist'].length > 0
                                            ? _curSong['artist'].map((e) => e['name']).join('/')
                                            : ''),
                                  ], style: TextStyle(fontSize: Dimens.font_size_14, color: Constants.gray_9)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                        ),
                        trailing: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (_controller.currentId == null) return;
                                  if (_controller.currentState == PlayerState.PLAYING) {
                                    _controller.pause();
                                  } else if (_controller.currentState == PlayerState.PAUSED) {
                                    _controller.resume();
                                  } else {
                                    _controller.play(position: _controller.currentPosition);
                                  }
                                },
                                child: Icon(
                                    _controller.currentState == PlayerState.PLAYING ? Icons.pause : Icons.play_arrow)),
                            Dimens.wGap16,
                            GestureDetector(
                                onTap: () {
                                  if (_controller.currentId == null) return;
                                  _controller.playNext();
                                },
                                child: Icon(Icons.skip_next)),
                          ],
                        ),
                      ),
                    )),
                Positioned(
                  left: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  child: GestureDetector(
                    onTap: () {
                      if (_controller.currentId == null) return;
                      Get.to(AudioPlayPage());
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(80),
                      height: ScreenUtil().setWidth(80),
                      padding: EdgeInsets.all(Dimens.pd8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.lightLineColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _curSong['pic'] == null
                            ? null
                            : CacheNetworkImageWidget(
                                imageUrl: _curSong['pic'],
                                width: ScreenUtil().setWidth(64),
                                height: ScreenUtil().setWidth(64),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
