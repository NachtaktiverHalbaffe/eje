import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_termine.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:hive/hive.dart';

class TermineLocalDatasource {
  Box _box;

  List<Termin> getCachedTermine() {
    Box _box = Hive.box('Termine');
    testdata_termine(_box);
    if (_box.isNotEmpty) {
      List<Termin> temp = new List<Termin>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      return temp;
    } else {
      throw CacheException();
    }
  }

  Termin getTermin(String veranstaltung, String dateTime) {
    _box = Hive.box('Termine');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Termin temp = _box.getAt(i);
        if (temp.veranstaltung == veranstaltung && temp.datum == dateTime) {
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheTermine(List<Termin> termineToCache) {
    _box = Hive.box('Termine');
    for (int i = 0; i < termineToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Termin _termin = _box.getAt(k);
        if (_termin == termineToCache[i]) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(termineToCache[i]);
      }
    }
  }
}
