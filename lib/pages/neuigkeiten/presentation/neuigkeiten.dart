import 'package:eje/pages/neuigkeiten/data/NeuigkeitenDao.dart';
import 'package:eje/pages/neuigkeiten/data/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/neuigkeitenCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
}

Widget _buildNeuigkeitenList(BuildContext context) {
  NeuigkeitDao _neuigkeitdao = NeuigkeitDao();
  //TODO: Testdaten einpflegen
  List<String> bilder = new List();
  bilder.add("assets/testdata/kc.jpg");
  bilder.add("assets/testdata/kc_2.jpg");
  bilder.add("assets/testdata/kc_3.jpg");
  bilder.add("assets/testdata/kc_4.jpg");
  _neuigkeitdao.add(new Neuigkeit(
        titel: "Konficamp 2019- Schön wars!",
        vorschau: "Frieden gesucht!",
        inhalt: "Unter diesem Motto machten sich über 350 Konfirmanden mit Ihren Mitarbeitern auf nach Rötenbach zum diesjährigen Konfirmandencamp. Dort erlebten sie eine tolle Auftaktshow mit vielen Spielelementen. Im Anschluß konnten die Jugendlichen dann über das ganze Gelände verteilt Aktionen wie Human-table-soccer, Sumoringer, Gladiator, Bistro, Fußball oder Kletterwand nutzen um mit viel Bewegung den Abend zu gestalten. Um 23.15 Uhr ging es dann wieder in Richtung Himmelszelt indem der Tag mit einem Gebet zu Nacht beendet wurde. Der Samstag fing mit ....... einem leckeren Frühstück an. So gestärkt jagten wir dem Frieden nach. In den Konfieinheiten wurde in Vielfältigsterweise über den Frieden auf der Welt, in Deutschland, bis hin bei mir selbst nachgedacht, gearbeitet oder kreativ umgesetzt. Auch im Alltag des Camps sollte deutlich werden, hier suchen wir aktiv nach Frieden, was sich im miteinander deutlich machte. Das Chaosspiel am Nachmittag sorgte für einen Riesenspaß und endete in einer gigantischen Wasserschlacht. Trotz zwischenzeitlichem Stromausfall konnte am Abend im Himmelszelt ein weiterer Programmpunkt und damit die Suche nach dem Frieden stattfinden. Das Konzert mit unserer Band Vollgas ergänzte das offen Angebot vom Freitag Abend nochmals zusätzlich.\n" +
            "\n" +
            "Als wir am Sonntag in das Himmelszelt eintraten traute mancher seinen Augen nicht. Mitten auf der Bühne stand ein Weihnachtsbaum und es lief das Lied Stille Nacht, Heilige Nacht. Und das bei Temperaturen über 30 ° Celisus. Nun, die Botschaft war klar, denn Jesus kommt an Weihnachten als Friedensbringer zu uns Menschen. Und deswegen können wir auch mitten im Jahr Weihnachten feiern.\n" +
            "\n" +
            "Gegen 14 Uhr verlassen die Konfirmandengruppen gut gestärkt durch unser hervorragendes Küchenteam das Gelände und nehmen die Friedensbotschaft mit zurück in unserem Kirchenbezirk. Und wer weiß, vielleicht entdecken Sie ja mal einen unserer Friedensbringer Beutel",
        bilder: bilder));

  return FutureBuilder(
      future: _neuigkeitdao.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<Neuigkeit>> snapshot) {
        //if (!snapshot.hasData)
          //return new Container();
        List<Neuigkeit> _neuigkeiten = snapshot.data;
        return new ListView.builder(
          padding: EdgeInsets.only(left: 4, right: 4),
          itemCount: _neuigkeiten.length,
          itemBuilder: (context, index) {
            final item = _neuigkeiten[index];
            return NeuigkeitenCard(item, index);
          },
        );
      },
  );
}
