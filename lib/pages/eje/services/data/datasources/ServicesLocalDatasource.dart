import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/data_services.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:hive/hive.dart';

class ServicesLocalDatasource {
  Box _box;

  List<Service> getCachedServices() {
    Box _box = Hive.box('Services');
    data_services(_box);
    if (_box.isNotEmpty) {
      List<Service> temp = new List<Service>();
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

  Service getService(String service) {
    Box _box = Hive.box('Services');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Service temp = _box.getAt(i);
        if (temp.service == service) {
          return temp;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheService(Service service) {
    Box _box = Hive.box('Services');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Service temp = _box.getAt(i);
        if (temp.service == service.service) {
          _box.deleteAt(i);
          _box.add(service);
        }
      }
    } else if (_box.isEmpty) {
      _box.add(service);
    } else {
      throw CacheException();
    }
  }

  void cacheServices(List<Service> servicesToCache) {
    Box _box = Hive.box('Services');
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
  }
}
