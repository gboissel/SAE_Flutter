import 'dart:ui';

import 'package:flutter/material.dart';

class Task {
  int id;
  String title;
  List<String> tags;
  int nbhours;
  int difficulty;
  String description;
  static int nb=0;

  Task({required this.id,required this.title,required this.tags,required
  this.nbhours,required this.difficulty,required this.description});

  static List<Task> generateTask(int i){
    List<Task> tasks=[];
    for(int n=0;n<i;n++){
      tasks.add(Task(id: n, title: "title $n", tags: ['tag $n','tag${n+1}'], nbhours: n, difficulty: n, description: '$n'));
      nb++;}

    return tasks;
  }

  static Task fromJson(Map<String,dynamic> json){
    final tags = <String>[];

    if (json['tags']!=null){
      json['tags'].forEach((t){
        tags.add(t);
      });
    }
    return Task(id: json['id'], title: json['title'], tags: tags, nbhours: json['nbhours'], difficulty: json['difficulty'], description: json['description']);
  }

  factory Task.newTask( titre){
    Task t =Task(id: nb, title: titre?? 'title $nb', tags: ['tags $nb'], nbhours:
    nb, difficulty: nb%5, description: 'description $nb');
    nb++;
    return t;
  }
}

