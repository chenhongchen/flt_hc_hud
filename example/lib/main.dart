import 'package:flt_hc_hud/flt_hc_hud.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HCHud(
        child: Page(_platformVersion),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String platformVersion;
  Page(this.platformVersion);
  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [];
    for (int i = 0; i < 10; i++) {
      childs.add(HCHud(
        height: 200,
        child: ListCell(i),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        children: childs,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onTapBtn(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  _onTapBtn(BuildContext context) async {
    double y = MediaQuery.of(context).padding.top + 55;
    HCHud.of(context).showCustomHudView(
      animated: true,
      y: y,
      hudView: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(child: Image.asset('images/list.png')),
          ],
        ),
      ),
    );
//    HCHud.of(context).showCustomHudViewAndDismiss(
//        animated: false,
//        y: MediaQuery.of(context).padding.top + 64,
//        hudView: Container(
//          width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
//          child: Image.asset('images/list.png'),
//        ));
//    HCHud.of(context).showLoading(text: '', enable: false);
//    Future.delayed(Duration(milliseconds: 500), () {
//      HCHud.of(context).dismiss();
//    });
    await Future.delayed(Duration(seconds: 2));
//    HCHud.of(context).showErrorAndDismiss(text: '加载数据异常');
    HCHud.of(context).dismiss(animated: false);
  }
}

class ListCell extends StatelessWidget {
  final int index;
  ListCell(this.index);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('tap list ----------');
        int i = index % 2;
        int showMilliseconds = (i == 0 ? 2000 : 4000);
        HCHud.of(context).showTextAndDismiss(
          enable: true,
          text:
              '点击 $index cell 显示${showMilliseconds / 1000}消失\n的的地方就搞得阿卡丽就发流口水的积分卡介绍分类会计法上来的放进来会计法',
          showMilliseconds: showMilliseconds,
        );
      },
      child: Container(
        color: Colors.transparent,
        height: 200,
        child: Center(
          child: Text('第 $index 行 数据'),
        ),
      ),
    );
  }
}
