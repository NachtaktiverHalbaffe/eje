import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/pages/einstellungen/domain/usecases/get_preference.dart';
import 'package:eje/pages/einstellungen/domain/usecases/get_preferences.dart';
import 'package:eje/pages/einstellungen/domain/usecases/set_prefrences.dart';

import './bloc.dart';

class EinstellungBloc extends Bloc<EinstellungEvent, EinstellungState> {
  // ignore: non_constant_identifier_names
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final SetPreferences storePrefrences;
  final GetPreferences getPrefrences;
  final GetPreference getPreference;

  EinstellungBloc(this.storePrefrences, this.getPrefrences, this.getPreference)
      : super(Empty()) {
    on<StoringPreferences>(_storePrefrences);
    on<GettingPreferences>(_loadPrefrences);
    on<GettingPreference>(_loadSpecificPrefrence);
  }

  void _storePrefrences(event, Emitter<EinstellungState> emit) async {
    final einstellungOrFailure =
        await storePrefrences(preference: event.preference, state: event.state);
    emit(einstellungOrFailure.fold(
        (failure) => Error(message: CACHE_FAILURE_MESSAGE),
        (prefs) => ChangedPreferences()));
  }

  void _loadPrefrences(event, Emitter<EinstellungState> emit) async {
    final einstellungOrFailure = await getPrefrences();
    emit(einstellungOrFailure.fold(
        (failure) => Error(message: CACHE_FAILURE_MESSAGE),
        (prefs) => LoadedPreferences()));
  }

  void _loadSpecificPrefrence(event, Emitter<EinstellungState> emit) async {
    final einstellungOrFailure =
        await getPreference(preference: event.preference);
    emit(einstellungOrFailure.fold(
        (failure) => Error(message: CACHE_FAILURE_MESSAGE),
        (einstellung) => LoadedPreference(einstellung)));
  }
}
