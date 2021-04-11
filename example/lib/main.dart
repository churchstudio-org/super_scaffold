import 'package:example/pages/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Example());
}

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}