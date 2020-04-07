import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCardDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class NeuigkeitenCard extends StatelessWidget {
  final Neuigkeit _neuigkeit;
  final int index;
  String TAG_BILD;
  String TAG_TITEL;

  NeuigkeitenCard(this._neuigkeit, this.index);

  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    TAG_BILD = "BILD" + index.toString();
    TAG_TITEL = "TITEL" + index.toString();
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.all(Radius.circular(12)),
        child: new Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: sl<NeuigkeitenBlocBloc>(),
                    child:
                        neuigkeitenCardDetail(_neuigkeit, TAG_BILD, TAG_TITEL),
                  ),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: PageView.builder(
                  physics: ScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  pageSnapping: true,
                  controller: PageController(initialPage: 0),
                  itemCount: _neuigkeit.bilder.length,
                  itemBuilder: (context, position) {
                    final bild = _neuigkeit.bilder[position];
                    return Hero(
                      tag: TAG_BILD,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(bild),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // ignore: missing_return
            Container(child: () {
              if (_neuigkeit.bilder.length != 1) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: CirclePageIndicator(
                    size: 5,
                    selectedSize: 7.5,
                    dotColor: Colors.white,
                    selectedDotColor: Theme.of(context).accentColor,
                    itemCount: _neuigkeit.bilder.length,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                );
              }
            }()),
            Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.black,
                    Colors.black87,
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: sl<NeuigkeitenBlocBloc>(),
                    child:
                        neuigkeitenCardDetail(_neuigkeit, TAG_BILD, TAG_TITEL),
                  ),
                ),
              ),
              child: Theme(
                data: theme,
                child: ExpansionTile(
                  title: new Hero(
                    tag: TAG_TITEL,
                    child: Text(
                      _neuigkeit.titel.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
                  ),
                  children: <Widget>[
                    //Inhalt, der gezeigt wird wenn expanded
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: SingleChildScrollView(
                            child: Text(
                              _neuigkeit.text_preview.toString(),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
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
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
