// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/GetArbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/GetArbeitsbereiche.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class ArbeitsbereicheBloc
    extends Bloc<ArbeitsbereicheEvent, ArbeitsbereicheState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetArbeitsbereiche getArbeitsbereiche;
  final GetArbeitsbereich getArbeitsbereich;

  ArbeitsbereicheBloc({
    @required this.getArbeitsbereich,
    @required this.getArbeitsbereiche,
  }) : super(Empty());

  @override
  Stream<ArbeitsbereicheState> mapEventToState(
    ArbeitsbereicheEvent event,
  ) async* {
    if (event is RefreshArbeitsbereiche) {
      print("Triggered Event: RefreshArbeitsbereiche");
      yield Loading();
      final arbeitsbereicheOrFailure = await getArbeitsbereiche();
      yield arbeitsbereicheOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: _mapFailureToMessage(failure));
        },
        (arbeitsbereiche) {
          print("Succes. Returning LoadedArbeitsbereiche");
          return LoadedArbeitsbereiche(arbeitsbereiche);
        },
      );
    } else if (event is GettingArbeitsbereich) {
      yield Loading();
      final arbeitsbereicheOrFailure =
          await getArbeitsbereich(arbeitsbereich: event.arbeitsfeld);
      yield arbeitsbereicheOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (arbeitsfeld) => LoadedArbeitsbereich(arbeitsfeld),
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
