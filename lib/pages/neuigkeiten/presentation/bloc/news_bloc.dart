// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/get_single_news.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/get_news.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetSingleNews getSingleNews;
  final GetNews getNews;

  NewsBloc({
    @required this.getSingleNews,
    @required this.getNews,
  })  : assert(getNews != null),
        assert(getSingleNews != null),
        super(Empty());

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is RefreshNews) {
      yield Loading();
      print("Neuigkeiten: Refresh event triggered");
      final neuigkeitOrFailure = await getNews();
      yield neuigkeitOrFailure.fold(
        (failure) {
          print("Refresh Event Neuigkeiten: Error");
          return Error(message: failure.getErrorMsg());
        },
        (neuigkeit) {
          print("Refresh Event Neuigkeiten: Success. Return Loaded state");
          return Loaded(neuigkeit: neuigkeit);
        },
      );
    } else if (event is GetNewsDetails) {
      yield LoadingNewsDetails();
      print("Neuigkeiten: get details event triggered");
      final neuigkeitOrFailure = await getSingleNews(titel: event.title);
      yield neuigkeitOrFailure.fold(
        (failure) => Error(message: failure.getErrorMsg()),
        (neuigkeit) {
          print(
              "GetDetails Event Neuigkeiten: Success. Return LoadedDetail state");
          return LoadedNewsDetails(article: neuigkeit);
        },
      );
    }
  }
}
