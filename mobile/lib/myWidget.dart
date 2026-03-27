import 'package:flutter/material.dart';
import './api/api.dart';
import './UI/DetailsVol.dart';

class MyWidget extends StatelessWidget {
  final api = MyAPI();

  MyWidget({super.key});

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  String _formatDate(DateTime dateTime) {
    return "${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year} à ${_twoDigits(dateTime.hour)}h${_twoDigits(dateTime.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getVol(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (_, int index) {
              final vol = snapshot.data![index];

              return Card(
                child: ListTile(
                  leading: Text(vol.numVol.toString()),
                  title: Text(vol.compagnie),
                  subtitle: Text(_formatDate(vol.dateheureDep)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => DetailsVol(vol: vol),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return const Center(
          child: Text("c'est cassé"),
        );
      },
    );
  }
}
