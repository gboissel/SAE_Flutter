import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './api/api.dart';
import './UI/DetailsVol.dart';

class MyWidget extends StatelessWidget {
  final api = MyAPI();

  MyWidget();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: api.getVol(),
        builder: (context, snapshot){
          if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }

          else if(snapshot.data != null){
            return ListView.builder(
              itemCount:snapshot.data?.length??0,
              itemBuilder: (_, int index) {
                final vol = snapshot.data![index];

                return Card(
                  child: ListTile(
                    leading: Text(vol.numVol.toString()),
                    title: Text(vol.compagnie),
                    subtitle: Text(
                        "${vol.dateheureDep.day}/${vol.dateheureDep.month}/${vol.dateheureDep.year} à ${vol.dateheureDep.hour}h${vol.dateheureDep.minute}"
                    ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => DetailsVol(vol: vol),
                          ),
                        );
                      }
                  ),
                );
              },
            );
          }
          else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          return Center(child: Text("c'est cassé"));
        }
    ) ;
  }
}
