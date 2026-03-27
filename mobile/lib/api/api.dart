import 'dart:convert';
import '../model/vol.dart';
import 'package:http/http.dart' as http;


class MyAPI {
  Future<List<Vol>> getVol() async{
    await Future.delayed(Duration(seconds: 1));
    final dataString = await http.get(Uri.parse('http://127.0.0.1:5000/api/vols'));
    if (dataString.statusCode==200){

      final List<dynamic> json = jsonDecode(dataString.body);

      final Vols = <Vol>[];
      for(var element in json){
        Vols.add(Vol.fromJson(element));
      }
      return Vols;
    }else{
      throw Exception('Fail');
    }
  }

  Future<List<String>> getDestinationsByEscales({
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

    final List<dynamic> json = jsonDecode(response.body);
    return json
        .map((element) => (element['ville'] ?? '').toString())
        .where((ville) => ville.isNotEmpty)
        .toList();
  }
}