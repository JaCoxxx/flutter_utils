import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/local_file_item_model.dart';
import 'package:flutter_utils/pages/file_manger/config/file_manager_config.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';

/// jacokwu
/// 9/14/21 1:42 PM

class FileManagerBottomAction extends StatefulWidget {

  final List<LocalFileItemModel> selectedFileList;

  const FileManagerBottomAction({Key? key, required this.selectedFileList}) : super(key: key);

  @override
  _FileManagerBottomActionState createState() => _FileManagerBottomActionState();
}

class _FileManagerBottomActionState extends State<FileManagerBottomAction> {

  List<PopupMenuItem> get _moreMenuList => [
    PopupMenuItem(
      value: 'zip',
      child: CustomText.title('压缩'),
    ),
    if (widget.selectedFileList.length == 1) PopupMenuItem(
      value: 'rename',
      child: CustomText.title('重命名'),
    ),
    if (widget.selectedFileList.length == 1) PopupMenuItem(
      value: 'detail',
      child: CustomText.title('详情'),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(100),
      color: Constants.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomBtn(Icons.share_outlined, '分享', () {}),
          _buildBottomBtn(Icons.file_copy_outlined, '复制', () {}),
          _buildBottomBtn(Icons.drive_file_move_outline, '移动', () {}),
          _buildBottomBtn(Icons.delete_outlined, '删除', () {
            showSimpleAlertDialog(context, title: '是否删除此文件', content: '请谨慎删除文件', showCancel: true, confirmFunc: () {
              showToast('删除成功');
              // _getCurrentDir();
            });
          }),
          PopupMenuButton(
            itemBuilder: (_) {
              return _moreMenuList;
            },
            child: _buildBottomBtn(Icons.more_horiz_outlined, '更多', null),
            offset: Offset(0, -ScreenUtil().setWidth(40 + _moreMenuList.length * 100)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (value) {
              switch(value) {
                case 'detail':
                  FileManagerConfig.showBottomDetailDialog(context, widget.selectedFileList[0]);
                  break;
                default:
                  showToast('暂未开放');
                break;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBtn(IconData iconData, String title, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            CustomText(
              title,
              fontSize: Dimens.font_size_12,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
