import 'package:eje/app_config.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:hive/hive.dart';

class ArbeitsbereicheLocalDatasource {
  Future<List<FieldOfWork>> getCachedArbeitsbereiche() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.fieldOfWorkBox);

    //Load all field of works from cache
    if (box.isNotEmpty) {
      List<FieldOfWork> data = List.empty(growable: true);
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

  Future<FieldOfWork> getArbeitsbereich(String arbeitsfeld) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.fieldOfWorkBox);

    // Load specific field of work
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        FieldOfWork temp = box.getAt(i);
        if (temp.name == arbeitsfeld) {
          return temp;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheBAK(List<FieldOfWork> arbeitsbereicheToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.fieldOfWorkBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(arbeitsbereicheToCache);
  }
}
