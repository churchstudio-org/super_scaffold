import 'dart:async';

import 'package:example/pages/tabbed_page.dart';
import 'package:flutter/material.dart';
import 'package:super_scaffold/super_scaffold_widget.dart';
import 'package:super_scaffold/super_state.dart';

import 'components/custom_drawer.dart';

void main() {
  runApp(MaterialApp(
    home: Example(),
  ));
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends SuperState<Example> {
  Widget _buildBody() {
    return ListView(
      children: [
        ListTile(
          title: Text("Push page with TabBar"),
          subtitle: Text("The AppBar is fixed on top of screen"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TabbedPage()
            )
          ),
        ),
        ListTile(
          title: Text("Show confirmation dialog"),
          subtitle: Text("Confirm and show loading"),
          onTap: () async {
            bool ok = await scaffold!.confirm("Do you want to continue?");

            if (ok) {
              Completer loading = scaffold!.wait();

              await Future.delayed(Duration(milliseconds: 1500));

              loading.complete();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {    
    return SuperScaffold(
      appBar: OrientationBuilder(
        builder: (context, _) => Hero(
          tag: "appbar",
          child: AppBar(
            title: Text("Main Page"),
            leading: 
              MediaQuery.of(context).orientation == Orientation.portrait
              ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
              : null
            ,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          Completer wait = scaffold!.wait();
            
          await Future.delayed(Duration(milliseconds: 3000));
          
          wait.complete();
        },
      ),
    );
  }
}