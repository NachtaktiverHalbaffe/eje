import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/presentation/bloc/bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TerminDetails extends StatefulWidget{
 final Termin termin;
 final bool isCacheEnabled;

 TerminDetails(this.termin, this.isCacheEnabled);

  @override
  _TerminDetailsState createState() => _TerminDetailsState(isCacheEnabled, termin);
}

class _TerminDetailsState extends State<TerminDetails> {
  final bool isCacheEnabled;
  final Termin termin;

  _TerminDetailsState(this.isCacheEnabled, this.termin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TermineBloc, TermineState>(
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
        .add(GettingTermin(termin.veranstaltung,termin.datum));
  }
}

Widget TerminDetailsCard(
    Termin termin, bool isCacheEnabled, BuildContext context) {
  return ListView(
    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
    children: <Widget>[
      Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage(termin.bild),
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            top: 16.0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: IconShadowWidget(
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
                showShadow: true,
                shadowColor: Colors.black,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 14,
                  ),
                  Text(
                    termin.veranstaltung,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              termin.motto!=null ? Container(
                padding: EdgeInsets.only(left:14,top:12),
                child: Text(
                  termin.motto,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 6.0,
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 6.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ):SizedBox(height: 2),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ],
      ),
      SizedBox(height: 8),
      termin.text!=null ? Container(
        padding: EdgeInsets.all(14),
        child: Text(
          termin.text,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ):SizedBox(height: 8),
      Divider(),
      ListTile(
        leading: Icon(
          Icons.today,
          size: 24,
        ),
        title: Text(
          termin.datum,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.mapMarker,
          size: 24,
        ),
        title: Text(
          termin.ort.Anschrift +"\n"+termin.ort.Strasse +"\n"+termin.ort.PLZ,
          style: TextStyle(fontSize: 14),
        ),
        dense: true,
      ),
      SizedBox(
        height: 12,
      )
    ],
  );
}
