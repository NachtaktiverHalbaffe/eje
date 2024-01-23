import 'package:eje/models/exception.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class LocalDataSource<T extends Equatable, I> {
  final String boxKey;
  final String idKey;

  LocalDataSource({required this.boxKey, required this.idKey});

  Future<List<T>> getAllElements() async {
    final Box box = await Hive.openBox(boxKey);

    // load data from cache
    if (box.isNotEmpty) {
      List<T> data = List.empty(growable: true);
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i) != null) {
          data.add(box.getAt(i));
        }
      }
      await box.close();
      return data;
    } else {
      await box.close();
      return [];
    }
  }

  Future<T> getElement(I id) async {
    final Box box = await Hive.openBox(boxKey);

    // load specific data entry from cache
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        T element = box.getAt(i);
        if (element.props.contains(id)) {
          await box.close();
          return element;
        }
      }
      await box.close();
      throw CacheException();
    } else {
      await box.close();
      throw CacheException();
    }
  }

  Future<void> cacheElements(List<T> elementsToCache) async {
    final Box box = await Hive.openBox(boxKey);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(elementsToCache);
    await box.close();
  }

  Future<void> cacheElement(T elementToCache) async {
    final Box box = await Hive.openBox(boxKey);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.add(elementToCache);
    await box.close();
  }
}
