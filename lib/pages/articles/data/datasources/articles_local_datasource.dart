import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:hive/hive.dart';

class ArticlesLocalDatasource {
  Future<List<Article>> getCachedArticles() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.articlesBox);

    // Load data from cache
    if (_box.isNotEmpty) {
      List<Article> data = List.empty(growable: true);
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

  Future<Article> getArticle(String url) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.articlesBox);

    // Load specific article from cache
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Article article = _box.getAt(i);
        if (article.url == url) {
          return article;
        }
      }
      throw CacheException();
    } else {
      throw CacheException();
    }
  }

  void cacheArticle(Article article) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.articlesBox);

    // Cache an article if not already cached
    if (_box.isNotEmpty) {
      // Delete article from cache if already cached
      for (int i = 0; i < _box.length; i++) {
        Article temp = _box.getAt(i);
        if (temp.url == article.url) {
          _box.deleteAt(i);
        }
      }
      _box.add(article);
    } else if (_box.isEmpty) {
      _box.add(article);
    } else {
      throw CacheException();
    }
  }

  void cacheArticles(List<Article> articlesToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.articlesBox);

    // Cache multiple articles if not already cached
    for (int i = 0; i < articlesToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Article _article = _box.getAt(k);
        if (_article.url == articlesToCache[i].url) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(articlesToCache[i]);
      }
    }
  }
}
