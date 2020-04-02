import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCardDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      borderRadius: new BorderRadius.all(Radius.circular(16)),
      child: new Stack(
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
                        _neuigkeit.text_preview.toString(),
                        textAlign: TextAlign.left,
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
    );
  }
}
