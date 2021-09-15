import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/custom_text.dart';

/// jacokwu
/// 8/16/21 4:36 PM

class NoDataWidget extends StatefulWidget {

  final Widget Function(BuildContext context)? buildImage;

  final String? emptyString;

  const NoDataWidget({Key? key, this.buildImage, this.emptyString}) : super(key: key);

  @override
  _NoDataWidgetState createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            widget.buildImage == null ? Image.asset('assets/images/empty.png', width: ScreenUtil().setWidth(100),) : widget.buildImage!(context),
            Dimens.hGap8,
            CustomText.content(widget.emptyString ?? '没有数据'),
          ],
        ),
      ),
    );
  }
}


