import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/employees/bloc/employees_bloc.dart';
import 'package:eje/widgets/pages/employees/bloc/employees_event.dart';
import 'package:eje/widgets/pages/employees/bloc/employees_state.dart';
import 'package:eje/widgets/pages/employees/employees_pageviewer.dart';
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
              AlertSnackbar(context).showErrorSnackBar(label: state.message);
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
              return state.hauptamtliche.isNotEmpty
                  ? EmployeesPageViewer(state.hauptamtliche)
                  : NoResultCard(
                      label: "Fehler beim Laden der Hauptamtliche",
                      scale: 0.4,
                      onRefresh: () async {
                        BlocProvider.of<EmployeesBloc>(context)
                            .add(RefreshEmployees());
                      });
            } else if (state is Error) {
              return NoResultCard(
                  label: state.message,
                  scale: 0.4,
                  onRefresh: () async {
                    BlocProvider.of<EmployeesBloc>(context)
                        .add(RefreshEmployees());
                  });
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
