import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class Neuigkeiten extends StatefulWidget {
  @override
  _NeuigkeitenState createState() => _NeuigkeitenState();
}

class _NeuigkeitenState extends State<Neuigkeiten> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: _buildNeuigkeitenList(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // DB komprimieren
    Hive.box('Neuigkeiten').compact();
    // Offline Database für Cached Artikel schließen
    Hive.box('Neuigkeiten').close();
    super.dispose();
  }
}

Widget _buildNeuigkeitenList(BuildContext context) {
  final neuigkeitenBox = Hive.box('Neuigkeiten');
  //TODO: Testdaten einpflegen
  List<String> bilder = new List();
  bilder.add("assets/testdata/kc.jpg");
  bilder.add("assets/testdata/kc_2.jpg");
  bilder.add("assets/testdata/kc_3.jpg");
  bilder.add("assets/testdata/kc_4.jpg");

  return WatchBoxBuilder(
    box: neuigkeitenBox,
    builder: (context, neuigkeitenBox) {
      ListView.builder(
        itemCount: neuigkeitenBox.length,
        itemBuilder: (context, index) {
          final neuigkeit = neuigkeitenBox.getAt(index) as Neuigkeit;
          return NeuigkeitenCard(neuigkeit, index);
        },
      );
    },
  );
}
