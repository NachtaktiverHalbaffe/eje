// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/services/NewsService.dart';
import './bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService newsService;

  NewsBloc({required this.newsService}) : super(Empty()) {
    on<RefreshNews>(_loadNews);
    on<GetNewsDetails>(_loadNewsArticle);
  }

  void _loadNews(event, Emitter<NewsState> emit) async {
    print("Neuigkeiten: Refresh event triggered");
    emit(Loading());
    final neuigkeitOrFailure = await newsService.getNews();
    emit(neuigkeitOrFailure.fold(
      (failure) {
        print("Refresh Event Neuigkeiten: Error");
        return Error(message: failure.getErrorMsg());
      },
      (neuigkeit) {
        print("Refresh Event Neuigkeiten: Success. Return Loaded state");
        return Loaded(neuigkeit: neuigkeit);
      },
    ));
  }

  void _loadNewsArticle(event, Emitter<NewsState> emit) async {
    print("Neuigkeiten: get details event triggered");
    emit(Loading());
    final neuigkeitOrFailure =
        await newsService.getSingleNews(titel: event.title);
    emit(neuigkeitOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (neuigkeit) {
        print(
            "GetDetails Event Neuigkeiten: Success. Return LoadedDetail state");
        return LoadedNewsDetails(article: neuigkeit);
      },
    ));
  }
}
