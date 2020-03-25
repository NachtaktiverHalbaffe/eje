import 'package:eje/core/utils/SembastDatabase.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:sembast/sembast.dart';

class NeuigkeitDao {
  //Database bennennen und speichern

  static const String NEUIGKEIT_STORE_NAME = "neuigkeiten";
  final _neuigkeitStore = intMapStoreFactory.store(NEUIGKEIT_STORE_NAME);

  //Database instanziieren
  Future<Database> get _db async => await SembastDatabase.instance.database;

  //Element hinzufügen
  Future add(Neuigkeit neuigkeit) async {
    await _neuigkeitStore.add(await _db, neuigkeit.toMap());
  }

  //Element updaten
  Future update(Neuigkeit neuigkeit) async {
    final finder = Finder(filter: Filter.byKey(neuigkeit.titel));
    await _neuigkeitStore.update(
      await _db,
      neuigkeit.toMap(),
      finder: finder,
    );
  }

  //Element löschen
  Future delete(Neuigkeit neuigkeit) async {
    final finder = Finder(filter: Filter.byKey(neuigkeit.titel));
    await _neuigkeitStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Neuigkeit>> getAll() async {
    final recordSnapshots = await _neuigkeitStore.find(
      await _db,
    );

    return recordSnapshots.map((snapshot) {
      final neuigkeit = Neuigkeit.fromMap(snapshot.value);
      return neuigkeit;
    }).toList();
  }

  NeuigkeitDao();
}
