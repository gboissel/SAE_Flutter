import 'package:flutter/material.dart';
import './theme/style.dart';
import './UI/volsListeVue.dart';
import './UI/mapVue.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.fondPageHaut,
      appBar: _selectedIndex == 0 ? const HomeAppBar() : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          VolsListeVue(),
          MapVue(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppStyle.bleuHorizon,
        currentIndex: _selectedIndex,
        selectedItemColor: AppStyle.primaryColor,
        unselectedItemColor: AppStyle.texteSecondaire,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flight_takeoff), label: 'Vols'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Carte'),
        ],
      ),
    );
  }
}
