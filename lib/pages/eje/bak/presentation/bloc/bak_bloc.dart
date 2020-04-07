import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/bak/domain/usecases/GetBAK.dart';
import 'package:eje/pages/eje/bak/domain/usecases/GetBAKler.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class BakBloc extends Bloc<BakEvent, BakState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetBAK getBAK;
  final GetBAKler getBAKler;

  BakBloc({
    @required this.getBAK,
    @required this.getBAKler,
  });

  @override
  BakState get initialState => Empty();

  @override
  Stream<BakState> mapEventToState(
      BakEvent event,
      ) async* {
    if (event is RefreshBAK) {
      print("Triggered Event: RefreshBak");
      yield Loading();
      final bakOrFailure = await getBAK();
      yield bakOrFailure.fold(
            (failure){
          print("Error");
          return Error(message:_mapFailureToMessage(failure));
        },
            (bak){
          print("Succes. Returning LoadedHauptamtliche");
          return LoadedBAK(bak);},
      );
    }
    else if(event is GettingBAKler){
      yield Loading();
      final bakOrFailure = await getBAKler(name:event.name);
      yield bakOrFailure.fold(
            (failure)=> Error(message:_mapFailureToMessage(failure)),
            (bakler)=> LoadedBAKler(bakler),
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
