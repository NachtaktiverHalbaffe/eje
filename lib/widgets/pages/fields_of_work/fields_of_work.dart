import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_bloc.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_event.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_state.dart';
import 'package:eje/widgets/pages/fields_of_work/fields_of_work_pageviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldsOfWork extends StatelessWidget {
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
              "Arbeitsfelder",
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
        BlocConsumer<FieldsOfWorkBloc, FieldOfWorkState>(
          listener: (context, state) {
            if (state is Error) {
              AlertSnackbar(context).showErrorSnackBar(label: state.message);
            } else if (state is NetworkError) {
              AlertSnackbar(context).showWarningSnackBar(label: state.message);
            }
          },
          builder: (context, state) {
            if (state is Empty) {
              print("Build page: Arbeitsbereiche Empty");
              BlocProvider.of<FieldsOfWorkBloc>(context)
                  .add(RefreshFieldsOfWork());
              return LoadingIndicator();
            }
            if (state is Loading) {
              print("Build page: Arbeitsbereiche Loading");
              return LoadingIndicator();
            } else if (state is LoadedFieldsOfWork) {
              print("Build page: LoadedArbeitsbereiche");
              return state.fieldsOfWork.isNotEmpty
                  ? FieldsOfWorkPageViewer(fieldsOfWork: state.fieldsOfWork)
                  : NoResultCard(
                      label: "Fehler beim Laden der Hauptamtliche",
                      scale: 0.4,
                      onRefresh: () async {
                        BlocProvider.of<FieldsOfWorkBloc>(context)
                            .add(RefreshFieldsOfWork());
                      });
            } else if (state is Error) {
              return NoResultCard(
                  label: state.message,
                  scale: 0.4,
                  onRefresh: () async {
                    BlocProvider.of<FieldsOfWorkBloc>(context)
                        .add(RefreshFieldsOfWork());
                  });
            } else if (state is NetworkError) {
              BlocProvider.of<FieldsOfWorkBloc>(context).add(GetCachedEvents());
              return LoadingIndicator();
            } else {
              return Center();
            }
          },
        ),
      ],
    );
  }
}
