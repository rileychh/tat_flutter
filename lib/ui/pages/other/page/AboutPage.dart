import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/R.dart';
import 'package:flutter_app/src/version/APPVersion.dart';
import 'package:flutter_app/src/version/update/AppUpdate.dart';
import 'package:flutter_app/ui/other/ListViewAnimator.dart';
import 'package:flutter_app/ui/other/MyPageTransition.dart';
import 'package:flutter_app/ui/other/MyToast.dart';
import 'package:flutter_app/ui/pages/other/page/ContributorsPage.dart';
import 'package:flutter_app/ui/pages/other/page/PrivacyPolicyPage.dart';

enum onListViewPress { AppUpdate, Contribution, PrivacyPolicy, Version }

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<Map> listViewData = List();

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() {
    listViewData = List();
    listViewData.addAll([
      {
        "icon": EvaIcons.refreshOutline,
        "title": R.current.checkVersion,
        "color": Colors.orange,
        "onPress": onListViewPress.AppUpdate
      },
      {
        "icon": EvaIcons.awardOutline,
        "title": R.current.Contribution,
        "color": Colors.lightGreen,
        "onPress": onListViewPress.Contribution
      },
      {
        "icon": EvaIcons.shieldOffOutline,
        "color": Colors.blueGrey,
        "title": R.current.PrivacyPolicy,
        "onPress": onListViewPress.PrivacyPolicy
      },
      {
        "icon": EvaIcons.infoOutline,
        "color": Colors.blue,
        "title": R.current.versionInfo,
        "onPress": onListViewPress.Version
      }
    ]);
  }

  int pressTime = 0;

  void _onListViewPress(onListViewPress value) async {
    switch (value) {
      case onListViewPress.AppUpdate:
        MyToast.show(R.current.checkingVersion);
        bool result = await APPVersion.check(context);
        if (!result) {
          MyToast.show(R.current.isNewVersion);
        }
        break;
      case onListViewPress.Contribution:
        Navigator.of(context).push(MyPage.transition(ContributorsPage()));
        break;
      case onListViewPress.Version:
        String mainVersion = await AppUpdate.getAppVersion();
        if (pressTime == 0) {
          MyToast.show(mainVersion);
        }
        pressTime++;
        Future.delayed(Duration(seconds: 2)).then((_) {
          pressTime = 0;
        });
        break;
      case onListViewPress.PrivacyPolicy:
        Navigator.of(context).push(MyPage.transition(PrivacyPolicyPage()));
        break;
      default:
        MyToast.show(R.current.noFunction);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.current.about),
      ),
      body: ListView.separated(
        itemCount: listViewData.length,
        itemBuilder: (context, index) {
          Widget widget;
          widget = _buildAbout(listViewData[index]);
          return InkWell(
            child: WidgetAnimator(widget),
            onTap: () {
              _onListViewPress(listViewData[index]['onPress']);
            },
          );
        },
        separatorBuilder: (context, index) {
          // 顯示格線
          return Container(
            color: Colors.black12,
            height: 1,
          );
        },
      ),
    );
  }

  Container _buildAbout(Map data) {
    return Container(
      //color: Colors.yellow,
      padding:
          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            data['icon'],
            color: data['color'],
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            data['title'],
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
