import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/presentation/bloc/bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TerminDetails extends StatefulWidget {
  final Termin termin;
  final bool isCacheEnabled;

  TerminDetails(this.termin, this.isCacheEnabled);

  @override
  _TerminDetailsState createState() =>
      _TerminDetailsState(isCacheEnabled, termin);
}

class _TerminDetailsState extends State<TerminDetails> {
  final bool isCacheEnabled;
  final Termin termin;

  _TerminDetailsState(this.isCacheEnabled, this.termin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TermineBloc, TermineState>(listener: (context, state) {
        if (state is Error) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
          // ignore: missing_return
          builder: (context, state) {
        if (state is Loading) {
          return LoadingIndicator();
        } else if (state is LoadedTermin) {
          return TerminDetailsCard(
              state.termin, widget.isCacheEnabled, context);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<TermineBloc>(context)
        .add(GettingTermin(termin.veranstaltung, termin.datum));
  }
}

Widget TerminDetailsCard(
    Termin termin, bool isCacheEnabled, BuildContext context) {
  List<String> bilder = List();
  bilder.add(termin.bild);
  return DetailsPage(
    titel: termin.veranstaltung,
    untertitel: termin.motto,
    text: termin.text,
    bild_url: bilder,
    hyperlinks: [Hyperlink(link: "", description: "")],
    childWidget: _terminChildWidget(termin, context),
  );
}

Widget _terminChildWidget(Termin _termin, BuildContext context) {
  return Column(
    children: [
      Divider(),
      ListTile(
        leading: Icon(
          Icons.today,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          _termin.datum,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.mapMarker,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          _termin.ort.Anschrift +
              "\n" +
              _termin.ort.Strasse +
              "\n" +
              _termin.ort.PLZ,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
        dense: true,
      ),
      SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      ),
      Container(
        margin: EdgeInsets.all(24 / MediaQuery.of(context).devicePixelRatio),
        child: OutlineButton(
          onPressed: () {},
          child: Text("Veranstaltung merken"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  36 / MediaQuery.of(context).devicePixelRatio)),
        ),
      ),
      SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      ),
    ],
  );
}
