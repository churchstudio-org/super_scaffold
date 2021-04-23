import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:super_scaffold/super_scaffold_controller.dart';
import 'package:super_scaffold/super_state.dart';

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
  SuperScaffoldController controller = SuperScaffoldController();
  ISuperState? page;

  @override
  void initState() {
    super.initState();

    page = context.findAncestorStateOfType<ISuperState>();
    
    if (page != null) {
      page!.scaffold = controller;
    }
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
      body: _buildBody(),
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

  Widget _buildBody() {
    return Stack(
      children: [
        widget.body ?? SizedBox(),
        _buildConfirmationDialog(),
        _buildPromiseWaiting(),
      ],
    );
  }

  Widget _buildConfirmationDialog() {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.waitingConfirmation, 
      builder: (context, value, child) => value
        ? GestureDetector(
          onTap: controller.cancelConfirmation,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32.0,
            ),
            alignment: Alignment.center,
            color: Colors.black38,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 8.0,
              ),
              constraints: BoxConstraints(
                maxWidth: 512,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.confirmationMessage!),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: controller.cancelConfirmation,
                        child: Text("Cancelar"),
                      ),
                      RaisedButton(
                        onPressed: controller.acceptConfirmation,
                        child: Text("Continuar"),
                      ),
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        )
        : SizedBox()
      ,
    );
  }

  Widget _buildPromiseWaiting() {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isLoading, 
      builder: (context, value, child) => value
        ? Container(
          color: Colors.black38,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          ),
        )
        : SizedBox()
      ,
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