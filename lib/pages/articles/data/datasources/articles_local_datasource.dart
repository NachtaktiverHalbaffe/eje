import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:hive/hive.dart';

class ArticlesLocalDatasource {
  Future<List<Article>> getCachedArticles() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.articlesBox);

    // Load data from cache
    if (box.isNotEmpty) {
      List<Article> data = List.empty(growable: true);
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

  Future<Article> getArticle(String url) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.articlesBox);

    // Load specific article from cache
    if (box.isNotEmpty) {
      for (int i = 0; i < box.length; i++) {
        Article article = box.getAt(i);
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
    final Box box = Hive.box(appConfig.articlesBox);

    // Cache an article if not already cached
    if (box.isNotEmpty) {
      // Delete article from cache if already cached
      for (int i = 0; i < box.length; i++) {
        Article temp = box.getAt(i);
        if (temp.url == article.url) {
          box.deleteAt(i);
        }
      }
      box.add(article);
    } else if (box.isEmpty) {
      box.add(article);
    } else {
      throw CacheException();
    }
  }

  void cacheArticles(List<Article> articlesToCache) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.articlesBox);

    // Cache multiple articles if not already cached
    for (int i = 0; i < articlesToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < box.length; k++) {
        final Article article = box.getAt(k);
        if (article.url == articlesToCache[i].url) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        box.add(articlesToCache[i]);
      }
    }
  }
}
