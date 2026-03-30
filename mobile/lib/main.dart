import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'theme/style.dart';
import 'viewmodels/volViewModel.dart';


void main() {
  runApp(const MyTD2());
}

class MyTD2 extends StatelessWidget {
  const MyTD2({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VolViewModel(),
      child: MaterialApp(
        title: 'TD2',
        debugShowCheckedModeBanner: false,
        theme: AppStyle.themeLight,
        home: const Home(),
      ),
    );
  }
}
