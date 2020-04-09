import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_freizeiten.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:hive/hive.dart';

class FreizeitenLocalDatasource{
  Box _box;

  Future<List<Freizeit>> getCachedFreizeiten() async {
    _box = await Hive.openBox('Freizeiten');
    testdata_freizeiten(_box);
    if (_box.isNotEmpty) {
      List<Freizeit> temp = new List<Freizeit>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      Hive.box('Freizeiten').compact();
      Hive.box('Freizeiten').close();
      return temp;
    } else {
      throw CacheException();
    }
  }

  Future<Freizeit> getFreizeit(Freizeit freizeit) async {
    _box = await Hive.openBox('Freizeiten');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Freizeit temp = _box.getAt(i);
        if (temp == freizeit) {
          Hive.box('Freizeiten').compact();
          Hive.box('Freizeiten').close();
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheFreizeiten(List<Freizeit> freizeitenToCache) async {
    _box = await Hive.openBox('Freizeiten');
    for(int i=0; i<   freizeitenToCache.length;i++){
      bool alreadyexists=false;
      for(int k=0; k< _box.length;k++){
        final Freizeit _freizeit = _box.getAt(k);
        if(_freizeit == freizeitenToCache[i]){
          alreadyexists=true;
        }
      }
      if(alreadyexists==false){
        _box.add(freizeitenToCache[i]);
      }
    }
    Hive.box('Freizeiten').compact();
    Hive.box('Freizeiten').close();
  }

}