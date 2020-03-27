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
  neuigkeitenBox.add(
    new Neuigkeit(
      titel: "Konficamp 2019- Schön wars!",
      text_preview: "Frieden gesucht!",
      text: "Unter diesem Motto machten sich über 350 Konfirmanden mit Ihren Mitarbeitern auf nach Rötenbach zum diesjährigen Konfirmandencamp. Dort erlebten sie eine tolle Auftaktshow mit vielen Spielelementen. Im Anschluß konnten die Jugendlichen dann über das ganze Gelände verteilt Aktionen wie Human-table-soccer, Sumoringer, Gladiator, Bistro, Fußball oder Kletterwand nutzen um mit viel Bewegung den Abend zu gestalten. Um 23.15 Uhr ging es dann wieder in Richtung Himmelszelt indem der Tag mit einem Gebet zu Nacht beendet wurde. Der Samstag fing mit ....... einem leckeren Frühstück an. So gestärkt jagten wir dem Frieden nach. In den Konfieinheiten wurde in Vielfältigsterweise über den Frieden auf der Welt, in Deutschland, bis hin bei mir selbst nachgedacht, gearbeitet oder kreativ umgesetzt. Auch im Alltag des Camps sollte deutlich werden, hier suchen wir aktiv nach Frieden, was sich im miteinander deutlich machte. Das Chaosspiel am Nachmittag sorgte für einen Riesenspaß und endete in einer gigantischen Wasserschlacht. Trotz zwischenzeitlichem Stromausfall konnte am Abend im Himmelszelt ein weiterer Programmpunkt und damit die Suche nach dem Frieden stattfinden. Das Konzert mit unserer Band Vollgas ergänzte das offen Angebot vom Freitag Abend nochmals zusätzlich.\n\n Als wir am Sonntag in das Himmelszelt eintraten traute mancher seinen Augen nicht. Mitten auf der Bühne stand ein Weihnachtsbaum und es lief das Lied Stille Nacht, Heilige Nacht. Und das bei Temperaturen über 30 ° Celisus. Nun, die Botschaft war klar, denn Jesus kommt an Weihnachten als Friedensbringer zu uns Menschen. Und deswegen können wir auch mitten im Jahr Weihnachten feiern.\n \nGegen 14 Uhr verlassen die Konfirmandengruppen gut gestärkt durch unser hervorragendes Küchenteam das Gelände und nehmen die Friedensbotschaft mit zurück in unserem Kirchenbezirk. Und wer weiß, vielleicht entdecken Sie ja mal einen unserer Friedensbringer Beutel",
      bilder: bilder,
    ),
  );
  return ValueListenableBuilder(
    valueListenable: neuigkeitenBox.listenable(),
    builder: (context, neuigkeitenBox, widget) {
      return ListView.builder(
        itemCount: neuigkeitenBox.length,
        itemBuilder: (context, index) {
          final neuigkeit = neuigkeitenBox.getAt(index) as Neuigkeit;
          return NeuigkeitenCard(neuigkeit, index);
        },
      );
    },
  );
}
