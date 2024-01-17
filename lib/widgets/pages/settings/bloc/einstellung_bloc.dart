import 'package:bloc/bloc.dart';
import 'package:eje/services/SharedPreferencesService.dart';
import './bloc.dart';

class EinstellungBloc extends Bloc<EinstellungEvent, EinstellungState> {
  // ignore: non_constant_identifier_names
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final SettingsService settingsService;

  EinstellungBloc({required this.settingsService}) : super(Empty()) {
    on<StoringPreferences>(_storePrefrences);
    on<GettingPreferences>(_loadPrefrences);
    on<GettingPreference>(_loadSpecificPrefrence);
  }

  void _storePrefrences(event, Emitter<EinstellungState> emit) async {
    final einstellungOrFailure = await settingsService.setPrefrence(
        preference: event.preference, state: event.state);
    emit(einstellungOrFailure.fold(
        (failure) => Error(message: CACHE_FAILURE_MESSAGE),
        (prefs) => ChangedPreferences()));
  }

  void _loadPrefrences(event, Emitter<EinstellungState> emit) async {
    final einstellungOrFailure = await settingsService.getPrefrences();
    emit(einstellungOrFailure.fold(
        (failure) => Error(message: CACHE_FAILURE_MESSAGE),
        (prefs) => LoadedPreferences()));
  }

  void _loadSpecificPrefrence(event, Emitter<EinstellungState> emit) async {
    final einstellungOrFailure =
        await settingsService.getPrefrence(preference: event.preference);
    emit(einstellungOrFailure.fold(
        (failure) => Error(message: CACHE_FAILURE_MESSAGE),
        (einstellung) => LoadedPreference(einstellung)));
  }
}
