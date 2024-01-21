// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/ReadOnlySingleElementService.dart';
import 'package:equatable/equatable.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ReadOnlySingleElementService<Article, String> articleService;

  ArticlesBloc({
    required this.articleService,
  }) : super(Empty()) {
    on<RefreshArticle>(_refreshArticle);
    on<GettingArticle>(_getArticle);
    on<FollowingHyperlink>(_followHyperlink);
    on<GetCachedArticles>(_getCachedArticles);
  }

  void _refreshArticle(event, Emitter<ArticlesState> emit) async {
    print("Triggered Event: RefreshArticles");
    emit(Loading());
    final servicesOrFailure = await articleService.getElement(id: event.url);
    emit(servicesOrFailure.fold(
      (failure) {
        print("Error");
        if (failure is ConnectionFailure) {
          return NetworkError(message: failure.getErrorMsg());
        }
        return Error(message: failure.getErrorMsg());
      },
      (article) {
        print("Succes. Returning ReloadedArticles");
        return ReloadedArticle(article);
      },
    ));
  }

  void _getCachedArticles(event, Emitter<ArticlesState> emit) async {
    emit(Loading());
    final servicesOrFailure =
        await articleService.getCachedElement(id: event.url);
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
    emit(Loading());
    final serviceOrFailure = await articleService.getElement(id: event.url);
    emit(serviceOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (article) => LoadedArticle(article),
    ));
  }

  void _followHyperlink(event, Emitter<ArticlesState> emit) async {
    emit(Loading());
    final serviceOrFailure = await articleService.getElement(id: event.url);
    emit(serviceOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (article) => FollowedHyperlink(article),
    ));
  }
}
