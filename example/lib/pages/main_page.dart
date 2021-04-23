import 'package:example/components/custom_drawer.dart';
import 'package:example/pages/tabbed_page.dart';
import 'package:flutter/material.dart';
import 'package:super_scaffold/super_scaffold.dart';

class MainPage extends StatefulWidget {  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends SuperState<MainPage> {
  Widget _buildBody() {
    return ListView(
      children: [
        ListTile(
          title: Text("Navigate to tabbed pages"),
          subtitle: Text("Enjoy the hero animation"),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TabbedPage()
            )
          ),
        ),
        ...[
          for (var i = 0; i < 10; i++)
            ListTile(
              title: Text("Title $i"),
              subtitle: Text("Subtitle $i"),
              onTap: () async {
                bool ok = await scaffold!.waitConfirmation("Message $i");
                if (ok) print("Promise $i");
              }
            )
          ,
        ]
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
        child: Icon(Icons.add),
        onPressed: () async {
          bool ok = await scaffold!.waitConfirmation("Do you want to continue?");

          if (ok) {
            scaffold!.showLoading();
            
            await Future.delayed(Duration(milliseconds: 1000));
            
            scaffold!.hideLoading();

            print("Hello World");
          }
        },
      ),
    );
  }
}