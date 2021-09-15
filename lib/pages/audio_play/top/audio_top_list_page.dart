import 'package:flutter/material.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/top/audio_top_list_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_tab_bar.dart';
import 'package:flutter_utils/widget/widgets.dart';

/// jacokwu
/// 8/30/21 10:35 AM

class AudioTopListPage extends StatefulWidget {
  const AudioTopListPage({Key? key}) : super(key: key);

  @override
  _AudioTopListPageState createState() => _AudioTopListPageState();
}

class _AudioTopListPageState extends State<AudioTopListPage> {

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _getTopList() async {
    return await AudioPostHttp.getTopCategory().then((value) {
      if (value['state'] == true) {
        print(value['data']);
        return value['data'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      } else {
        showToast(value['errmsg']);
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(titleConfig: WAppBarTitleConfig(title: '榜单'), showDefaultBack: true,),
      body: PublicBottomPlayWidget(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getTopList(),
          builder: (_, snap) {
            print(snap.data);
            print(snap.hasData && snap.data!.length > 0);
            if (snap.hasData && snap.data!.length > 0) return AudioTopListWidget(topCategory: snap.data!,);
            return pageLoading(context);
          },
        ),
      ),
    );
  }
}

