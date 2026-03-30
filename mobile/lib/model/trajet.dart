import 'vol.dart';

class Trajet {
  final List<Vol> vols;

  Trajet(this.vols);

  String get departIATA => vols.first.departIATA;
  String get arriverIATA => vols.last.arriverIATA;
  DateTime get dateheureDep => vols.first.dateheureDep;
  DateTime get dateheureArr => vols.last.dateheureArr ?? DateTime.now();
  int get nombreEscales => vols.length - 1;

  String get compagnies {
    return vols.map((v) => v.compagnie).toSet().join(', ');
  }
}
