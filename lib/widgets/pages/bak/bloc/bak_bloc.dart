// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/services/ReadOnlyService.dart';
import './bloc.dart';

class BakBloc extends Bloc<BakEvent, BakState> {
  final ReadOnlyService<BAKler, String> bakSerivce;

  BakBloc({required this.bakSerivce}) : super(Empty()) {
    on<RefreshBAK>(_loadBAKler);
    on<GettingBAKler>(_loadSpecificBAKler);
  }

  void _loadBAKler(event, Emitter<BakState> emit) async {
    print("Triggered Event: RefreshBak");
    emit(Loading());
    final bakOrFailure = await bakSerivce.getAllElements();
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

  void _loadSpecificBAKler(event, Emitter<BakState> emit) async {
    emit(Loading());
    final bakOrFailure = await bakSerivce.getElement(id: event.name);
    emit(bakOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (bakler) => LoadedBAKler(bakler),
    ));
  }
}
