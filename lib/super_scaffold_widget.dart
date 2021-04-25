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

  final Widget Function(BuildContext context, String message)? confirmationBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;

  final String confirmationTitle;
  final String positiveConfirmationText;
  final String negativeConfirmationText;

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
    this.confirmationBuilder,
    this.loadingBuilder,
    this.confirmationTitle = "Confirmation",
    this.positiveConfirmationText = "Confirm",
    this.negativeConfirmationText = "Cancel",
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

    controller.waiting.addListener(() {
      if (controller.waiting.value) {
        if (controller.isConfirming) {
          showDialog(
            context: context, 
            builder: (context) => _buildConfirmation(context),
          );
        } else if (controller.isLoading) {
          showDialog(
            context: context, 
            builder: (context) => _buildLoading(context),
          );
        }
      }
    });
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

  Widget _buildConfirmation(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.cancelConfirmation();
        return Future.value(true);
      },
      child: widget.confirmationBuilder != null
        ? widget.confirmationBuilder!(context, controller.confirmationMessage!)
        : AlertDialog(
          title: Text(widget.confirmationTitle),
          content: Text(controller.confirmationMessage!),
          actions: [
            FlatButton(
              child: Text(widget.negativeConfirmationText),
              onPressed: () {
                controller.cancelConfirmation();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(widget.positiveConfirmationText),
              onPressed: () {
                controller.acceptConfirmation();
                Navigator.of(context).pop();
              }
            ),
          ],
        )
      ,
    );
  }

  Widget _buildLoading(BuildContext context) {
    controller
          .loading!
          .future
          .whenComplete(Navigator.of(context).pop);

    return widget.loadingBuilder != null
      ? widget.loadingBuilder!(context)
      : Container(
        color: Colors.black38,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        ),
      )
    ;
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