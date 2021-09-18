import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/pages/einstellungen/domain/usecases/getPreference.dart';
import 'package:eje/pages/einstellungen/domain/usecases/getPreferences.dart';
import 'package:eje/pages/einstellungen/domain/usecases/setPrefrences.dart';

import './bloc.dart';

class EinstellungBloc extends Bloc<EinstellungEvent, EinstellungState> {
  // ignore: non_constant_identifier_names
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final SetPreferences storePrefrences;
  final GetPreferences getPrefrences;
  final GetPreference getPreference;

  EinstellungBloc(this.storePrefrences, this.getPrefrences, this.getPreference)
      : super(Empty());

  @override
  Stream<EinstellungState> mapEventToState(
    EinstellungEvent event,
  ) async* {
    if (event is StoringPreferences) {
      final einstellungOrFailure = await storePrefrences(
          preference: event.preference, state: event.state);
      yield einstellungOrFailure.fold(
          (failure) => Error(message: CACHE_FAILURE_MESSAGE),
          (prefs) => ChangedPreferences());
    } else if (event is GettingPreferences) {
      final einstellungOrFailure = await getPrefrences();
      yield einstellungOrFailure.fold(
          (failure) => Error(message: CACHE_FAILURE_MESSAGE),
          (prefs) => LoadedPreferences());
    } else if (event is GettingPreference) {
      final einstellungOrFailure =
          await getPreference(preference: event.preference);
      yield einstellungOrFailure.fold(
          (failure) => Error(message: CACHE_FAILURE_MESSAGE),
          (einstellung) => LoadedPreference(einstellung));
    }
  }
}
