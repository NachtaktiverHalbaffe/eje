import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/usecases/getArticle.dart';
import 'package:eje/pages/articles/domain/usecases/getArticles.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetArticles getArticles;
  final GetArticle getArticle;

  ArticlesBloc({
    @required this.getArticle,
    @required this.getArticles,
  }) : super(Empty());

  @override
  Stream<ArticlesState> mapEventToState(
    ArticlesEvent event,
  ) async* {
    if (event is RefreshArticle) {
      print("Triggered Event: RefreshArticles");
      yield Loading();
      final servicesOrFailure = await getArticle(url: event.url);
      yield servicesOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: _mapFailureToMessage(failure));
        },
        (article) {
          print("Succes. Returning ReloadedArticles");
          return ReloadedArticle(article);
        },
      );
    } else if (event is GettingArticle) {
      yield Loading();
      final serviceOrFailure = await getArticle(url: event.url);
      yield serviceOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (article) => LoadedArticle(article),
      );
    } else if (event is FollowingHyperlink) {
      yield Loading();
      final serviceOrFailure = await getArticle(url: event.url);
      yield serviceOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (article) => FollowedHyperlink(article),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unbekannter Fehler';
    }
  }
}
