// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/readonly_service.dart';
import './bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final ReadOnlyCachedService<Employee, String> employeeService;

  EmployeesBloc({required this.employeeService}) : super(Empty()) {
    on<RefreshEmployees>(_loadEmployees);
    on<GettingEmployee>(_loadSpecificEmployee);
    on<GetCachedEmployees>(_loadCachedEmployees);
  }

  void _loadEmployees(
      RefreshEmployees event, Emitter<EmployeesState> emit) async {
    print("Triggered Event: RefreshHauptamtliche");
    emit(Loading());
    final hauptamtlicheOrFailure = await employeeService.getAllElements();
    emit(hauptamtlicheOrFailure.fold(
      (failure) {
        print("Error");
        if (failure is ConnectionFailure) {
          return NetworkError(message: failure.getErrorMsg());
        }
        return Error(message: failure.getErrorMsg());
      },
      (hauptamtliche) {
        print("Succes. Returning LoadedHauptamtliche");
        return LoadedEmployees(hauptamtliche);
      },
    ));
  }

  void _loadCachedEmployees(
      GetCachedEmployees event, Emitter<EmployeesState> emit) async {
    print("Triggered Event: RefreshHauptamtliche");
    emit(Loading());
    final hauptamtlicheOrFailure = await employeeService.getAllCachedElements();
    emit(hauptamtlicheOrFailure.fold(
      (failure) {
        print("Error");

        return Error(message: failure.getErrorMsg());
      },
      (hauptamtliche) {
        print("Succes. Returning LoadedHauptamtliche");
        return LoadedEmployees(hauptamtliche);
      },
    ));
  }

  void _loadSpecificEmployee(
      GettingEmployee event, Emitter<EmployeesState> emit) async {
    emit(Loading());
    final hauptamtlicheOrFailure =
        await employeeService.getElement(id: event.name);
    emit(hauptamtlicheOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (hauptamtlicher) => LoadedEmployee(hauptamtlicher),
    ));
  }
}
