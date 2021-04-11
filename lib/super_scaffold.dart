library super_scaffold;

import 'package:flutter/material.dart';

class SuperScaffold extends StatefulWidget {
  final Widget? appBar;
  final Drawer? drawer;
  final Widget? body;
  final FloatingActionButton? floatingActionButton;

  final Future<bool> Function()? onWillPop;

  const SuperScaffold({
    this.appBar,
    this.drawer,
    this.body, 
    this.floatingActionButton,
    this.onWillPop,
  });
  
  @override
  _SuperScaffoldState createState() => _SuperScaffoldState();
}

class _SuperScaffoldState extends State<SuperScaffold> with SingleTickerProviderStateMixin {
  SuperScaffoldPage? page;

  @override
  void initState() {
    super.initState();
    page = context.findAncestorStateOfType<SuperScaffoldPage>();
  }
  
  PreferredSize? _buildAppBar() {
    return widget.appBar != null
      ? PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height +
          (page != null && page!.hasTabs ? kToolbarHeight : 0)
        ),
        child: widget.appBar!, 
      )
      : null
    ;
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: 
        MediaQuery.of(context).orientation == Orientation.portrait
        ? widget.drawer
        : null
      ,
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  @override
  Widget build(BuildContext context) {    
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: OrientationBuilder(
        builder: (context, _) => Row(
          children: [
            MediaQuery.of(context).orientation == Orientation.landscape &&
            widget.drawer != null
            ? Hero(
                tag: "super_scaffold_drawer",
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 256,
                  ),
                  child: widget.drawer,
                ),
              )
            : SizedBox(),
            Expanded(
              flex: 6,
              child: _buildScaffold(context),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class SuperScaffoldPage<T extends StatefulWidget> extends State<T> with SingleTickerProviderStateMixin {
  TabController? tabController;

  int get tabsLength => 0;

  bool get hasTabs => tabsLength > 0;

  @override
  void initState() {
    super.initState();

    if (hasTabs) {
      tabController = TabController(length: tabsLength, vsync: this);
    }
  }
}