import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/style.dart';
import '../data/coordonnees_iata.dart';
import '../model/vol.dart';
import '../model/trajet.dart';

class DetailsVol extends StatelessWidget {
  const DetailsVol({super.key, this.vol, this.trajet});

  final Vol? vol;
  final Trajet? trajet;

  String _toNombre(int value) {
    return value.toString().padLeft(2, '0');
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Non renseignee';
    }
    return "${_toNombre(dateTime.day)}/${_toNombre(dateTime.month)}/${dateTime.year}  ${_toNombre(dateTime.hour)}:${_toNombre(dateTime.minute)}";
  }

  double _zoomRoute(List<LatLng> coords) {
    if (coords.isEmpty) return 3.0;
    if (coords.length == 1) return 7.0;

    final bounds = LatLngBounds.fromPoints(coords);
    final distance = const Distance().as(LengthUnit.Kilometer, bounds.southWest, bounds.northEast);

    if (distance > 10000) return 2.5;
    if (distance > 7000) return 3.0;
    if (distance > 4000) return 3.5;
    if (distance > 2500) return 4.2;
    if (distance > 1200) return 5.0;
    if (distance > 600) return 5.8;
    if (distance > 250) return 6.5;
    return 7.2;
  }

  LatLng _formaterCoordonnees(String iata, LatLng fallback) {
    return coordonneesIata[iata.toUpperCase()] ?? fallback;
  }

  Widget _marqueurAeroport(String code, bool estDepart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppStyle.surfaceAlt,
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
            estDepart ? Icons.flight_takeoff : Icons.flight_land,
            size: 16,
            color: AppStyle.bleuVol,
          ),
          const SizedBox(width: 4),
          Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppStyle.texteFonce,
            ),
          ),
        ],
      ),
    );
  }

  Widget _carteTrajet() {
    if (trajet == null || trajet!.vols.isEmpty) {
      return const SizedBox.shrink();
    }

    final vols = trajet!.vols;
    final coords = <LatLng>[];
    final markers = <Marker>[];

    for (int i = 0; i < vols.length; i++) {
      final v = vols[i];
      final depart = _formaterCoordonnees(v.departIATA, const LatLng(48.8566, 2.3522));
      final arrivee = _formaterCoordonnees(v.arriverIATA, const LatLng(45.7640, 4.8357));

      if (i == 0) {
        coords.add(depart);
        markers.add(
          Marker(
            point: depart,
            width: 50,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: AppStyle.bleuVol,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Color(0x44000000), blurRadius: 6, offset: Offset(0, 2))
                ],
              ),
              child: const Icon(Icons.flight_takeoff, color: AppStyle.grisNuage, size: 28),
            ),
          ),
        );
      }

      coords.add(arrivee);

      if (i == vols.length - 1) {
        markers.add(
          Marker(
            point: arrivee,
            width: 50,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: AppStyle.vertArrivee,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Color(0x44000000), blurRadius: 6, offset: Offset(0, 2))
                ],
              ),
              child: const Icon(Icons.flight_land, color: AppStyle.grisNuage, size: 28),
            ),
          ),
        );
      } else {
        markers.add(
          Marker(
            point: arrivee,
            width: 50,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: AppStyle.orangeEscale,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Color(0x44000000), blurRadius: 6, offset: Offset(0, 2))
                ],
              ),
              child: const Icon(Icons.flight, color: AppStyle.grisNuage, size: 24),
            ),
          ),
        );
      }
    }

    final zoomFit = _zoomRoute(coords);

    return Container(
      width: double.infinity,
      height: 300,
      decoration: AppStyle.cartePrincipale,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(AppStyle.filtreBleuNuit, BlendMode.color),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLngBounds.fromPoints(coords).center,
              initialZoom: zoomFit,
              minZoom: zoomFit - 0.5,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'fr.iut.sae.flutter',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: coords,
                    strokeWidth: 2.5,
                    color: AppStyle.cyanRadar,
                    pattern: StrokePattern.dotted(),
                  ),
                ],
              ),
              MarkerLayer(markers: markers),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carteSegment(LatLng depart, LatLng arrivee) {
    final center = LatLng(
      (depart.latitude + arrivee.latitude) / 2,
      (depart.longitude + arrivee.longitude) / 2,
    );
    final zoomFit = _zoomRoute([depart, arrivee]);

    return Container(
      decoration: AppStyle.cartePrincipale,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(AppStyle.filtreBleuNuit, BlendMode.color),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: zoomFit,
              minZoom: zoomFit - 0.5,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'fr.iut.sae.flutter',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [depart, arrivee],
                    strokeWidth: 3,
                    color: AppStyle.bleuVol,
                    pattern: StrokePattern.dotted(),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: depart,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppStyle.bleuVol,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Color(0x44000000), blurRadius: 6, offset: Offset(0, 2))
                        ],
                      ),
                      child: const Icon(Icons.flight_takeoff, color: AppStyle.grisNuage, size: 28),
                    ),
                  ),
                  Marker(
                    point: arrivee,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppStyle.vertArrivee,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Color(0x44000000), blurRadius: 6, offset: Offset(0, 2))
                        ],
                      ),
                      child: const Icon(Icons.flight_land, color: AppStyle.grisNuage, size: 28),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _pagesCartesTrajet(BuildContext context) {
    if (trajet == null || trajet!.vols.isEmpty) {
      return [];
    }

    final pages = <Widget>[];

    pages.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vue globale',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppStyle.texteSecondaire,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _carteTrajet(),
            ),
          ),
        ],
      ),
    );

    for (int i = 0; i < trajet!.vols.length; i++) {
      final v = trajet!.vols[i];
      final depart = _formaterCoordonnees(v.departIATA, const LatLng(48.8566, 2.3522));
      final arrivee = _formaterCoordonnees(v.arriverIATA, const LatLng(45.7640, 4.8357));

      pages.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Segment ${i + 1}/${trajet!.vols.length}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppStyle.texteSecondaire,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _carteSegment(depart, arrivee),
              ),
            ),
          ],
        ),
      );
    }

    return pages;
  }

  Widget _carteVol() {
    final depart = _formaterCoordonnees(vol!.departIATA, const LatLng(48.8566, 2.3522));
    final arrivee = _formaterCoordonnees(vol!.arriverIATA, const LatLng(45.7640, 4.8357));
    final center = LatLng(
      (depart.latitude + arrivee.latitude) / 2,
      (depart.longitude + arrivee.longitude) / 2,
    );
    final zoomFit = _zoomRoute([depart, arrivee]);

    return Container(
      width: double.infinity,
      height: 400,
      decoration: AppStyle.cartePrincipale,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(AppStyle.filtreBleuNuit, BlendMode.color),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: zoomFit,
              minZoom: zoomFit - 0.5,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'fr.iut.sae.flutter',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [depart, arrivee],
                    strokeWidth: 4,
                    color: AppStyle.bleuVol,
                    pattern: StrokePattern.dotted(),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: depart,
                    width: 90,
                    height: 40,
                    child: _marqueurAeroport(vol!.departIATA, true),
                  ),
                  Marker(
                    point: arrivee,
                    width: 90,
                    height: 40,
                    child: _marqueurAeroport(vol!.arriverIATA, false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tuileInfo(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppStyle.fondInfo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x180F4C81)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppStyle.etiquetteInfo),
          const SizedBox(height: 4),
          Text(value, style: AppStyle.valeurInfo),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (trajet != null) {
      final mapPages = _pagesCartesTrajet(context);

      return Scaffold(
        backgroundColor: AppStyle.fondPageHaut,
        appBar: AppBar(
          title: Text('Trajet ${trajet!.departIATA} -> ${trajet!.arriverIATA}'),
          backgroundColor: AppStyle.bleuVol,
          foregroundColor: AppStyle.grisNuage,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppStyle.fondDetailsGradient),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Itineraire', style: AppStyle.titreSection),
                const SizedBox(height: 10),
                SizedBox(
                  height: 400,
                  child: PageView(children: mapPages),
                ),
                const SizedBox(height: 16),
                Text('Details des segments', style: AppStyle.titreSection),
                const SizedBox(height: 10),
                ...List.generate(trajet!.vols.length, (index) {
                  final v = trajet!.vols[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: AppStyle.carteSecondaire,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: AppStyle.badgeFond,
                              child: Text('Vol ${index + 1}', style: AppStyle.badgeTexte),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                v.compagnie,
                                style: AppStyle.titreCarteVol,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _tuileInfo('Depart', '${v.departIATA} - Terminal ${v.terminalDep ?? '-'}'),
                        _tuileInfo('Arrivee', '${v.arriverIATA} - Terminal ${v.terminalArr ?? '-'}'),
                        _tuileInfo('Date depart', _formatDate(v.dateheureDep)),
                        _tuileInfo('Date arrivee', _formatDate(v.dateheureArr)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Vol N° ${vol!.numVol}'),
        backgroundColor: AppStyle.bleuVol,
        foregroundColor: AppStyle.grisNuage,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyle.fondDetailsGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _carteVol(),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: AppStyle.carteSecondaire,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Compagnie', style: AppStyle.titreSection),
                    const SizedBox(height: 6),
                    Text(vol!.compagnie, style: AppStyle.titreCompagnie),
                    const SizedBox(height: 12),
                    _tuileInfo('Depart', '${vol!.departIATA} - Terminal ${vol!.terminalDep ?? '-'}'),
                    _tuileInfo('Arrivee', '${vol!.arriverIATA} - Terminal ${vol!.terminalArr ?? '-'}'),
                    _tuileInfo('Date depart', _formatDate(vol!.dateheureDep)),
                    _tuileInfo('Date arrivee', _formatDate(vol!.dateheureArr)),
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
