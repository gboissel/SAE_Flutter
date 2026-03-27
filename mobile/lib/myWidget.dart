import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import './style.dart';
import './viewmodels/volViewModel.dart';
import './UI/DetailsVol.dart';
import './data/coordonnees_iata.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _selectedIndex = 0;
  final VolViewModel _volViewModel = VolViewModel();

  @override
  void initState() {
    super.initState();
    _volViewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    _volViewModel.removeListener(_onViewModelChange);
    _volViewModel.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _selectedIndex == 0 ? _buildHomeAppBar() : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          _buildMapTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flight_takeoff), label: 'Vols'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Carte'),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 32),
          children: [
            TextSpan(text: "Flight", style: AppStyle.titleLight),
            TextSpan(text: "Search", style: AppStyle.titleBold),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStopOption("TOUS", StopType.all),
                _buildStopOption("DIRECT", StopType.zero),
                _buildStopOption("1 ESCALE", StopType.one),
                _buildStopOption("2 ESCALES", StopType.two),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStopOption(String label, StopType type) {
    bool isSelected = _volViewModel.selectedStop == type;
    return GestureDetector(
      onTap: () => _volViewModel.setStopType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppStyle.stopSelectorText.copyWith(
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    if (_volViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_volViewModel.vols.isEmpty) {
      return const Center(child: Text("Aucun vol trouvé pour cette sélection"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _volViewModel.vols.length,
      itemBuilder: (context, index) {
        final vol = _volViewModel.vols[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: AppStyle.flightCardDecoration,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsVol(vol: vol)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      _buildAirportInfo(vol.departIATA, "Départ", CrossAxisAlignment.start),
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(Icons.flight_takeoff, color: Colors.blue, size: 20),
                            const SizedBox(height: 4),
                            Container(height: 1, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 10)),
                            const SizedBox(height: 4),
                            Text(vol.compagnie, style: AppStyle.airportLongName),
                          ],
                        ),
                      ),
                      _buildAirportInfo(vol.arriverIATA, "Arrivée", CrossAxisAlignment.end),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAirportInfo(String code, String label, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(code, style: AppStyle.airportCode),
        Text(label, style: AppStyle.airportLongName),
      ],
    );
  }

  Widget _buildMapTab() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(48.8566, 2.3522),
        initialZoom: 3,
        minZoom: 2, // Empêche de trop dézoomer
        maxZoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          // Empêche la répétition du monde sur les côtés
          tileDisplay: const TileDisplay.fadeIn(),
        ),
        MarkerLayer(
          markers: coordonneesIata.entries.map((entry) {
            bool isDestination = _volViewModel.destinations.contains(entry.key);
            return Marker(
              point: entry.value,
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showFlightsFromAirport(entry.key),
                child: Icon(
                  Icons.location_on,
                  color: isDestination ? Colors.green : Colors.red,
                  size: isDestination ? 35 : 25,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showFlightsFromAirport(String iata) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final flights = _volViewModel.vols.where((v) => v.departIATA == iata).toList();

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text("Départs de $iata", style: AppStyle.airportShortName),
              const SizedBox(height: 16),
              if (flights.isEmpty)
                const Padding(padding: EdgeInsets.all(20), child: Text("Aucun vol trouvé au départ de cet aéroport"))
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final vol = flights[index];
                      return ListTile(
                        leading: const Icon(Icons.flight),
                        title: Text("${vol.compagnie}"),
                        subtitle: Text("Vers ${vol.arriverIATA} • Vol ${vol.numVol}"),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsVol(vol: vol)));
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
