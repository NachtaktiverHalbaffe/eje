// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/services/ReadOnlyService.dart';
import './bloc.dart';

class FieldsOfWorkBloc extends Bloc<FieldsOfWorkEvent, FieldOfWorkState> {
  final ReadOnlyService<FieldOfWork, String> fieldsOfWorkService;

  FieldsOfWorkBloc({required this.fieldsOfWorkService}) : super(Empty()) {
    on<RefreshFieldsOfWork>(_loadFOW);
    on<GettingFieldOfWork>(_loadSpecificFOW);
  }

  void _loadFOW(event, Emitter<FieldOfWorkState> emit) async {
    print("Triggered Event: RefreshArbeitsbereiche");
    emit(Loading());
    final fieldsOfWorkOrFailure = await fieldsOfWorkService.getAllElements();
    emit(fieldsOfWorkOrFailure.fold(
      (failure) {
        print("Error");
        return Error(message: failure.getErrorMsg());
      },
      (arbeitsbereiche) {
        print("Succes. Returning LoadedArbeitsbereiche");
        return LoadedFieldsOfWork(arbeitsbereiche);
      },
    ));
  }

  void _loadSpecificFOW(event, Emitter<FieldOfWorkState> emit) async {
    emit(Loading());
    final fieldOfWorkOrFailure =
        await fieldsOfWorkService.getElement(id: event.name);
    emit(fieldOfWorkOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (arbeitsfeld) => LoadedFieldOfWork(arbeitsfeld),
    ));
  }
}