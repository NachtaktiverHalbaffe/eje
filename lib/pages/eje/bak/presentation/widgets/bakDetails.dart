import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_event.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BAKDetails extends StatefulWidget {
  final bool isCacheEnabled;
  final BAKler bakler;

  BAKDetails(this.isCacheEnabled, this.bakler);

  @override
  _BAKDetailsState createState() => _BAKDetailsState(isCacheEnabled, bakler);
}

class _BAKDetailsState extends State<BAKDetails> {
  final bool isCacheEnabled;
  final BAKler bakler;

  _BAKDetailsState(this.isCacheEnabled, this.bakler);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BakBloc, BakState>(listener: (context, state) {
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
        } else if (state is LoadedBAKler) {
          return HauptamtlicheDetailsCard(
              state.bakler, widget.isCacheEnabled, context);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<BakBloc>(context).add(GettingBAKler(bakler.name));
  }
}

Widget HauptamtlicheDetailsCard(
    BAKler bakler, bool isCacheEnabled, BuildContext context) {
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
                image: ExactAssetImage(bakler.bild),
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
                      bakler.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 32,
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
        padding: EdgeInsets.only(left: 14, top: 12),
        child: Text(
          bakler.amt,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 21,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(14),
        child: Text(
          bakler.vorstellung,
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
          bakler.threema,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.email,
          size: 24,
        ),
        title: Text(
          bakler.email,
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
