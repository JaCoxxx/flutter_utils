import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/local_file_item_model.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:get/get.dart';

/// jacokwu
/// 9/16/21 10:19 AM

class FileDetailDialogWidget extends StatefulWidget {
  final LocalFileItemModel itemModel;

  const FileDetailDialogWidget({Key? key, required this.itemModel}) : super(key: key);

  @override
  _FileDetailDialogWidgetState createState() => _FileDetailDialogWidgetState();
}

class _FileDetailDialogWidgetState extends State<FileDetailDialogWidget> {
  late List<Map<String, dynamic>> detailList;

  int _fileSize = 0;
  String get fileSize => bytesToSize(_fileSize);

  bool _isDispose = false;

  @override
  void initState() {
    super.initState();
    _fileSize = 0;
    _isDispose = false;
    detailList = [
      {
        'title': widget.itemModel.isFolder ? '文件夹名称:' : '文件名称:',
        'content': widget.itemModel.fileName,
      },
      {
        'title': widget.itemModel.isFolder ? '文件夹大小:' : '文件大小:',
        'content': fileSize,
      },
      {
        'title': '修改时间:',
        'content': widget.itemModel.file.statSync().modified.toString().split('.')[0],
      },
      {
        'title': '路径:',
        'content': widget.itemModel.file.path,
      },
    ];
    _getFileSize();
  }

  _getFileSize() async {
    if (_isDispose) return;
    // 16612433
    _fileSize = await reduce(widget.itemModel.file);
    if (_isDispose) return;
    detailList[1]['content'] = bytesToSize(_fileSize);
    setState(() {});
  }

  /// 递归缓存目录，计算缓存大小
  Future<int> reduce(final FileSystemEntity file) async {
    if (_isDispose) return 0;

    /// 如果是一个文件，则直接返回文件大小
    if (file is File) {
      int length = await file.length();
      if (_isDispose) return 0;
      _fileSize += length;
      detailList[1]['content'] = bytesToSize(_fileSize);
      setState(() {});
      return length;
    }

    /// 如果是目录，则遍历目录并累计大小
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();

      int total = 0;

      if (children.isNotEmpty) for (final FileSystemEntity child in children) total += await reduce(child);

      return total;
    }

    return 0;
  }

  @override
  void dispose() {
    super.dispose();
    _isDispose = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(bottom: Dimens.pd16),
            margin: EdgeInsets.only(
                left: Dimens.pd16, right: Dimens.pd16, bottom: MediaQuery.of(context).padding.bottom + Dimens.pd16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Dimens.pd16, top: Dimens.pd16, bottom: Dimens.pd30),
                  child: CustomText(
                    '详情',
                    fontSize: Dimens.font_size_18,
                  ),
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Dimens.wGap16,
                      SizedBox(
                          width: ScreenUtil().setWidth(widget.itemModel.isFolder ? 150 : 100),
                          child: CustomText.content(detailList[index]['title'])),
                      Dimens.wGap16,
                      Expanded(
                        child: CustomText(
                          detailList[index]['content'],
                          color: Colors.black,
                          fontSize: Dimens.font_size_16,
                          maxLines: 10,
                        ),
                      ),
                      Dimens.wGap16,
                    ],
                  ),
                  separatorBuilder: (_, index) => Dimens.hGap8,
                  itemCount: detailList.length,
                  shrinkWrap: true,
                ),
                Dimens.hGap8,
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: Dimens.pd16),
                    padding: EdgeInsets.symmetric(vertical: Dimens.pd12),
                    alignment: Alignment.center,
                    child: CustomText(
                      '确定',
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
