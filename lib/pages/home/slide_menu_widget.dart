import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/11/21 4:40 PM

class SlideMenuWidget extends StatelessWidget {
  const SlideMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            child: Center(
              child: DrawerHeader(
                  child: CircleAvatar(
                    child: Text('吴'),
                  )),
            ),
          ),
          CustomListItem(
            title: Text('设置'),
            leading: Icon(Icons.settings),
            onTap: () {
              Get.toNamed('/setting');
            },
          ),
          CustomListItem(
            title: Text('关于我们'),
            leading: Icon(Icons.info_outline),
            onTap: () {
              Get.toNamed('/about-us');
            },
          ),
        ],
      ),
    );
  }
}

