import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TerminCard extends StatelessWidget {
  final Termin termin;
  final bool isCacheEnabled;

  TerminCard(this.termin, this.isCacheEnabled);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 6,
        right: 6,
      ),
      child: Card(
        child: ListTile(
          onTap: null,
          isThreeLine: true,
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: ExactAssetImage(termin.bild),
          ),
          title: Text(
            termin.veranstaltung,
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Column(
            children: <Widget>[
              SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Icon(Icons.today, size: 16),
                  SizedBox(width: 4),
                  Flexible(
                      child:
                          Text(termin.datum, overflow: TextOverflow.ellipsis))
                ],
              ),
              SizedBox(height: 2),
              Row(
                children: <Widget>[
                  Icon(MdiIcons.mapMarker, size: 16),
                  SizedBox(width: 4),
                  Flexible(
                      child: Text(termin.ort.Anschrift,
                          overflow: TextOverflow.ellipsis)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
