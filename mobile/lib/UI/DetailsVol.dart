import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/coordonnees_iata.dart';
import '../model/vol.dart';

class DetailsVol extends StatelessWidget {
  const DetailsVol({super.key, required this.vol});

  final Vol vol;

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Non renseignée';
    }
    return "${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year}  ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
  }

  LatLng _resolveCoordinates(String iata, LatLng fallback) {
    return coordonneesIata[iata.toUpperCase()] ?? fallback;
  }

  Widget _airportMarker(String code, bool isDeparture) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDeparture ? Icons.flight_takeoff : Icons.flight_land,
            size: 16,
            color: const Color(0xFF0F4C81),
          ),
          const SizedBox(width: 4),
          Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _flightMap() {
    final departure = _resolveCoordinates(vol.departIATA, const LatLng(48.8566, 2.3522));
    final arrival = _resolveCoordinates(vol.arriverIATA, const LatLng(45.7640, 4.8357));
    final center = LatLng(
      (departure.latitude + arrival.latitude) / 2,
      (departure.longitude + arrival.longitude) / 2,
    );

    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 4.6,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom |
                  InteractiveFlag.drag |
                  InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'fr.iut.sae.flutter',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [departure, arrival],
                  strokeWidth: 4,
                  color: const Color(0xFF0F4C81),
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: departure,
                  width: 90,
                  height: 40,
                  child: _airportMarker(vol.departIATA, true),
                ),
                Marker(
                  point: arrival,
                  width: 90,
                  height: 40,
                  child: _airportMarker(vol.arriverIATA, false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vol N° ${vol.numVol}'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _flightMap(),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vol.compagnie,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F4C81),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoTile('Départ', '${vol.departIATA} - Terminal ${vol.terminalDep ?? '-'}'),
                    _infoTile('Arrivée', '${vol.arriverIATA} - Terminal ${vol.terminalArr ?? '-'}'),
                    _infoTile('Date départ', _formatDate(vol.dateheureDep)),
                    _infoTile('Date arrivée', _formatDate(vol.dateheureArr)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
