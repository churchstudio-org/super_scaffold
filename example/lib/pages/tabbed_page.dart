import 'package:example/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:super_scaffold/super_scaffold.dart';

class TabbedPage extends StatefulWidget {
  @override
  _TabbedPageState createState() => _TabbedPageState();
}

class _TabbedPageState extends SuperState<TabbedPage> {
  @override
  int get tabsLength => 3;

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      appBar: Hero(
        tag: "appbar",
        child: AppBar(
          title: Text("Tabbed Page"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: Navigator.of(context).pop,
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                child: Text("Tab 1"),
              ),
              Tab(
                child: Text("Tab 2"),
              ),
              Tab(
                child: Text("Tab 3"),
              )
            ],
          ),
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}