import 'package:eje/models/exception.dart';
import 'package:eje/models/news.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class NewsLocalDatasource {
  Future<List<News>> getCachedNews() async {
    // Load appconfig
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.newsBox);

    // Load local data
    if (box.isNotEmpty) {
      List<News> data = List.empty(growable: true);
      for (int i = 0; i < box.length; i++) {
        if (box.getAt(i) != null) {
          data.add(box.getAt(i));
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
    final Box box = Hive.box(appConfig.newsBox);

    if (box.isNotEmpty) {
      await box.clear();
    }
    await box.addAll(newsToCache);
  }
}
