import 'package:eje/pages/eje/hauptamtlichen/hauptamtliche.dart';
import 'package:flutter/cupertino.dart';

import 'bak/bak.dart';

class eje extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 18),
        Hauptamtliche(context),
        SizedBox(height: 18),
        BAK(context),
      ],
    );
  }

}