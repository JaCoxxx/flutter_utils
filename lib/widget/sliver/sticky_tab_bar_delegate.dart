import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_tab_bar.dart';

/// jacokwu
/// 8/26/21 5:15 PM

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final WTabBar child;
  final Color? backgroundColor;

  StickyTabBarDelegate({required this.child, this.backgroundColor,});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: this.backgroundColor,
      child: this.child,
    );
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
