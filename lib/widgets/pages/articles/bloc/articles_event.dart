part of 'articles_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object> get props => [];
}

class RefreshArticle extends ArticlesEvent {
  final String url;

  RefreshArticle(this.url);
  @override
  List<Object> get props => [url];
}

class GettingArticle extends ArticlesEvent {
  final String url;

  GettingArticle(this.url);

  @override
  List<Object> get props => [url];
}

class FollowingHyperlink extends ArticlesEvent {
  final String url;

  FollowingHyperlink(this.url);

  @override
  List<Object> get props => [url];
}

class GetCachedArticles extends ArticlesEvent {}
