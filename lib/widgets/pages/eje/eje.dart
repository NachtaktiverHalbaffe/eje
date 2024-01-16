import 'package:eje/utils/injection_container.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_bloc.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_event.dart';
import 'package:eje/widgets/pages/fields_of_work/fields_of_work.dart';
import 'package:eje/widgets/pages/bak/bak.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_bloc.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_event.dart';
import 'package:eje/widgets/pages/employees/bloc/employees_bloc.dart';
import 'package:eje/widgets/pages/employees/bloc/employees_event.dart';
import 'package:eje/widgets/pages/employees/employees.dart';
import 'package:eje/widgets/pages/offeredServices/bloc/services_bloc.dart';
import 'package:eje/widgets/pages/offeredServices/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Eje extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeesBloc>(
          create: (_) => sl<EmployeesBloc>(),
        ),
        BlocProvider<BakBloc>(
          create: (_) => sl<BakBloc>(),
        ),
        BlocProvider<FieldsOfWorkBloc>(
          create: (_) => sl<FieldsOfWorkBloc>(),
        ),
        BlocProvider<ServicesBloc>(
          create: (_) => sl<ServicesBloc>(),
        ),
      ],
      child: EjeChildWidgets(),
    );
  }
}

class EjeChildWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          child: ListView(
            physics: ScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: <Widget>[
              SizedBox(height: 20),
              Employees(),
              SizedBox(height: 20),
              BAK(),
              SizedBox(height: 20),
              FieldsOfWork(),
              SizedBox(height: 20),
              OfferedServices(),
              SizedBox(height: 20),
            ],
          ),
          onRefresh: () async {
            BlocProvider.of<FieldsOfWorkBloc>(context)
                .add(RefreshFieldsOfWork());
            BlocProvider.of<EmployeesBloc>(context).add(RefreshEmployees());
            BlocProvider.of<BakBloc>(context).add(RefreshBAK());
            BlocProvider.of<ServicesBloc>(context).add(RefreshServices());
          }),
    );
  }
}
