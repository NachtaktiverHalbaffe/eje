import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeiten.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class NeuigkeitenBlocBloc
    extends Bloc<NeuigkeitenBlocEvent, NeuigkeitenBlocState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetNeuigkeit getNeuigkeit;
  final GetNeuigkeiten getNeuigkeiten;

  NeuigkeitenBlocBloc({
    @required this.getNeuigkeit,
    @required this.getNeuigkeiten,
  })  : assert(getNeuigkeiten != null),
        assert(getNeuigkeit != null),
        super(Empty());

  @override
  Stream<NeuigkeitenBlocState> mapEventToState(
    NeuigkeitenBlocEvent event,
  ) async* {
    if (event is RefreshNeuigkeiten) {
      yield Loading();
      print("Refresh event triggered");
      final neuigkeitOrFailure = await getNeuigkeiten();
      yield neuigkeitOrFailure.fold(
        (failure) {
          print("Refresh Event: Error");
          return Error(message: _mapFailureToMessage(failure));
        },
        (neuigkeit) {
          print("Refresh Event: Success. Return Loaded state");
          return Loaded(neuigkeit: neuigkeit);
        },
      );
    } else if (event is GetNeuigkeitDetails) {
      yield LoadingDetails();
      print("get details event triggered");
      final neuigkeitOrFailure = await getNeuigkeit(titel: event.titel);
      yield neuigkeitOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (neuigkeit) {
          print("GetDetails Event: Success. Return LoadedDetail state");
          return LoadedDetail(article: neuigkeit);
        },
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
