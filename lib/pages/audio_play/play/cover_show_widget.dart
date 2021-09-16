import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';

/// jacokwu
/// 9/7/21 9:34 AM

class CoverShowWidget extends StatefulWidget {
  final Map<String, dynamic> currentSong;

  const CoverShowWidget({Key? key, required this.currentSong}) : super(key: key);

  @override
  _CoverShowWidgetState createState() => _CoverShowWidgetState();
}

class _CoverShowWidgetState extends State<CoverShowWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late AudioPlayController _audioPlayController;

  @override
  void initState() {
    super.initState();
    _audioPlayController = BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController
      ..addListener(_bindListener);
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 24));
    _changedAnimation();
  }

  _bindListener() {
    _changedAnimation();
  }

  _changedAnimation() {
    if (_audioPlayController.currentState == PlayerState.PLAYING) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      if (_controller.isAnimating) _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
    _audioPlayController.removeListener(_bindListener);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(180)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  widget.currentSong['pic'] != null
                      ? RotationTransition(
                          turns: _controller,
                          child: Container(
                            width: ScreenUtil().setWidth(370),
                            height: ScreenUtil().setWidth(370),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CacheNetworkImageWidget(
                              imageUrl: widget.currentSong['pic'],
                              width: ScreenUtil().setWidth(370),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: ScreenUtil().setWidth(370),
                          height: ScreenUtil().setWidth(370),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          clipBehavior: Clip.antiAlias,
                        ),
                  Image.asset(
                    'assets/images/bet.png',
                    width: ScreenUtil().setWidth(550),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
