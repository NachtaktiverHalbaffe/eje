import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:hive/hive.dart';

class EmployeesLocalDatasource {
  Future<List<Employee>> getCachedEmployees() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.employeesBox);

    // load data from cache
    if (box.isNotEmpty) {
      List<Employee> data = List.empty(growable: true);
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

  Future<Employee> getEmployee(String name) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.employeesBox);

    // load specific data entry from cache
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        Employee temp = box.getAt(i);
        if (temp.name == name) {
          return temp;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheEmployees(List<Employee> hauptamtlicheToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.employeesBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(hauptamtlicheToCache);
  }
}
