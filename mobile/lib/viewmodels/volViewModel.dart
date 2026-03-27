import 'package:flutter/foundation.dart';
import '../api/api.dart';
import '../model/vol.dart';

enum StopType { zero, one, two, all }

class VolViewModel extends ChangeNotifier {
  final MyAPI _api = MyAPI();
  
  List<Vol> _vols = [];
  List<String> _destinations = [];
  bool _isLoading = false;
  StopType _selectedStop = StopType.all;

  List<Vol> get vols => _vols;
  List<String> get destinations => _destinations;
  bool get isLoading => _isLoading;
  StopType get selectedStop => _selectedStop;

  VolViewModel() {
    loadData();
  }

  void setStopType(StopType type) {
    _selectedStop = type;
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allVols = await _api.getVol();
      
      if (_selectedStop == StopType.all) {
        _vols = allVols;
        _destinations = [];
      } else {
        String stops = "0";
        if (_selectedStop == StopType.one) stops = "1";
        if (_selectedStop == StopType.two) stops = "2";
        
        final response = await _api.getDestinationsByEscales(
          ville: 'Paris',
          pays: 'FR',
          escales: stops,
        );

        _destinations = response.map((e) => (e['codeIATA'] ?? e['ville']).toString()).toList();

        _vols = allVols.where((v) {
          bool isFromParis = v.departIATA == 'CDG' || v.departIATA == 'ORY';
          if (_selectedStop == StopType.zero) {
            return isFromParis && _destinations.contains(v.arriverIATA);
          }

          return isFromParis;
        }).toList();
      }
    } catch (e) {
      _vols = [];
      _destinations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
