import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class NewsLocalDatasource {
  Future<List<News>> getCachedNews() async {
    // Load appconfig
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.newsBox);

    // Load local data
    if (_box.isNotEmpty) {
      List<News> data = List.empty(growable: true);
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          data.add(_box.getAt(i));
        }
      }
      if (data.isNotEmpty) {
        data.sort((a, b) => a.published.compareTo(b.published));
      }
      return data;
    } else {
      throw CacheException();
    }
  }

  Future<void> cacheNews(List<News> newsToCache) async {
    // Load appconfig
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.newsBox);

    if (_box.isNotEmpty) {
      await _box.clear();
    }
    await _box.addAll(newsToCache);
  }
}
