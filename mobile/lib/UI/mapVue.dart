import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../theme/style.dart';
import '../viewmodels/volViewModel.dart';
import '../data/coordonnees_iata.dart';
import 'DetailsVol.dart';

class MapVue extends StatelessWidget {
  const MapVue({super.key});

  @override
  Widget build(BuildContext context) {
    final volViewModel = context.watch<VolViewModel>();
    final Set<String> aeroportsAvecArrivees =
        volViewModel.vols.map((v) => v.arriverIATA.toUpperCase()).toSet();

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: AppStyle.cartePrincipale,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(AppStyle.filtreBleuNuit, BlendMode.color),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(48.8566, 2.3522),
              initialZoom: 3,
              minZoom: 2,
              maxZoom: 10,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.app',
                tileDisplay: const TileDisplay.fadeIn(),
              ),
              MarkerLayer(
                markers: coordonneesIata.entries.map((entry) {
                  final codeIata = entry.key.toUpperCase();
                  final aDesVolsVersCetAeroport = aeroportsAvecArrivees.contains(codeIata);
                  return Marker(
                    point: entry.value,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showFlightsFromAirport(context, codeIata),
                      child: Icon(
                        Icons.location_on,
                        color: aDesVolsVersCetAeroport
                            ? AppStyle.ambreCrepuscule
                            : const Color(0xFF6B7E95),
                        size: aDesVolsVersCetAeroport ? 35 : 24,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFlightsFromAirport(BuildContext context, String iata) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final flights = context.read<VolViewModel>().vols.where((v) => v.arriverIATA == iata).toList();

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF8FA5BD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text('Arrivees vers $iata', style: AppStyle.airportShortName),
              const SizedBox(height: 16),
              if (flights.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Aucun vol trouve vers cet aeroport'),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final vol = flights[index];
                      return ListTile(
                        leading: const Icon(Icons.flight),
                        title: Text(vol.compagnie),
                        subtitle: Text('Depuis ${vol.departIATA} • Vol ${vol.numVol}'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsVol(vol: vol)),
                          );
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
