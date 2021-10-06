// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/pages/articles/domain/entity/article.dart';
import 'package:eje/pages/articles/domain/usecases/get_article.dart';
import 'package:eje/pages/articles/domain/usecases/get_articles.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
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
          return Error(message: failure.getErrorMsg());
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
        (failure) => Error(message: failure.getErrorMsg()),
        (article) => LoadedArticle(article),
      );
    } else if (event is FollowingHyperlink) {
      yield Loading();
      final serviceOrFailure = await getArticle(url: event.url);
      yield serviceOrFailure.fold(
        (failure) => Error(message: failure.getErrorMsg()),
        (article) => FollowedHyperlink(article),
      );
    }
  }
}
