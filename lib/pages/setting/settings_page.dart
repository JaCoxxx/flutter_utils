import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:settings_ui/settings_ui.dart';

GlobalKey<SliderMenuContainerState> _key =
new GlobalKey<SliderMenuContainerState>();

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  // late SimpleHiddenDrawerController controller;

  bool value = false;

  @override
  void didChangeDependencies() {
    // controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: Colors.white,
          key: _key,
          sliderMenuOpenSize: 200,
          title: Text(
            '设置',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState!.closeDrawer();
              setState(() {
                print(title);
              });
            },
          ),
          sliderMain: MainWidget()),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final Function(String)? onItemClick;

  const MenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 60,
              child: Text('吴'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Nick',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem('Home', Icons.home),
          sliderItem('Add Post', Icons.add_circle),
          sliderItem('Notification', Icons.notifications_active),
          sliderItem('Likes', Icons.favorite),
          sliderItem('Setting', Icons.settings),
          sliderItem('LogOut', Icons.arrow_back_ios)
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => ListTile(
      title: Text(
        title,
        style:
        TextStyle(color: Colors.black, fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(
        icons,
        color: Colors.black,
      ),
      onTap: () {
        onItemClick!(title);
      });
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  List<Data> dataList = [];

  @override
  void initState() {
    super.initState();
    dataList.add(Data(Colors.amber, 'Amelia Brown',
        'Life would be a great deal easier if dead things had the decency to remain dead.'));
    dataList.add(Data(Colors.orange, 'Olivia Smith',
        'That proves you are unusual," returned the Scarecrow'));
    dataList.add(Data(Colors.deepOrange, 'Sophia Jones',
        'Her name badge read: Hello! My name is DIE, DEMIGOD SCUM!'));
    dataList.add(Data(Colors.red, 'Isabella Johnson',
        'I am about as intimidating as a butterfly.'));
    dataList.add(Data(Colors.purple, 'Emily Taylor',
        'Never ask an elf for help; they might decide your better off dead, eh?'));
    dataList.add(Data(Colors.green, 'Maya Thomas', 'Act first, explain later'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ListView.separated(
          scrollDirection: Axis.vertical,
          //   physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemBuilder: (builder, index) {
            return LimitedBox(
              maxHeight: 150,
              child: Container(
                decoration: new BoxDecoration(
                    color: dataList[index].color,
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(10.0),
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        dataList[index].name,
                        style: TextStyle(
                            fontFamily: 'BalsamiqSans_Blod',
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        dataList[index].detail,
                        style: TextStyle(
                            fontFamily: 'BalsamiqSans_Regular',
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (builder, index) {
            return Divider(
              height: 10,
              thickness: 0,
            );
          },
          itemCount: dataList.length),
    );
  }
}

class Data {
  MaterialColor color;
  String name;
  String detail;

  Data(this.color, this.name, this.detail);
}
