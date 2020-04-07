import 'package:eje/pages/eje/hauptamtlichen/hauptamtliche.dart';
import 'package:flutter/cupertino.dart';

import 'arbeitsfelder/arbeitsbereiche.dart';
import 'bak/bak.dart';

class eje extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: <Widget>[
        SizedBox(height: 20),
        Hauptamtliche(context),
        SizedBox(height: 20),
        BAK(context),
        SizedBox(height: 20),
        Arbeitsbereiche(context),
        SizedBox(height: 20),
      ],
    );
  }

}