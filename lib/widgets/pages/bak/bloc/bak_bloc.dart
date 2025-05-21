// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/bakler.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/readonly_service.dart';
import './bloc.dart';

class BakBloc extends Bloc<BakEvent, BakState> {
  final ReadOnlyCachedService<BAKler, String> bakSerivce;

  BakBloc({required this.bakSerivce}) : super(Empty()) {
    on<RefreshBAK>(_loadBAKler);
    on<GettingBAKler>(_loadSpecificBAKler);
    on<GetCachedBAKler>(_getCachedBAKler);
  }

  void _loadBAKler(RefreshBAK event, Emitter<BakState> emit) async {
    print("Triggered Event: RefreshBak");
    emit(Loading());
    final bakOrFailure = await bakSerivce.getAllElements();
    emit(bakOrFailure.fold(
      (failure) {
        print("Error");
        if (failure is ConnectionFailure) {
          return NetworkError(message: failure.getErrorMsg());
        }
        return Error(message: failure.getErrorMsg());
      },
      (bak) {
        print("Succes. Returning LoadedHauptamtliche");
        return LoadedBAK(bak);
      },
    ));
  }

  void _getCachedBAKler(GetCachedBAKler event, Emitter<BakState> emit) async {
    print("Triggered Event: RefreshBak");
    emit(Loading());
    final bakOrFailure = await bakSerivce.getAllCachedElements();
    emit(bakOrFailure.fold(
      (failure) {
        print("Error");
        return Error(message: failure.getErrorMsg());
      },
      (bak) {
        print("Succes. Returning LoadedHauptamtliche");
        return LoadedBAK(bak);
      },
    ));
  }

  void _loadSpecificBAKler(GettingBAKler event, Emitter<BakState> emit) async {
    emit(Loading());
    final bakOrFailure = await bakSerivce.getElement(id: event.name);
    emit(bakOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (bakler) => LoadedBAKler(bakler),
    ));
  }
}
