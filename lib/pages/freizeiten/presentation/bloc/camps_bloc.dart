// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camp.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camps.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class CampsBloc extends Bloc<CampEvent, CampState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetCamp getCamp;
  final GetCamps getCamps;

  CampsBloc({
    @required this.getCamp,
    @required this.getCamps,
  }) : super(Empty());

  @override
  Stream<CampState> mapEventToState(
    CampEvent event,
  ) async* {
    if (event is RefreshCamps) {
      yield Loading();
      final campOrFailure = await getCamps();
      yield campOrFailure.fold(
        (failure) {
          return Error(message: _mapFailureToMessage(failure));
        },
        (freizeiten) {
          if (GetStorage().read("campFilterStartDate") != "" ||
              GetStorage().read("campFilterAge") != 0 ||
              GetStorage().read("campFilterPrice") != 0) {
            return LoadedCamps(_filterCamps(freizeiten));
          }
          return LoadedCamps(freizeiten);
        },
      );
    } else if (event is GettingCamp) {
      yield Loading();
      final campsOrFailure = await getCamp(freizeit: event.camp);
      yield campsOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (freizeit) => LoadedCamp(freizeit),
      );
    } else if (event is FilteringCamps) {
      yield Loading();
      final campsOrFailure = await getCamps();
      yield campsOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (freizeiten) {
          List<Camp> filteredCamps = _filterCamps(freizeiten);
          return FilteredCamps(filteredCamps);
        },
      );
    }
  }

  List<Camp> _filterCamps(List<Camp> filteredCamps) {
    final prefs = GetStorage();

    if (prefs.read("campFilterStartDate") != "" &&
        prefs.read("campFilterEndDate") != "") {
      print("Camps Bloc: Filtering by date");
      filteredCamps = filteredCamps
          .where((element) => element.startDate
              .isAfter(DateTime.tryParse(prefs.read("campFilterStartDate"))))
          .toList();
      filteredCamps = filteredCamps
          .where((element) => element.endDate
              .isBefore(DateTime.tryParse(prefs.read("campFilterEndDate"))))
          .toList();
    }
    // Filtering by age
    if (prefs.read("campFilterAge") != 0) {
      print("Camps Bloc: Filtering by age");
      filteredCamps = filteredCamps
          .where((element) =>
              element.ageFrom <= prefs.read("campFilterAge") &&
              element.ageTo >= prefs.read("campFilterAge"))
          .toList();
    }
    // Filtering by price
    if (prefs.read("campFilterPrice") != 0) {
      print("Camps Bloc: Filtering by price");
      filteredCamps = filteredCamps
          .where((element) => element.price <= prefs.read("campFilterPrice"))
          .toList();
    }

    return filteredCamps;
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
