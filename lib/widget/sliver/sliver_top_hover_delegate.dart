import 'package:flutter/material.dart';

/// jacokwu
/// 8/26/21 4:08 PM

class SliverTopHoverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  final double childMaxExtent;
  final double childMinExtent;

  SliverTopHoverDelegate({
    required this.child,
    required this.childMaxExtent,
    required this.childMinExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(child: this.child, color: Colors.transparent,);
  }

  @override
  double get maxExtent => this.childMaxExtent;

  @override
  double get minExtent => this.childMinExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
