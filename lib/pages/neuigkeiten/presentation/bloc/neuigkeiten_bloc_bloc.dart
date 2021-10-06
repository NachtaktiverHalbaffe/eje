// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeiten.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class NeuigkeitenBlocBloc
    extends Bloc<NeuigkeitenBlocEvent, NeuigkeitenBlocState> {
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
      print("Neuigkeiten: Refresh event triggered");
      final neuigkeitOrFailure = await getNeuigkeiten();
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
    } else if (event is GetNeuigkeitDetails) {
      yield LoadingDetails();
      print("Neuigkeiten: get details event triggered");
      final neuigkeitOrFailure = await getNeuigkeit(titel: event.titel);
      yield neuigkeitOrFailure.fold(
        (failure) => Error(message: failure.getErrorMsg()),
        (neuigkeit) {
          print(
              "GetDetails Event Neuigkeiten: Success. Return LoadedDetail state");
          return LoadedDetail(article: neuigkeit);
        },
      );
    }
  }

  // String _mapFailureToMessage(Failure failure) {
  //   switch (failure.runtimeType) {
  //     case ServerFailure:
  //       return SERVER_FAILURE_MESSAGE;
  //     case CacheFailure:
  //       return CACHE_FAILURE_MESSAGE;
  //     default:
  //       return 'Unbekannter Fehler';
  //   }
  // }
}
