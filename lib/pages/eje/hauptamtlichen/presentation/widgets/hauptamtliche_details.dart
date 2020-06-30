import 'package:eje/core/widgets/LoadingIndicator.dart';
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
  return ListView(
    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
    children: <Widget>[
      Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 450,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage(hauptamtlicher.bild),
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
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      hauptamtlicher.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 32 ,
                        fontWeight: FontWeight.bold,
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
                  )
                ],
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ],
      ),
      SizedBox(height: 8),
      Container(
        padding: EdgeInsets.only(left:14,top:12),
        child: Text(
          hauptamtlicher.bereich,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 21,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(14),
        child: Text(
          hauptamtlicher.vorstellung,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      Divider(),
      ListTile(
        leading: Image(
          image: ExactAssetImage("assets/images/icons8_threema_48.png"),
          width: 24,
          height: 24,
          color: Theme.of(context).dividerColor,
        ),
        title: Text(
          hauptamtlicher.threema,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.email,
          size: 24,
        ),
        title: Text(
          hauptamtlicher.email,
          style: TextStyle(fontSize: 14),
        ),
        dense: true,
      ),
      ListTile(
        leading: Icon(
          MdiIcons.phone,
          size: 24,
        ),
        title: Text(
          hauptamtlicher.telefon,
          style: TextStyle(fontSize: 14),
        ),
        dense: true,
      ),
      ListTile(
        leading: Icon(
          MdiIcons.cellphone,
          size: 24,
        ),
        title: Text(
          hauptamtlicher.handy,
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
