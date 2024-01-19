import 'package:eje/models/Hyperlink.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_bloc.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_event.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldOfWorkDetails extends StatelessWidget {
  final FieldOfWork name;
  FieldOfWorkDetails(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FieldsOfWorkBloc, FieldOfWorkState>(
        listener: (context, state) {
          if (state is Error) {
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is Empty) {
            print("Build page FieldOfWork: Empty");
            BlocProvider.of<FieldsOfWorkBloc>(context)
                .add(GettingFieldOfWork(name.name));
            return Center();
          } else if (state is Loading) {
            print("Build page FieldOfWork: Loading");
            return LoadingIndicator();
          } else if (state is LoadedFieldOfWork) {
            print("Build page FieldOfWork: LoadedFieldOfWork");
            return FieldOfWorkDetailsCard(state.fieldOfWork);
          } else {
            print("Build page FieldOfWork: Undefined");
            AlertSnackbar(context).showErrorSnackBar(
                label:
                    "Konnte Details zum Arbeitsfeld nicht laden: Unbekannter Fehler");
            Navigator.pop(context);
            return NoResultCard(
              label:
                  "Konnte Details zum Arbeitsfeld nicht laden: Unbekannter Fehler",
              onRefresh: () async {
                BlocProvider.of<FieldsOfWorkBloc>(context)
                    .add(GettingFieldOfWork(name.name));
              },
            );
          }
        },
      ),
    );
  }
}

class FieldOfWorkDetailsCard extends StatelessWidget {
  final FieldOfWork fieldOfWork;
  FieldOfWorkDetailsCard(this.fieldOfWork);

  @override
  Widget build(BuildContext context) {
    return DetailsPage(
      titel: fieldOfWork.name,
      text: fieldOfWork.description,
      bilder: fieldOfWork.images,
      untertitel: "",
      hyperlinks: [Hyperlink(link: "", description: "")],
      childWidget:
          SizedBox(height: 36 / MediaQuery.of(context).devicePixelRatio),
    );
  }
}
