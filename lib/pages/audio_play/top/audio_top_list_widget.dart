import 'package:flutter/material.dart';
import 'package:flutter_utils/pages/audio_play/top/audio_refresh_widget.dart';

/// jacokwu
/// 8/30/21 10:45 AM

class AudioTopListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> topCategory;

  const AudioTopListWidget({Key? key, required this.topCategory}) : super(key: key);

  @override
  _AudioTopListWidgetState createState() => _AudioTopListWidgetState();
}

class _AudioTopListWidgetState extends State<AudioTopListWidget> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.topCategory.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          tabs: widget.topCategory
              .map<Tab>((e) => Tab(
                    text: e['title'],
                  ))
              .toList(),
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        Expanded(
            child: TabBarView(
          children: widget.topCategory
              .map<Widget>((e) => AudioRefreshWidget(
                    bdid: e['bdid'].toString(),
                    scrollController: ScrollController(debugLabel: e['bdid'].toString()),
                    key: GlobalKey(debugLabel: e['bdid'].toString()),
                  ))
              .toList(),
          controller: _tabController,
        )),
      ],
    );
  }
}
