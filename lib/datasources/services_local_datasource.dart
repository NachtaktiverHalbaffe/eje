import 'package:eje/app_config.dart';
import 'package:eje/fixtures/data_services.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/exception.dart';
import 'package:hive/hive.dart';

class ServicesLocalDatasource {
  Future<List<OfferedService>> getCachedServices() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);
    dataServices(box);

    // load data from cache
    if (box.isNotEmpty) {
      List<OfferedService> data = List.empty(growable: true);
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

  Future<OfferedService> getService(String service) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);

    // get specific data entry
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        OfferedService data = box.getAt(i);
        if (data.service == service) {
          return data;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheService(OfferedService service) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);

    // cache specific data entry if not already cached
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        // ignore: no_leading_underscores_for_local_identifiers
        OfferedService _service = box.getAt(i);
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

  Future<void> cacheServices(List<OfferedService> servicesToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.servicesBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(servicesToCache);
  }
}
