import 'package:eje/core/utils/MapLauncher.dart';
import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/freizeiten_bloc.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/freizeiten_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class FreizeitDetails extends StatefulWidget {
  final Freizeit freizeit;
  FreizeitDetails(this.freizeit);

  @override
  _FreizeitDetailsState createState() => _FreizeitDetailsState(freizeit);
}

class _FreizeitDetailsState extends State<FreizeitDetails> {
  final Freizeit freizeit;
  _FreizeitDetailsState(this.freizeit);

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
          return FreizeitDetailsCard(freizeit: state.freizeit);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<FreizeitenBloc>(context).add(GettingFreizeit(freizeit));
  }
}

class FreizeitDetailsCard extends StatelessWidget {
  final Freizeit freizeit;
  const FreizeitDetailsCard({Key key, this.freizeit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsPage(
      titel: freizeit.freizeit,
      untertitel: freizeit.motto,
      text: freizeit.beschreibung,
      bild_url: freizeit.bilder,
      hyperlinks: [Hyperlink(link: "", description: "")],
      childWidget: _freizeitChildWidget(freizeit: freizeit),
    );
  }
}

class _freizeitChildWidget extends StatelessWidget {
  final Freizeit freizeit;
  const _freizeitChildWidget({Key key, this.freizeit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          leading: Icon(
            Icons.today,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            freizeit.datum,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.currencyEur,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            freizeit.preis,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.mapMarker,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            freizeit.ort.Anschrift +
                "\n" +
                freizeit.ort.Strasse +
                "\n" +
                freizeit.ort.PLZ,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
            ),
          ),
          trailing: GestureDetector(
            child: Icon(
              MdiIcons.navigation,
              color: Theme.of(context).accentColor,
            ),
            onTap: () async {
              await MapLauncher.launchQuery(freizeit.ort.Anschrift +
                  "," +
                  freizeit.ort.Strasse +
                  ", " +
                  freizeit.ort.PLZ);
            },
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.cakeVariant,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            freizeit.alter,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.silverwareForkKnife,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            freizeit.verpflegung,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.home,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            freizeit.unterbringung,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.carSide,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            freizeit.anreise,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.fileDocumentEditOutline,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: OutlineButton(
            color: Theme.of(context).dividerColor,
            onPressed: () async {
              if (await canLaunch(freizeit.link)) {
                await launch(freizeit.link);
              } else {
                throw 'Could not launch $freizeit.link';
              }
            },
            child: Text(
              "Anmelden (Anmeldeschluss: " + freizeit.anmeldeschluss + ")",
              style: TextStyle(
                color: Theme.of(context).dividerColor,
              ),
            ),
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
}
