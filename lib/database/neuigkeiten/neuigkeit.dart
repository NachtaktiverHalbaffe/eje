import 'dart:async';

import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Neuigkeit {
  String titel;
  String vorschau;
  String inhalt;
  List<String> bilder;
  String weiterfuehrender_link;

  //Constructour
  Neuigkeit({
    @required this.titel,
    @required this.vorschau,
    @required this.inhalt,
    @required this.bilder,
    this.weiterfuehrender_link,
  });

  //Map Etity zu String (notwendig zum speichern)
  Map<String, dynamic> toMap() {
    return {
      "titel": titel,
      "vorschau": vorschau,
      "inhalt": inhalt,
      "bilder": bilder?.map((bilder) => String).toList(),
      "weiterfuehrender_link": weiterfuehrender_link,
    };
  }
  //Entity rekonstruieren vonString (NOTWENDIOG ZUM LESEN DER DB9
  static Neuigkeit fromMap(Map<String, dynamic> map) {
    return Neuigkeit(
      titel: map["titel"],
      vorschau: map["vorschau"],
      inhalt: map["inhalt"],
      bilder: map["bilder"].map((bilder) => bilder.toList().cast<String>()),
      weiterfuehrender_link: map["weiterfuehrender_link"],
    );
  }
}
/*
class Neuigkeit extends Table {
  // Nur für Database
  IntColumn get id => integer().autoIncrement()();
  // Daten
  TextColumn get titel => text().call();
  TextColumn get vorschau => text().call();
  TextColumn get inhalt => text().call();
  //TODO: List von Bildern
  TextColumn get bild => text().call();
  TextColumn get weiterfuehrender_link => text().nullable().call();
}

@UseMoor(tables: [Neuigkeit], daos: [NeuigkeitenDao])
class NeuigkeitenDatabase extends _$NeuigkeitenDatabase{
  NeuigkeitenDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          logStatements: true,
      ));
  @override
  int get schemaVersion => 1;
  // All tables have getters in the generated class - we can select the tasks table
}


@UseDao(tables: [Neuigkeit])
class NeuigkeitenDao extends DatabaseAccessor<NeuigkeitenDatabase> with _$NeuigkeitenDaoMixin{
  final NeuigkeitenDatabase db;
  NeuigkeitenDao(this.db) :super(db);
/*
  Future<List<NeuigkeitData>> getAllTasks() => select(neuigkeit).get();
  Stream<List<NeuigkeitData>> watchAllTasks() => select(neuigkeit).watch();
  Future insertTask(Neuigkeit neuigkeiten) => into(neuigkeit).insert(neuigkeiten);
  Future updateTask(Neuigkeit neuigkeiten) => update(neuigkeit).replace(neuigkeiten);
  Future deleteTask(Neuigkeit neuigkeiten) => delete(neuigkeit).delete(neuigkeiten);
*/
//TODO Https-Anbindung
}
*/
