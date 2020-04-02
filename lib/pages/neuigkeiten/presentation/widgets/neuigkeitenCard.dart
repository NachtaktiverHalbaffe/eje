import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCardDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NeuigkeitenCard extends StatelessWidget {
  final Neuigkeit _neuigkeit;
  final int index;
  String TAG_BILD;
  String TAG_TITEL;

  NeuigkeitenCard(this._neuigkeit, this.index);

  @override
  Widget build(BuildContext context) {
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
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
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
                              image: ExactAssetImage(bild),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
            ExpansionTile(
              title: new Hero(
                tag: TAG_TITEL,
                child: Text(
                  _neuigkeit.titel.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                      child: Text(
                        _neuigkeit.text_preview.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
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
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Details"),
                          color: Theme.of(context).accentColor,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<NeuigkeitenBlocBloc>(
                                    context),
                                child: neuigkeitenCardDetail(
                                    _neuigkeit, TAG_BILD, TAG_TITEL),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
