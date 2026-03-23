import 'package:flutter/material.dart';
import 'myWidget.dart';

void main() {
  runApp( MyTD2());
}

class MyTD2 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
          return MaterialApp(
              title: 'TD2',
              home:  MyWidget()
          );
  }
}