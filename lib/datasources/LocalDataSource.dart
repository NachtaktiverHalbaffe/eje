import 'package:eje/models/exception.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class LocalDataSource<T extends Equatable, I> {
  Future<List<T>> getAllElements(String boxKey) async {
    final Box box = Hive.box(name: boxKey);

    // load data from cache
    if (box.isNotEmpty) {
      List<T> data = List.empty(growable: true);
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i) != null) {
          data.add(box.getAt(i));
        }
      }
      return data;
    } else {
      return [];
    }
  }

  Future<T> getElement(String boxKey, I id, String idKey) async {
    final Box box = Hive.box(name: boxKey);

    // load specific data entry from cache
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        T element = box.getAt(i);
        if (element.props.contains(id)) {
          return element;
        }
      }

      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheElements(String boxKey, List<T> elementsToCache) async {
    final Box box = Hive.box(name: boxKey);

    if (box.isNotEmpty) {
      box.clear();
    }
    box.addAll(elementsToCache);
  }

  Future<void> cacheElement(String boxKey, T elementToCache) async {
    final Box box = Hive.box(name: boxKey);

    if (box.isNotEmpty) {
      box.clear();
    }
    box.add(elementToCache);
  }
}
