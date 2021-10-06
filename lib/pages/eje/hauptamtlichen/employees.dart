import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/employees_bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/employees_state.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/widgets/employees_pageviewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Employees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 24,
            ),
            Text(
              "Hauptamtliche",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 84 / MediaQuery.of(context).devicePixelRatio,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        BlocConsumer<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
            if (state is Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is Empty) {
              print("Build page: Hauptamtliche Empty");
              BlocProvider.of<EmployeesBloc>(context).add(RefreshEmployees());
              return LoadingIndicator();
            }
            if (state is Loading) {
              print("Build page: Hauptamtliche Loading");
              return LoadingIndicator();
            } else if (state is LoadedEmployees) {
              print("Build page: LoadedHauptamtliche");
              return EmployeesPageViewer(state.hauptamtliche);
            } else if (state is Error) {
              return Center();
            } else {
              return Center();
            }
          },
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
