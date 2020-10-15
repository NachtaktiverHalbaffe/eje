import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/testdata_services.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:hive/hive.dart';

class ServicesLocalDatasource {
  Box _box;

  Future<List<Service>> getCachedServices() async {
    _box = await Hive.box('Services');
    data_services(_box);
    if (_box.isNotEmpty) {
      List<Service> temp = new List<Service>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      _box.compact();
      _box.close();
      return temp;
    } else {
      throw CacheException();
    }
  }

  Future<Service> getService(String service) async {
    _box = await Hive.box('Services');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Service temp = _box.getAt(i);
        if (temp.service == service) {
          _box.compact();

          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheService(Service service) async {
    _box = await Hive.box('Services');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Service temp = _box.getAt(i);
        if (temp.service == service.service) {
          _box.deleteAt(i);
          _box.add(new Service(
              service: temp.service,
              bilder: service.bilder,
              inhalt: temp.inhalt,
              hyperlinks: service.hyperlinks));
          _box.compact();
        }
      }
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheServices(List<Service> servicesToCache) async {
    _box = await Hive.box('Services');
    for (int i = 0; i < servicesToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Service _service = _box.getAt(k);
        if (_service.service == servicesToCache[i].service) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(servicesToCache[i]);
      }
    }
    _box.compact();
  }
}
