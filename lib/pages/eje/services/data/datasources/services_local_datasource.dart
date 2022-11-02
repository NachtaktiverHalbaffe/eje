import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/fixtures/data_services.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:hive/hive.dart';

class ServicesLocalDatasource {
  Future<List<Service>> getCachedServices() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);
    dataServices(box);

    // load data from cache
    if (box.isNotEmpty) {
      List<Service> data = List.empty(growable: true);
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i) != null) {
          data.add(box.getAt(i));
        }
      }
      return data;
    } else {
      throw CacheException();
    }
  }

  Future<Service> getService(String service) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);

    // get specific data entry
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        Service data = box.getAt(i);
        if (data.service == service) {
          return data;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheService(Service service) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);

    // cache specific data entry if not already cached
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        // ignore: no_leading_underscores_for_local_identifiers
        Service _service = box.getAt(i);
        if (_service.service == service.service) {
          box.deleteAt(i);
          box.add(service);
        }
      }
    } else if (box.isEmpty) {
      box.add(service);
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheServices(List<Service> servicesToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(servicesToCache);
  }
}
