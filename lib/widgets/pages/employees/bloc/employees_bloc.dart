// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/services/EmployeeService.dart';
import './bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeeService employeeService;

  EmployeesBloc({required this.employeeService}) : super(Empty()) {
    on<RefreshEmployees>(_loadEmployees);
    on<GettingEmployee>(void_loadSpecificEmployee);
  }

  void _loadEmployees(event, Emitter<EmployeesState> emit) async {
    print("Triggered Event: RefreshHauptamtliche");
    emit(Loading());
    final hauptamtlicheOrFailure = await employeeService.getEmployees();
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

  void_loadSpecificEmployee(event, Emitter<EmployeesState> emit) async {
    emit(Loading());
    final hauptamtlicheOrFailure =
        await employeeService.getEmployee(name: event.name);
    emit(hauptamtlicheOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (hauptamtlicher) => LoadedEmployee(hauptamtlicher),
    ));
  }
}
