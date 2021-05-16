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
import 'package:url_launcher/url_launcher.dart';

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
      pixtureHeight: 400,
      text: hauptamtlicher.vorstellung,
      hyperlinks: [Hyperlink(link: "", description: "")],
      childWidget: _childHauptamtlicheDetails(hauptamtlicher, context));
}

Widget _childHauptamtlicheDetails(
    Hauptamtlicher hauptamtlicher, BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: 12,
      ),
      Divider(),
      hauptamtlicher.threema != ''
          ? ListTile(
              leading: Image(
                image: ExactAssetImage("assets/images/icons8_threema_48.png"),
                width: 24,
                height: 24,
                color: Theme.of(context).dividerColor,
              ),
              title: Text(
                hauptamtlicher.threema,
                style: TextStyle(
                  fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              trailing: GestureDetector(
                child: Icon(
                  MdiIcons.messageReplyText,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  if (await canLaunch(
                      "https://threema.id/" + hauptamtlicher.threema)) {
                    await launch(
                        "https://threema.id/" + hauptamtlicher.threema);
                  } else {
                    throw 'Could not open Threema';
                  }
                },
              ),
            )
          : SizedBox(
              height: 12,
            ),
      hauptamtlicher.email != ''
          ? ListTile(
              leading: Icon(
                MdiIcons.email,
                color: Theme.of(context).dividerColor,
                size: 24,
              ),
              title: Text(
                hauptamtlicher.email,
                style: TextStyle(
                  fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              dense: true,
              trailing: GestureDetector(
                child: Icon(
                  MdiIcons.emailEdit,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  if (await canLaunch("mailto:" + hauptamtlicher.email)) {
                    await launch("mailto:" + hauptamtlicher.email);
                  } else {
                    throw 'Could not open Email';
                  }
                },
              ),
            )
          : SizedBox(
              height: 12,
            ),
      hauptamtlicher.telefon != ''
          ? ListTile(
              leading: Icon(
                MdiIcons.phone,
                color: Theme.of(context).dividerColor,
                size: 24,
              ),
              title: Text(
                hauptamtlicher.telefon,
                style: TextStyle(
                  fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              dense: true,
              trailing: GestureDetector(
                child: Icon(
                  MdiIcons.phoneOutgoing,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  if (await canLaunch("tel:" + hauptamtlicher.telefon)) {
                    await launch("tel:" + hauptamtlicher.telefon);
                  } else {
                    throw 'Could not open telephone';
                  }
                },
              ),
            )
          : SizedBox(
              height: 12,
            ),
      hauptamtlicher.handy != ''
          ? ListTile(
              leading: Icon(
                MdiIcons.cellphone,
                color: Theme.of(context).dividerColor,
                size: 24,
              ),
              title: Text(
                hauptamtlicher.handy,
                style: TextStyle(
                  fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              dense: true,
              trailing: GestureDetector(
                child: Icon(
                  MdiIcons.phoneOutgoing,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  if (await canLaunch("tel:" + hauptamtlicher.handy)) {
                    await launch("tel:" + hauptamtlicher.handy);
                  } else {
                    throw 'Could not open telephone';
                  }
                },
              ))
          : SizedBox(
              height: 12,
            ),
      SizedBox(
        height: 14,
      )
    ],
  );
}
