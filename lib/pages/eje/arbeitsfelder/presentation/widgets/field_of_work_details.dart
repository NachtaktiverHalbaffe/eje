import 'package:eje/pages/articles/presentation/widgets/details_page.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/articles/domain/entity/hyperlink.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/field_of_work.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/fields_of_work_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/fields_of_work_event.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/fields_of_work_state.dart';
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is Empty) {
            print("Build page FieldOfWork: Empty");
            BlocProvider.of<FieldsOfWorkBloc>(context)
                .add(GettingFieldOfWork(name.name));
            return LoadingIndicator();
          } else if (state is Loading) {
            print("Build page FieldOfWork: Loading");
            return LoadingIndicator();
          } else if (state is LoadedFieldOfWork) {
            print("Build page FieldOfWork: LoadedFieldOfWork");
            return FieldOfWorkDetailsCard(state.fieldOfWork);
          } else {
            print("Build page FieldOfWork: Undefined");
            BlocProvider.of<FieldsOfWorkBloc>(context)
                .add(GettingFieldOfWork(name.name));
            return LoadingIndicator();
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
