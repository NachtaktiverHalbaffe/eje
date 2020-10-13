import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_event.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ArbeitsbereicheDetails extends StatefulWidget {
  final bool isCacheEnabled;
  final Arbeitsbereich arbeitsbereich;

  ArbeitsbereicheDetails(this.isCacheEnabled, this.arbeitsbereich);

  @override
  _ArbeitsbereicheDetailsState createState() =>
      _ArbeitsbereicheDetailsState(isCacheEnabled, arbeitsbereich);
}

class _ArbeitsbereicheDetailsState extends State<ArbeitsbereicheDetails> {
  final bool isCacheEnabled;
  final Arbeitsbereich arbeitsbereich;

  _ArbeitsbereicheDetailsState(this.isCacheEnabled, this.arbeitsbereich);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ArbeitsbereicheBloc, ArbeitsbereicheState>(
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
        } else if (state is LoadedArbeitsbereich) {
          return HauptamtlicheDetailsCard(
              state.arbeitsbereich, widget.isCacheEnabled, context);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<ArbeitsbereicheBloc>(context)
        .add(GettingArbeitsbereich(arbeitsbereich.arbeitsfeld));
  }
}

Widget HauptamtlicheDetailsCard(
    Arbeitsbereich arbeitsbereich, bool isCacheEnabled, BuildContext context) {
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
              itemCount: arbeitsbereich.bilder.length,
              itemBuilder: (context, position) {
                final bild = arbeitsbereich.bilder[position];
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
                if (arbeitsbereich.bilder.length != 1) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: CirclePageIndicator(
                      size: 5,
                      selectedSize: 7.5,
                      dotColor: Colors.white,
                      selectedDotColor: Theme.of(context).accentColor,
                      itemCount: arbeitsbereich.bilder.length,
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
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    arbeitsbereich.arbeitsfeld,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 40,
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
        padding: EdgeInsets.all(14),
        child: Text(
          arbeitsbereich.inhalt,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      SizedBox(
        height: 12,
      )
    ],
  );
}
