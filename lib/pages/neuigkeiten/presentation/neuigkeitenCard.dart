import 'package:eje/pages/neuigkeiten/data/neuigkeit.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    return ClipRRect(
        borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8)),
        child: new Card(
          elevation: 4,
          // margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(
                tag: TAG_BILD,
                child: Container(
                  //TODO: Viewpager
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: ExactAssetImage(_neuigkeit.bilder[0]),
                  )),
                ),
              ),
              ExpansionTile(
                title: new Hero(
                  tag: TAG_TITEL,
                  child: Text(
                    _neuigkeit.titel.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                          _neuigkeit.vorschau.toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text("Details"),
                              color: Theme.of(context).accentColor,
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          neuigkeitenCardDetail(_neuigkeit,
                                              TAG_BILD, TAG_TITEL))),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

class neuigkeitenCardDetail extends StatelessWidget {
  Neuigkeit _neuigkeit;
  final String TAG_TITEL;
  final String TAG_BILD;

  neuigkeitenCardDetail(this._neuigkeit, this.TAG_BILD, this.TAG_TITEL);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Neuigkeiten"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[

          Column(
            children: <Widget>[
              Hero(
                tag: TAG_BILD,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  //TODO: Viewpager
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: ExactAssetImage(_neuigkeit.bilder[0].toString()),
                  )),
                ),
              ),
              Hero(
                tag: TAG_TITEL,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10, right: 10, top: 16),
                  child: Text(
                    _neuigkeit.titel,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 16),
                child: Text(
                  _neuigkeit.inhalt,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
