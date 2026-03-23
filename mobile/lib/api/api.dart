import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/vol.dart';
import 'package:http/http.dart' as http;


class MyAPI {
  Future<String> _loadAsset(String path) async {
    return rootBundle.loadString(path);
  }

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
}