// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/usecases/get_article.dart';
import 'package:eje/pages/articles/domain/usecases/get_articles.dart';
import 'package:equatable/equatable.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetArticles getArticles;
  final GetArticle getArticle;

  ArticlesBloc({
    required this.getArticle,
    required this.getArticles,
  }) : super(Empty()) {
    on<RefreshArticle>(_refreshArticle);
    on<GettingArticle>(_getArticle);
    on<FollowingHyperlink>(_followHyperlink);
  }

  void _refreshArticle(event, Emitter<ArticlesState> emit) async {
    print("Triggered Event: RefreshArticles");
    final servicesOrFailure = await getArticle(url: event.url);
    emit(servicesOrFailure.fold(
      (failure) {
        print("Error");
        return Error(message: failure.getErrorMsg());
      },
      (article) {
        print("Succes. Returning ReloadedArticles");
        return ReloadedArticle(article);
      },
    ));
  }

  void _getArticle(event, Emitter<ArticlesState> emit) async {
    final serviceOrFailure = await getArticle(url: event.url);
    emit(serviceOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (article) => LoadedArticle(article),
    ));
  }

  void _followHyperlink(event, Emitter<ArticlesState> emit) async {
    final serviceOrFailure = await getArticle(url: event.url);
    emit(serviceOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (article) => FollowedHyperlink(article),
    ));
  }
}
