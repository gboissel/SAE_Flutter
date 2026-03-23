import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/vol.dart';
import 'package:flutter/services.dart';



class DetailsVol extends StatelessWidget {
  const DetailsVol({super.key, required this.vol});

  final Vol vol;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(vol.numVol.toString())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text("Compagnie = " + vol.compagnie + "\n" + "Date et heure de départ = " + "${vol.dateheureDep.day}/${vol.dateheureDep.month}/${vol.dateheureDep.year} à ${vol.dateheureDep.hour}h${vol.dateheureDep.minute}"
            + "\n" + "Date et heure d'arrivée = " + "${vol.dateheureArr!.day}/${vol.dateheureArr!.month}/${vol.dateheureArr!.year} à ${vol.dateheureArr!.hour}h${vol.dateheureArr!.minute}" +
            "\n" + "Terminal départ = " + vol.terminalDep.toString() + "\n" + "Terminal arrivée = " + vol.terminalArr.toString() + "\n" + "Aéroport IATA de départ = " + vol.departIATA + "\n" + "Aéroport IATA d'arrivée = " + vol.arriverIATA),
      ),
    );
  }
}
