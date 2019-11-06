import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

//SembastDatabase implementation

class SembastDatabase{
  String name;
  SembastDatabase(@required this.name); //Singleton Instance
  static final SembastDatabase _singleton = SembastDatabase._();
  //Singleton accessor
  static SembastDatabase get instance => _singleton;
  //Completor, um Code asynchron zu machen
  Completer<Database> _dbOpenCompleter;
  //private constructor
  SembastDatabase._();

  //Database Object Accesor
  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }

    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async{
    // bekomme eine directory, wo appdaten gespeichert werden können
    final appDocumentDir = await getApplicationDocumentsDirectory();
    //Path für database
    final dbPath = join(appDocumentDir.path, "database.db");
    //database öffnen
    final database = await databaseFactoryIo.openDatabase(dbPath);
    //database übergeben
    _dbOpenCompleter.complete(database);
  }

}