import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/local_file_item_model.dart';
import 'package:flutter_utils/pages/file_manger/config/file_manager_config.dart';
import 'package:flutter_utils/utils/dialog_utils.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

/// jacokwu
/// 9/14/21 1:42 PM

class FileManagerBottomAction extends StatefulWidget {
  final List<LocalFileItemModel> selectedFileList;

  final VoidCallback refresh;

  const FileManagerBottomAction({Key? key, required this.selectedFileList, required this.refresh}) : super(key: key);

  @override
  _FileManagerBottomActionState createState() => _FileManagerBottomActionState();
}

class _FileManagerBottomActionState extends State<FileManagerBottomAction> {
  List<PopupMenuItem> get _moreMenuList => [
        PopupMenuItem(
          value: 'zip',
          child: CustomText.title('压缩'),
        ),
        if (widget.selectedFileList.length == 1)
          PopupMenuItem(
            value: 'rename',
            child: CustomText.title('重命名'),
          ),
        if (widget.selectedFileList.length == 1)
          PopupMenuItem(
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
          _buildBottomBtn(Icons.share_outlined, '分享', () {
            if (widget.selectedFileList.every((element) => element.isFolder == false)) {
              Share.shareFiles(widget.selectedFileList.map((e) => e.file.path).toList());
            } else {
              showToast('暂不支持文件夹分享');
            }
          }, disabled: widget.selectedFileList.length == 0),
          _buildBottomBtn(Icons.file_copy_outlined, '复制', () {
            showToast('开发中...');
          }, disabled: widget.selectedFileList.length == 0),
          _buildBottomBtn(Icons.drive_file_move_outline, '移动', () {
            showToast('开发中...');
          }, disabled: widget.selectedFileList.length == 0),
          if(widget.selectedFileList.length > 0) _buildBottomBtn(Icons.delete_outlined, '删除', () {
            showSimpleAlertDialog(context,
                title: widget.selectedFileList.length == 1 ? '是否删除此文件' : '是否删除 ${widget.selectedFileList.length} 项文件',
                content: '请谨慎删除文件',
                showCancel: true, confirmFunc: () {
              widget.selectedFileList.forEach((element) {
                element.file.deleteSync(recursive: true);
              });
              widget.refresh();
              showToast('删除成功');
              // _getCurrentDir();
            });
          }),
          if(widget.selectedFileList.length > 0) PopupMenuButton(
            itemBuilder: (_) {
              return _moreMenuList;
            },
            child: _buildBottomBtn(Icons.more_horiz_outlined, '更多', null),
            offset: Offset(0, -ScreenUtil().setWidth(40 + _moreMenuList.length * 100)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (value) {
              switch (value) {
                case 'detail':
                  FileManagerConfig.showBottomDetailDialog(context, widget.selectedFileList[0]);
                  break;
                case 'rename':
                  TextEditingController _controller = TextEditingController();
                  showBottomInputDialog(context,
                      title: '重命名',
                      initialValue: widget.selectedFileList[0].fileName,
                      controller: _controller, onConfirm: (value) {
                    print(value);
                    LocalFileItemModel itemModel = widget.selectedFileList[0];
                    if (itemModel.isFolder) {
                      itemModel.file.renameSync('${itemModel.file.parent.path}/$value');
                      showToast('重命名成功');
                      Get.back();
                      widget.refresh();
                    } else {
                      if (getFileSuffix(value) != itemModel.suffix) {
                        showSimpleAlertDialog(context, content: '如果改变文件扩展名，可能会导致文件不可用，是否更改？', showCancel: true,
                            cancelFunc: () {
                          _controller.text = itemModel.fileName;
                        }, confirmFunc: () {
                          itemModel.file.renameSync('${itemModel.file.parent.path}/$value');
                          showToast('重命名成功');
                          Get.back();
                          widget.refresh();
                        });
                      } else {
                        itemModel.file.renameSync('${itemModel.file.parent.path}/$value');
                        showToast('重命名成功');
                        Get.back();
                        widget.refresh();
                      }
                    }
                  });
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

  Widget _buildBottomBtn(IconData iconData, String title, VoidCallback? onTap, {
    bool disabled = false
}) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Card(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: disabled ? Constants.gray_c : Colors.black,),
            CustomText(
              title,
              fontSize: Dimens.font_size_12,
              color: disabled ? Constants.gray_c : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
