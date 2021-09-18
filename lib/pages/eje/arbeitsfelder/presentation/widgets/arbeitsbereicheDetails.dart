import 'package:eje/pages/articles/presentation/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_event.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArbeitsbereicheDetails extends StatefulWidget {
  final FieldOfWork arbeitsbereich;

  ArbeitsbereicheDetails(this.arbeitsbereich);

  @override
  _ArbeitsbereicheDetailsState createState() =>
      _ArbeitsbereicheDetailsState(arbeitsbereich);
}

class _ArbeitsbereicheDetailsState extends State<ArbeitsbereicheDetails> {
  final FieldOfWork arbeitsbereich;

  _ArbeitsbereicheDetailsState(this.arbeitsbereich);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ArbeitsbereicheBloc, ArbeitsbereicheState>(
          listener: (context, state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        if (state is Loading) {
          return LoadingIndicator();
        } else if (state is LoadedArbeitsbereich) {
          return HauptamtlicheDetailsCard(state.arbeitsbereich);
        } else
          return Container();
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<ArbeitsbereicheBloc>(context)
        .add(GettingArbeitsbereich(arbeitsbereich.arbeitsfeld));
    super.didChangeDependencies();
  }
}

class HauptamtlicheDetailsCard extends StatelessWidget {
  final FieldOfWork arbeitsbereich;
  HauptamtlicheDetailsCard(this.arbeitsbereich);

  @override
  Widget build(BuildContext context) {
    return DetailsPage(
      titel: arbeitsbereich.arbeitsfeld,
      text: arbeitsbereich.inhalt,
      bilder: arbeitsbereich.bilder,
      untertitel: "",
      hyperlinks: [Hyperlink(link: "", description: "")],
      childWidget:
          SizedBox(height: 36 / MediaQuery.of(context).devicePixelRatio),
    );
  }
}
