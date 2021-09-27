import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:hive/hive.dart';

void testdataTermine(Box _box) {
  if (_box.length < 2) {
    _box.add(
      new Event(
        id: 1,
        name: "AHOJ",
        motto: "Der Jugendgottesdienst in Esslingen",
        images: ["assets/testdata/ahoj_logo.png"],
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        location: Ort(
            "Johanneskirche Esslingen", "Neckarstraße 81", "73728 Esslingen"),
      ),
    );

    _box.add(
      new Event(
        id: 2,
        name: "Eje-Wochenende",
        motto: "Wir im eje - eine starke Gemeinschaft!",
        images: ["assets/testdata/13.jpg"],
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        description:
            "Hier packen wir alles in das Wochenende rein, was uns ausmacht.\nKomm mit und erlebe eine tolle Gemeinschaft, in der wir über unseren Glauben nachdenken. Miteinander feiern. Abendmahl halten und mit Spiel und Spaß uns ordentlich die Zeit vertreiben. Und wir erleben natürlich unser Freizeitheim in besonderer Atmosphäre, wenn wir es bis auf den letzten Platz füllen und zum Leben bringen.\n Am eje-Wochenende vereint sich Jung und Alt, mit Erfahrung oder ohne. Alle, die im Kirchenbezirk als Mitarbeiter aktiv sind oder waren sind herzlich eingeladen. Es ist auch Platz, um neues auszuprobieren, wie z.B. BamBall (Muskelkater inklusive). In diesem Jahr wird der Samstag Schwerpunkte haben, wo ihr euch entsprechend einwählen könnt.\n\n In diesem Jahr ist das eje-Wochenende in der XXL-Variante möglich. Sprich, durch den Feiertag gibt es eine Übernachtung mehr. Wer will kann aber auch erst mit dem Freundesfest nach Asch kommen.\n\n Also – schnell anmelden und mit uns zusammen ein tolles Wochenende erleben!",
        location: Ort(
            "Freizeitheim Asch", "Dorfstrasse 100", "89143 Blaubeuren Asch"),
      ),
    );
  }
}
