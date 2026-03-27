import 'package:flutter/material.dart';
import 'myWidget.dart';


void main() {
  runApp(const MyTD2());
}

class MyTD2 extends StatelessWidget {
  const MyTD2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TD2',
      home: MyWidget(),
    );
  }
}
