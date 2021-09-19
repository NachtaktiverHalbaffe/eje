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
  @override
  List<Object> get props => [];
}

class ReloadedArticle extends ArticlesState {
  final Article article;

  ReloadedArticle(this.article);

  @override
  List<Object> get props => [article];
}

class LoadedArticle extends ArticlesState {
  final Article article;

  LoadedArticle(this.article);

  @override
  List<Object> get props => [article];
}

class FollowedHyperlink extends ArticlesState {
  final Article article;

  FollowedHyperlink(this.article);

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
