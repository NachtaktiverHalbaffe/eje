// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/readonly_service.dart';
import 'package:get_storage/get_storage.dart';

import './bloc.dart';

class CampsBloc extends Bloc<CampEvent, CampState> {
  final ReadOnlyCachedService<Camp, int> campService;

  CampsBloc({required this.campService}) : super(Empty()) {
    on<RefreshCamps>(_loadCamps);
    on<GettingCamp>(_loadSpecificCamp);
    on<FilteringCamps>(_filterCamps);
    on<DeletingCampsFilter>(_deleteChip);
    on<GetCachedCamps>(_loadCachedCamps);
  }

  void _loadCamps(RefreshCamps event, Emitter<CampState> emit) async {
    emit(Loading());
    final campOrFailure = await campService.getAllElements();
    emit(campOrFailure.fold(
      (failure) {
        if (failure is ConnectionFailure) {
          return NetworkError(message: failure.getErrorMsg());
        }
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

  void _loadCachedCamps(GetCachedCamps event, Emitter<CampState> emit) async {
    emit(Loading());
    final campOrFailure = await campService.getAllCachedElements();
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

  void _loadSpecificCamp(GettingCamp event, Emitter<CampState> emit) async {
    emit(Loading());
    final campsOrFailure = await campService.getElement(id: event.camp.id);
    emit(campsOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (freizeit) => LoadedCamp(freizeit),
    ));
  }

  void _filterCamps(FilteringCamps event, Emitter<CampState> emit) async {
    final campsOrFailure = await campService.getAllElements();
    emit(campsOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (freizeiten) {
        List<Camp> filteredCamps = _getFilteredCamps(freizeiten);
        return FilteredCamps(filteredCamps);
      },
    ));
  }

  void _deleteChip(DeletingCampsFilter event, Emitter<CampState> emit) async {
    final campsOrFailure = await campService.getAllElements();
    emit(campsOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (freizeiten) {
        List<Camp> filteredCamps = _getFilteredCamps(freizeiten);
        return DeletedFilter(filteredCamps);
      },
    ));
  }

  List<Camp> _getFilteredCamps(List<Camp> filteredCamps) {
    final prefs = GetStorage();
    if (prefs.read("campFilterStartDate") != "" &&
        prefs.read("campFilterEndDate") != "") {
      print("Camps Bloc: Filtering by date");

      filteredCamps = filteredCamps
          .where((element) =>
              element.startDate.isAfter(
                  DateTime.tryParse(prefs.read("campFilterStartDate")) ??
                      DateTime.now()) ||
              element.startDate.isAtSameMomentAs(
                  DateTime.tryParse(prefs.read("campFilterStartDate")) ??
                      DateTime.now()))
          .toList();
      filteredCamps = filteredCamps
          .where((element) =>
              element.endDate.isBefore(
                  DateTime.tryParse(prefs.read("campFilterEndDate")) ??
                      DateTime.now()) ||
              element.endDate.isAtSameMomentAs(
                  DateTime.tryParse(prefs.read("campFilterEndDate")) ??
                      DateTime.now()))
          .toList();
    }
    // Filtering by age
    if (prefs.read("campFilterAge") >= 0 &&
        prefs.read("campFilterAge") <= 130) {
      print("Camps Bloc: Filtering by age");
      filteredCamps = filteredCamps
          .where((element) =>
              element.ageFrom <= prefs.read("campFilterAge") &&
              element.ageTo >= prefs.read("campFilterAge"))
          .toList();
    }
    // Filtering by price
    if (prefs.read("campFilterPrice") >= 0) {
      print(prefs.read("campFilterPrice"));
      filteredCamps = filteredCamps
          .where((element) => element.price <= prefs.read("campFilterPrice"))
          .toList();
    }

    return filteredCamps;
  }
}
