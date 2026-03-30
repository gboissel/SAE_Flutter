import 'dart:convert';
import '../model/vol.dart';
import '../model/aeroport.dart';
import 'package:http/http.dart' as http;

class MyAPI {
  Future<List<Vol>> getVol() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/vols/'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Vol.fromJson(e)).toList();
    } else {
      throw Exception('Fail to load vols');
    }
  }

  Future<List<Aeroport>> getAeroports() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/aeroport/'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Aeroport.fromJson(e)).toList();
    } else {
      throw Exception('Fail to load aeroports');
    }
  }

  Future<List<dynamic>> getDestinationsByEscales({
    String ville = 'Paris',
    String pays = 'FR',
    String escales = '0',
  }) async {
    final uri = Uri.parse('http://127.0.0.1:5000/api/destinations').replace(
      queryParameters: {
        'ville': ville,
        'pays': pays,
        'escales': escales,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Fail');
    }

    return jsonDecode(response.body);
  }
}
