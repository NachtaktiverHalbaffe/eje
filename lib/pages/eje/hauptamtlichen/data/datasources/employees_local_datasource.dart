import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:hive/hive.dart';

class EmployeesLocalDatasource {
  Future<List<Employee>> getCachedEmployees() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.employeesBox);

    // load data from cache
    if (_box.isNotEmpty) {
      List<Employee> data = List.empty(growable: true);
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

  Future<Employee> getEmployee(String name) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.employeesBox);

    // load specific data entry from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Employee temp = _box.getAt(i);
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
    final Box _box = Hive.box(appConfig.employeesBox);

    if (_box.isNotEmpty) {
      await _box.clear();
    }
    await _box.addAll(hauptamtlicheToCache);
  }
}
