import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/data_services.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:hive/hive.dart';

class ServicesLocalDatasource {
  Future<List<Service>> getCachedServices() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.servicesBox);
    data_services(_box);

    // load data from cache
    if (_box.isNotEmpty) {
      List<Service> data = new List.empty(growable: true);
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          data.add(_box.getAt(i));
        }
      }
      return data;
    } else {
      throw CacheException();
    }
  }

  Future<Service> getService(String service) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.servicesBox);

    // get specific data entry
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Service data = _box.getAt(i);
        if (data.service == service) {
          return data;
        }
      }
    } else {
      throw CacheException();
    }
  }

  void cacheService(Service service) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.servicesBox);

    // cache specific data entry if not already cached
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Service _service = _box.getAt(i);
        if (_service.service == service.service) {
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

  void cacheServices(List<Service> servicesToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.servicesBox);

    // cache data if not already cached
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
