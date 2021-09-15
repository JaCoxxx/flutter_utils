import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';

/// jacokwu
/// 8/27/21 4:16 PM

class CustomText extends StatelessWidget {
  final String? data;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;

  const CustomText(this.data, {Key? key, this.color, this.fontWeight, this.fontSize}) : super(key: key);

  factory CustomText.title(
    String? data, {
    Key? key,
    double fontSize,
  }) = _CustomTextTitle;

  factory CustomText.content(
    String? data, {
    Key? key,
    double fontSize,
  }) = _CustomTextContent;

  factory CustomText.bold(
    String? data, {
    Key? key,
    Color color,
    double? fontSize,
  }) = _CustomTextBold;

  @override
  Widget build(BuildContext context) {
    return Text(
      data ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

class _CustomTextTitle extends CustomText {
  const _CustomTextTitle(
    String? data, {
    Key? key,
    double fontSize = Dimens.font_size_16,
  }) : super(
          data,
          key: key,
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        );
}

class _CustomTextContent extends CustomText {
  const _CustomTextContent(
    String? data, {
    Key? key,
    double fontSize = Dimens.font_size_14,
  }) : super(
          data,
          key: key,
          color: Constants.gray_9,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        );
}

class _CustomTextBold extends CustomText {
  const _CustomTextBold(
    String? data, {
    Key? key,
    Color color = Colors.black,
    double? fontSize,
  }) : super(
          data,
          key: key,
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        );
}
