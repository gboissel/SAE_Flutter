import 'vol.dart';
class Aeroport {
  final String codeIATA;
  final String nomAeroport;
  final String codePays;
  final String ville;

  List<Vol> volsDepart;
  List<Vol> volsArriver;

  Aeroport({
    required this.codeIATA,
    required this.nomAeroport,
    required this.codePays,
    required this.ville,
    this.volsDepart = const [],
    this.volsArriver = const [],
  });

  factory Aeroport.fromJson(Map<String, dynamic> json) {
    return Aeroport(
      codeIATA: json['CodeIATA'],
      nomAeroport: json['nomAeroport'],
      codePays: json['CodePays'],
      ville: json['ville'],
    );
  }
}
