// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camp.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camps.dart';
import 'package:get_storage/get_storage.dart';

import './bloc.dart';

class CampsBloc extends Bloc<CampEvent, CampState> {
  final GetCamp getCamp;
  final GetCamps getCamps;

  CampsBloc({
    required this.getCamp,
    required this.getCamps,
  }) : super(Empty()) {
    on<RefreshCamps>(_loadCamps);
    on<GettingCamp>(_loadSpecificCamp);
    on<FilteringCamps>(_filterCamps);
  }

  void _loadCamps(event, Emitter<CampState> emit) async {
    final campOrFailure = await getCamps();
    emit(campOrFailure.fold(
      (failure) {
        return Error(message: failure.getErrorMsg());
      },
      (freizeiten) {
        if (GetStorage().read("campFilterStartDate") != "" ||
            GetStorage().read("campFilterAge") != 0 ||
            GetStorage().read("campFilterPrice") != 0) {
          return LoadedCamps(_getFilteredCamps(freizeiten));
        }
        return LoadedCamps(freizeiten);
      },
    ));
  }

  void _loadSpecificCamp(event, Emitter<CampState> emit) async {
    final campsOrFailure = await getCamp(id: event.camp.id);
    emit(campsOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (freizeit) => LoadedCamp(freizeit),
    ));
  }

  void _filterCamps(event, Emitter<CampState> emit) async {
    final campsOrFailure = await getCamps();
    emit(campsOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (freizeiten) {
        List<Camp> filteredCamps = _getFilteredCamps(freizeiten);
        return FilteredCamps(filteredCamps);
      },
    ));
  }

  List<Camp> _getFilteredCamps(List<Camp> filteredCamps) {
    final prefs = GetStorage();
    if (prefs.read("campFilterStartDate") != "" &&
        prefs.read("campFilterEndDate") != "") {
      print("Camps Bloc: Filtering by date");
      filteredCamps = filteredCamps
          .where((element) => element.startDate.isAfter(
              DateTime.tryParse(prefs.read("campFilterStartDate")) ??
                  DateTime.now()))
          .toList();
      filteredCamps = filteredCamps
          .where((element) => element.endDate.isBefore(
              DateTime.tryParse(prefs.read("campFilterEndDate")) ??
                  DateTime.now()))
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
}
