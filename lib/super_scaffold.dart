library super_scaffold;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SuperScaffold extends StatefulWidget {
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Widget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Color? drawerScrimColor;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;

  final Future<bool> Function()? onWillPop;

  const SuperScaffold({
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.onWillPop,
  });
  
  @override
  _SuperScaffoldState createState() => _SuperScaffoldState();
}

class _SuperScaffoldState extends State<SuperScaffold> {
  ISuperState? page;

  @override
  void initState() {
    super.initState();
    page = context.findAncestorStateOfType<ISuperState>();
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
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      persistentFooterButtons: widget.persistentFooterButtons,
      drawer: 
        MediaQuery.of(context).orientation == Orientation.portrait
        ? widget.drawer
        : null
      ,
      onDrawerChanged: widget.onDrawerChanged,
      endDrawer: widget.endDrawer,
      onEndDrawerChanged: widget.onEndDrawerChanged,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      drawerScrimColor: widget.drawerScrimColor,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      restorationId: widget.restorationId,
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

mixin SuperStateMixin {
  TabController? tabController;

  int get tabsLength => 0;

  bool get hasTabs => tabsLength > 0;
  
  @protected
  void createTabControllerOfTickerProvider(TickerProvider vsync) {
    if (hasTabs) {
      tabController = TabController(length: tabsLength, vsync: vsync);
    }
  }
}

abstract class ISuperState<T extends StatefulWidget> extends State<T> with SuperStateMixin {
  @override
  void initState();
}

abstract class SuperState<T extends StatefulWidget>
extends State<T>
with SuperStateMixin, TickerProviderStateMixin
implements ISuperState<T> {
  @override
  void initState() {
    super.initState();
    createTabControllerOfTickerProvider(this);
  }
}

abstract class SuperModularState<TWidget extends StatefulWidget, TBind extends Object>
extends ModularState<TWidget, TBind>
with SuperStateMixin, TickerProviderStateMixin
implements ISuperState<TWidget> {
  @override
  void initState() {
    super.initState();
    createTabControllerOfTickerProvider(this);
  }
}