import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';

/// jacokwu
/// 9/8/21 5:00 PM

class PlayListWidget extends StatefulWidget {
  const PlayListWidget({Key? key}) : super(key: key);

  @override
  _PlayListWidgetState createState() => _PlayListWidgetState();
}

class _PlayListWidgetState extends State<PlayListWidget> {

  late AudioPlayController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController..addListener(bindListener);
  }

  bindListener() {
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(bindListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setWidth(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  '播放列表(${_controller.playList.length})',
                  color: Colors.black,
                  fontSize: Dimens.font_size_14,
                ),
                TextButton.icon(
                    onPressed: () {
                      _controller.clearPlayList();
                    },
                    icon: Icon(
                      CupertinoIcons.trash,
                      color: Constants.gray_9,
                      size: Dimens.font_size_16,
                    ),
                    label: CustomText.content('清空全部')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                bool isPlay = _controller.currentId == _controller.playList[index]['TSID'];
                return CustomListItem(
                  onTap: () {
                    _controller.playById(_controller.playList[index]['TSID']);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: isPlay
                      ? Icon(
                    Icons.play_arrow,
                    color: Colors.red,
                    size: Dimens.font_size_14,
                  )
                      : null,
                  minLeadingWidth: isPlay ? 24 : null,
                  title: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: _controller.playList[index]['title'],
                            style: TextStyle(
                                color: isPlay ? Colors.red : Colors.black,
                                fontSize: Dimens.font_size_14)),
                        TextSpan(
                            text:
                            ' - ${_controller.playList[index]['artist'].map((e) => e['name']).join('/')}',
                            style: TextStyle(
                                color: isPlay ? Colors.red : Constants.gray_9,
                                fontSize: Dimens.font_size_12)),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _controller.delAudioFromPlayList(_controller.playList[index]);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Constants.gray_c,
                    ),
                  ),
                );
              },
              itemCount: _controller.playList.length,
            ),
          ),
        ],
      ),
    );
  }
}

