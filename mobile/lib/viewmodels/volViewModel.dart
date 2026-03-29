import 'package:flutter/foundation.dart';
import '../api/api.dart';
import '../model/vol.dart';
import '../model/trajet.dart';

enum StopType { zero, one, two, all }

class VolViewModel extends ChangeNotifier {
  final MyAPI _api = MyAPI();

  List<Vol> _allVols = [];
  List<Trajet> _trajets = [];
  List<String> _destinations = [];
  bool _isLoading = false;
  StopType _selectedStop = StopType.all;

  List<Vol> get vols => _allVols;
  List<Trajet> get trajets => _trajets;
  List<String> get destinations => _destinations;
  bool get isLoading => _isLoading;
  StopType get selectedStop => _selectedStop;

  VolViewModel() {
    loadData();
  }

  void setStopType(StopType type) {
    _selectedStop = type;
    _computeTrajets();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allVols = await _api.getVol();
      _computeTrajets();
    } catch (e) {
      _allVols = [];
      _trajets = [];
      _destinations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _computeTrajets() {
    _trajets = [];
    _destinations = [];

    if (_allVols.isEmpty) {
      notifyListeners();
      return;
    }

    final List<Vol> volsDeDepart = List<Vol>.from(_allVols);

    final Map<String, List<Vol>> volsParDepart = {};
    for (final vol in _allVols) {
      volsParDepart.putIfAbsent(vol.departIATA, () => []).add(vol);
    }

    final Set<String> dejaVu = <String>{};

    void ajouterTrajet(List<Vol> volsTrajet) {
      final cle = volsTrajet
          .map((v) => '${v.compagnie}-${v.numVol}-${v.dateheureDep.toIso8601String()}')
          .join('|');
      if (!dejaVu.contains(cle)) {
        dejaVu.add(cle);
        _trajets.add(Trajet(List<Vol>.from(volsTrajet)));
      }
    }

    if (_selectedStop == StopType.zero || _selectedStop == StopType.all) {
      for (final v1 in volsDeDepart) {
        ajouterTrajet([v1]);
      }
    }

    if (_selectedStop == StopType.one || _selectedStop == StopType.all) {
      for (final v1 in volsDeDepart) {
        if (v1.dateheureArr == null) continue;
        final suivants = volsParDepart[v1.arriverIATA] ?? const <Vol>[];
        for (final v2 in suivants) {
          if (v2.dateheureDep.isAfter(v1.dateheureArr!)) {
            ajouterTrajet([v1, v2]);
          }
        }
      }
    }

    if (_selectedStop == StopType.two || _selectedStop == StopType.all) {
      for (final v1 in volsDeDepart) {
        if (v1.dateheureArr == null) continue;
        final suivants1 = volsParDepart[v1.arriverIATA] ?? const <Vol>[];

        for (final v2 in suivants1) {
          if (v2.dateheureDep.isAfter(v1.dateheureArr!) && v2.dateheureArr != null) {
            final suivants2 = volsParDepart[v2.arriverIATA] ?? const <Vol>[];

            for (final v3 in suivants2) {
              if (v3.dateheureDep.isAfter(v2.dateheureArr!)) {
                ajouterTrajet([v1, v2, v3]);
              }
            }
          }
        }
      }
    }

    _trajets.sort((a, b) => a.dateheureDep.compareTo(b.dateheureDep));

    _destinations = _trajets.map((t) => t.arriverIATA).toSet().toList();

    notifyListeners();
  }
}
