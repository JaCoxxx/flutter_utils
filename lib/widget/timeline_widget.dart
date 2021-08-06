import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

/// jacokwu
/// 7/30/21 5:01 PM

class TimeLineWidget extends StatelessWidget {
  final List childList;
  final Widget Function(int index, dynamic item)? buildLeft;
  final Widget Function(int index, dynamic item)? buildRight;

  const TimeLineWidget({Key? key, required this.childList, this.buildLeft, this.buildRight,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _color = Color(0xFFBBBBBB);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, index) => TimelineTile(
              hasIndicator: true,
              isFirst: index == 0,
              isLast: index == childList.length - 1,
              axis: TimelineAxis.vertical,
              alignment: TimelineAlign.manual,
              lineXY: buildLeft == null ? 0.03 : 0.2,
              beforeLineStyle: LineStyle(color: _color, thickness: 1),
              afterLineStyle: LineStyle(color: _color, thickness: 1),
              indicatorStyle: IndicatorStyle(
                  color: Color(0xFF28BF93),
                  width: 10,
                  height: 10,
                  padding: EdgeInsets.zero),
              startChild: buildLeft != null ? buildLeft!(index, childList[index]) : null,
              endChild: buildRight != null ? buildRight!(index, childList[index]) : null,
            ),
            itemCount: childList.length,
          ),
        ),
      ],
    );
  }
}
