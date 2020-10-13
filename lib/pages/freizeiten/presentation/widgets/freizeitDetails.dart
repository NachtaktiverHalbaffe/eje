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

  return ListView(
    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
    children: <Widget>[
      Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: PageView.builder(
              physics: ScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              onPageChanged: (int index) {
                _currentPageNotifier.value = index;
              },
              pageSnapping: true,
              controller: PageController(initialPage: 0),
              itemCount: freizeit.bilder.length,
              itemBuilder: (context, position) {
                final bild = freizeit.bilder[position];
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: ExactAssetImage(bild),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // ignore: missing_return
          Container(
              alignment: Alignment.center,
              child: () {
                if (freizeit.bilder.length != 1) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: CirclePageIndicator(
                      size: 5,
                      selectedSize: 7.5,
                      dotColor: Colors.white,
                      selectedDotColor: Theme.of(context).accentColor,
                      itemCount: freizeit.bilder.length,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  );
                }
              }()),
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
                    freizeit.freizeit,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 32,
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
              freizeit.motto != null
                  ? Container(
                      padding: EdgeInsets.only(left: 14, top: 12),
                      child: Text(
                        freizeit.motto,
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
                    )
                  : SizedBox(height: 2),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
      SizedBox(height: 8),
      freizeit.beschreibung != null
          ? Container(
              padding: EdgeInsets.all(14),
              child: Text(
                freizeit.beschreibung,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          : SizedBox(height: 8),
      Divider(),
      ListTile(
        leading: Icon(
          Icons.today,
          size: 24,
        ),
        title: Text(
          freizeit.datum,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.currencyEur,
          size: 24,
        ),
        title: Text(
          freizeit.preis,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.mapMarker,
          size: 24,
        ),
        title: Text(
          freizeit.ort.Anschrift +
              "\n" +
              freizeit.ort.Strasse +
              "\n" +
              freizeit.ort.PLZ,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.cakeVariant,
          size: 24,
        ),
        title: Text(
          freizeit.alter,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.silverwareForkKnife,
          size: 24,
        ),
        title: Text(
          freizeit.verpflegung,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.home,
          size: 24,
        ),
        title: Text(
          freizeit.unterbringung,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.carSide,
          size: 24,
        ),
        title: Text(
          freizeit.anreise,
          style: TextStyle(fontSize: 14),
        ),
      ),
      GestureDetector(
        onTap: () async {
          if (await canLaunch(freizeit.link)) {
            await launch(freizeit.link);
          } else {
            throw 'Could not launch $freizeit.link';
          }
        },
        child: ListTile(
          leading: Icon(
            MdiIcons.fileDocumentEditOutline,
            size: 24,
          ),
          title: Text(
            freizeit.anmeldeschluss,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 12,
      )
    ],
  );
}
