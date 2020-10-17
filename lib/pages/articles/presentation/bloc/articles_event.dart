part of 'articles_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object> get props => [];
}

class RefreshArticle extends ArticlesEvent {
  String url;

  RefreshArticle(@required this.url);
  @override
  List<Object> get props => [url];
}

class GettingArticle extends ArticlesEvent {
  String url;

  GettingArticle(@required this.url);

  @override
  List<Object> get props => [url];
}
