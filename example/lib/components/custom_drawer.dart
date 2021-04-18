import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: Drawer(
        elevation: 0,
        child: Column(
          children: [
            DrawerHeader(
              child: CircleAvatar(
                radius: 32,
                child: Text("SS"),
              ),
            ),
            ListTile(
              title: Text("Item 1"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Item 2"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Item 3"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Item 4"),
              trailing: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}