import 'package:flutter/material.dart';

const Color _defaultColor = Color(0xffeeeeee);

class CustomDivider extends StatelessWidget {

  CustomDivider({
    this.type = DividerType.horizontal,
    this.size = 1,
    this.color = _defaultColor,
  });

  final DividerType? type;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (type == DividerType.vertical) {
      return SizedBox(
        width: size,
        child: Container(
          color: color,
        ),
      );
    }
    return SizedBox(
      height: size,
      child: Container(
        color: color,
      ),
    );
  }

}

enum DividerType {
  horizontal,
  vertical
}