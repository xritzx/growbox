/// Flutter code sample for TabController

// This example shows how to listen to page updates in [TabBar] and [TabBarView]
// when using [DefaultTabController].

import 'package:flutter/material.dart';
import 'pages/indoorModule.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'UrbanFarmer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: UrbanFarmer(),
    );
  }
}

final List<Tab> tabs = <Tab>[
  Tab(
    icon: Icon(Icons.home),
    text: "Indoor Module",
  ),
  Tab(
    icon: Icon(Icons.wb_sunny),
    text: "Outdoor Module",
  ),
];

final List<Widget> widgetTabs = <Widget>[IndoorModule(), IndoorModule()];

class UrbanFarmer extends StatelessWidget {
  UrbanFarmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color.fromARGB(200, 120, 200, 100),
            title: Text("UrbanFarmer"),
            bottom: TabBar(
              tabs: tabs,
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: widgetTabs.map((Widget widget) {
                return Center(
                  child: widget,
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
