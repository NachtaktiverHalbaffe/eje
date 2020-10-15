import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/freizeiten_bloc.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/freizeiten_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FreizeitDetails extends StatefulWidget {
  final Freizeit freizeit;
  final bool isCacheEnabled;

  FreizeitDetails(this.freizeit, this.isCacheEnabled);

  @override
  _FreizeitDetailsState createState() =>
      _FreizeitDetailsState(isCacheEnabled, freizeit);
}

class _FreizeitDetailsState extends State<FreizeitDetails> {
  final bool isCacheEnabled;
  final Freizeit freizeit;

  _FreizeitDetailsState(this.isCacheEnabled, this.freizeit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FreizeitenBloc, FreizeitenState>(
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
          BlocProvider.of<FreizeitenBloc>(context)
              .add(GettingFreizeit(freizeit));
          return LoadingIndicator();
        } else if (state is LoadedFreizeit) {
          return FreizeitDetailsCard(
              state.freizeit, widget.isCacheEnabled, context);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<FreizeitenBloc>(context).add(GettingFreizeit(freizeit));
  }
}

Widget FreizeitDetailsCard(
    Freizeit freizeit, bool isCacheEnabled, BuildContext context) {
  final _currentPageNotifier = ValueNotifier<int>(0);
  return DetailsPage(
    titel: freizeit.freizeit,
    untertitel: freizeit.motto,
    text: freizeit.beschreibung,
    bild_url: freizeit.bilder,
    context: context,
    childWidget: _freizeitChildWidget(freizeit, context),
  );
}

Widget _freizeitChildWidget(Freizeit freizeit, BuildContext context) {
  return Column(
    children: [
      Divider(),
      ListTile(
        leading: Icon(
          Icons.today,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          freizeit.datum,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.currencyEur,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          freizeit.preis,
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
          freizeit.ort.Anschrift +
              "\n" +
              freizeit.ort.Strasse +
              "\n" +
              freizeit.ort.PLZ,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.cakeVariant,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          freizeit.alter,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.silverwareForkKnife,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          freizeit.verpflegung,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.home,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          freizeit.unterbringung,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.carSide,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: Text(
          freizeit.anreise,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.fileDocumentEditOutline,
          size: 72 / MediaQuery.of(context).devicePixelRatio,
        ),
        title: OutlineButton(
          onPressed: () async {
            if (await canLaunch(freizeit.link)) {
              await launch(freizeit.link);
            } else {
              throw 'Could not launch $freizeit.link';
            }
          },
          child: Text(
              "Anmelden (Anmeldeschluss: " + freizeit.anmeldeschluss + ")"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  30 / MediaQuery.of(context).devicePixelRatio)),
        ),
      ),
      SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      )
    ],
  );
}
