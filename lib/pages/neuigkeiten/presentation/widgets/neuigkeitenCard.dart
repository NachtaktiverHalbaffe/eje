import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/PrefImage.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCardDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class NeuigkeitenCard extends StatelessWidget {
  final Neuigkeit _neuigkeit;
  final bool isCacheEnabled;

  NeuigkeitenCard(this._neuigkeit, this.isCacheEnabled);
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Container(
      padding: EdgeInsets.only(
        left: 36 / MediaQuery.of(context).devicePixelRatio,
        right: 36 / MediaQuery.of(context).devicePixelRatio,
        top: 36 / MediaQuery.of(context).devicePixelRatio,
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.all(
            Radius.circular(36 / MediaQuery.of(context).devicePixelRatio)),
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
                        neuigkeitenCardDetail(_neuigkeit.titel, isCacheEnabled),
                  ),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 600 / MediaQuery.of(context).devicePixelRatio,
                color: Theme.of(context).cardColor,
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
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: PrefImage(bild, isCacheEnabled),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // ignore: missing_return
            Container(child: () {
              if (_neuigkeit.bilder.length != 1) {
                return Container(
                  padding: EdgeInsets.all(
                      24 / MediaQuery.of(context).devicePixelRatio),
                  child: CirclePageIndicator(
                    size: 15 / MediaQuery.of(context).devicePixelRatio,
                    selectedSize:
                        22.5 / MediaQuery.of(context).devicePixelRatio,
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
                  colors: [
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
                        neuigkeitenCardDetail(_neuigkeit.titel, isCacheEnabled),
                  ),
                ),
              ),
              child: Theme(
                data: theme,
                child: ExpansionTile(
                  title: Text(
                    _neuigkeit.titel.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(
                              6 / MediaQuery.of(context).devicePixelRatio,
                              6 / MediaQuery.of(context).devicePixelRatio),
                          blurRadius:
                              18 / MediaQuery.of(context).devicePixelRatio,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(
                              6 / MediaQuery.of(context).devicePixelRatio,
                              6 / MediaQuery.of(context).devicePixelRatio),
                          blurRadius:
                              18 / MediaQuery.of(context).devicePixelRatio,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  children: <Widget>[
                    //Inhalt, der gezeigt wird wenn expanded
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left:
                                  36 / MediaQuery.of(context).devicePixelRatio,
                              right:
                                  36 / MediaQuery.of(context).devicePixelRatio),
                          width: MediaQuery.of(context).size.width,
                          height: 420 / MediaQuery.of(context).devicePixelRatio,
                          child: SingleChildScrollView(
                            child: Text(
                              _neuigkeit.text_preview.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(
                                        6 /
                                            MediaQuery.of(context)
                                                .devicePixelRatio,
                                        6 /
                                            MediaQuery.of(context)
                                                .devicePixelRatio),
                                    blurRadius: 18 /
                                        MediaQuery.of(context).devicePixelRatio,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(
                                        6 /
                                            MediaQuery.of(context)
                                                .devicePixelRatio,
                                        6 /
                                            MediaQuery.of(context)
                                                .devicePixelRatio),
                                    blurRadius: 18 /
                                        MediaQuery.of(context).devicePixelRatio,
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
