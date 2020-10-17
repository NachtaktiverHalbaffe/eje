part of 'articles_bloc.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object> get props => [];
}

class Empty extends ArticlesState {
  @override
  List<Object> get props => [];
}

class Loading extends ArticlesState {
  String url;
  @override
  List<Object> get props => [url];
}

class ReloadedArticle extends ArticlesState {
  Article article;

  ReloadedArticle(this.article);

  @override
  List<Object> get props => [article];
}

class LoadedArticle extends ArticlesState {
  Article article;

  LoadedArticle(this.article);

  @override
  List<Object> get props => [article];
}

class Error extends ArticlesState {
  final String message;

  //Constructor
  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
