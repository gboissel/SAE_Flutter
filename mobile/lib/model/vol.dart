class Vol {
  final String compagnie;
  final int numVol;
  final DateTime dateheureDep;
  final DateTime? dateheureArr;
  final int? terminalDep;
  final int? terminalArr;
  final String departIATA;
  final String arriverIATA;

  Vol({
    required this.compagnie,
    required this.numVol,
    required this.dateheureDep,
    this.dateheureArr,
    this.terminalDep,
    this.terminalArr,
    required this.departIATA,
    required this.arriverIATA,
  });


  static Vol fromJson(Map<String,dynamic> json){
    return Vol(
      compagnie: json['Compagnie'],
      numVol: json['numVol'],
      dateheureDep: DateTime.parse(json['dateheureDep']),
      dateheureArr:
          json['dateheureArr'] != null ? DateTime.parse(json['dateheureArr']) : null,
      terminalDep: json['terminalDep'],
      terminalArr: json['terminalArr'],
      departIATA: json['depart'],
      arriverIATA: json['arriver'],
    );
  }
}
