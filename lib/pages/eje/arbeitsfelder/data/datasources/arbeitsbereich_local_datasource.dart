import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:hive/hive.dart';

class ArbeitsbereicheLocalDatasource{
  Box _box;

  Future<List<Arbeitsbereich>> getCachedArbeitsbereiche() async {
    _box = await Hive.openBox('Arbeitsbereiche');
    if (_box.isNotEmpty) {
      List<Arbeitsbereich> temp = new List<Arbeitsbereich>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      Hive.box('Arbeitsbereiche').compact();
      Hive.box('Arbeitsbereiche').close();
      return temp;
    } else {
      throw CacheException();
    }
  }

  Future<Arbeitsbereich> getArbeitsbereich(String arbeitsfeld) async {
    _box = await Hive.openBox('Arbeitsbereiche');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Arbeitsbereich temp = _box.getAt(i);
        if (temp.arbeitsfeld == arbeitsfeld) {
          Hive.box('Arbeitsbereiche').compact();
          Hive.box('Arbeitsbereiche').close();
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheBAK(List<Arbeitsbereich> arbeitsbereicheToCache) async {
    _box = await Hive.openBox('Arbeitsbereiche');
    for(int i=0; i<   arbeitsbereicheToCache.length;i++){
      bool alreadyexists=false;
      for(int k=0; k< _box.length;k++){
        final Arbeitsbereich _arbeitsbereich = _box.getAt(k);
        if(_arbeitsbereich.arbeitsfeld == arbeitsbereicheToCache[i].arbeitsfeld){
          alreadyexists=true;
        }
      }
      if(alreadyexists==false){
        _box.add( arbeitsbereicheToCache[i]);
      }
    }
    Hive.box('Arbeitsbereiche').compact();
    Hive.box('Arbeitsbereiche').close();
  }

}