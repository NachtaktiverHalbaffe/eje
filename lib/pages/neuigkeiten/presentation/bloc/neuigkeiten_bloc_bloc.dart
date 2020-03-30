import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeiten.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class NeuigkeitenBlocBloc
    extends Bloc<NeuigkeitenBlocEvent, NeuigkeitenBlocState> {
  final String SERVER_FAILURE_MESSAGE = 'Fehler beim Abrufen der Daten vom Server';
  final String CACHE_FAILURE_MESSAGE = 'Fehler beim Laden der Daten aus den Cache';
  final GetNeuigkeit getNeuigkeit;
  final GetNeuigkeiten getNeuigkeiten;

  NeuigkeitenBlocBloc({
    @required this.getNeuigkeit,
    @required this.getNeuigkeiten,
  })  : assert(getNeuigkeiten != null),
        assert(getNeuigkeit != null);

  @override
  NeuigkeitenBlocState get initialState => Empty();

  @override
  Stream<NeuigkeitenBlocState> mapEventToState(
    NeuigkeitenBlocEvent event,
  ) async* {
    if (event is RefreshNeuigkeiten) {
      yield Loading();
      final neuigkeitOrFailure = await getNeuigkeiten();
      yield neuigkeitOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (neuigkeit) => Loaded(neuigkeit: neuigkeit),
      );
    } else if (event is GetNeuigkeitDetails) {
      yield Loading();
      final neuigkeitOrFailure = await getNeuigkeit(titel: event.titel);
      yield neuigkeitOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (neuigkeit) => LoadedDetail(neuigkeit: neuigkeit),
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
