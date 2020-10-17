import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HauptamtlicheDetails extends StatefulWidget {
  final bool isCacheEnabled;
  final Hauptamtlicher hauptamtlicher;

  HauptamtlicheDetails(this.isCacheEnabled, this.hauptamtlicher);

  @override
  _HauptamtlicheDetailsState createState() =>
      _HauptamtlicheDetailsState(isCacheEnabled, hauptamtlicher);
}

class _HauptamtlicheDetailsState extends State<HauptamtlicheDetails> {
  final bool isCacheEnabled;
  final Hauptamtlicher hauptamtlicher;

  _HauptamtlicheDetailsState(this.isCacheEnabled, this.hauptamtlicher);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HauptamtlicheBloc, HauptamtlicheState>(
          listener: (context, state) {
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
        } else if (state is LoadedHauptamtlicher) {
          return HauptamtlicheDetailsCard(
              state.hauptamtlicher, widget.isCacheEnabled, context);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<HauptamtlicheBloc>(context)
        .add(GettingHauptamtlicher(hauptamtlicher.name));
  }
}

Widget HauptamtlicheDetailsCard(
    Hauptamtlicher hauptamtlicher, bool isCacheEnabled, BuildContext context) {
  List<String> bilder = List();
  bilder.add(hauptamtlicher.bild);
  return DetailsPage(
      titel: hauptamtlicher.name,
      untertitel: hauptamtlicher.bereich,
      bild_url: bilder,
      pixtureHeight: 1200,
      text: hauptamtlicher.vorstellung,
      context: context,
      hyperlinks: [Hyperlink(link: "", description: "")],
      childWidget: _childHauptamtlicheDetails(hauptamtlicher, context));
}

Widget _childHauptamtlicheDetails(
    Hauptamtlicher hauptamtlicher, BuildContext context) {
  return Column(
    children: [
      Divider(),
      ListTile(
        leading: Image(
          image: ExactAssetImage("assets/images/icons8_threema_48.png"),
          width: 72 / MediaQuery.of(context).devicePixelRatio,
          height: 72 / MediaQuery.of(context).devicePixelRatio,
          color: Theme.of(context).dividerColor,
        ),
        title: Text(
          hauptamtlicher.threema,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.email,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          hauptamtlicher.email,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
        dense: true,
      ),
      ListTile(
        leading: Icon(
          MdiIcons.phone,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          hauptamtlicher.telefon,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
        dense: true,
      ),
      ListTile(
        leading: Icon(
          MdiIcons.cellphone,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          hauptamtlicher.handy,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
        dense: true,
      ),
      SizedBox(
        height: 42 / MediaQuery.of(context).devicePixelRatio,
      )
    ],
  );
}
