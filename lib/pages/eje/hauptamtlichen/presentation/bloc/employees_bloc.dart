// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/get_employees.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/get_employee.dart';
import './bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetEmployees getEmployees;
  final GetEmployee getEmployee;

  EmployeesBloc({
    required this.getEmployees,
    required this.getEmployee,
  }) : super(Empty()) {
    on<RefreshEmployees>(_loadEmployees);
    on<GettingEmployee>(void_loadSpecificEmployee);
  }

  void _loadEmployees(event, Emitter<EmployeesState> emit) async {
    print("Triggered Event: RefreshHauptamtliche");
    final hauptamtlicheOrFailure = await getEmployees();
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
    final hauptamtlicheOrFailure = await getEmployee(name: event.name);
    emit(hauptamtlicheOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (hauptamtlicher) => LoadedEmployee(hauptamtlicher),
    ));
  }
}
