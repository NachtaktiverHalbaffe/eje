import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/termine.dart';
import 'package:hive/hive.dart';

void testdata_termine(Box _box) {
  if (_box.length <12) {
    _box.add(
      new Termin(
        veranstaltung:"AHOJ",
        motto: "Der Jugendgottesdienst in Esslingen",
        bild: "assets/testdata/ahoj_logo.png",
        datum: "21.06.2020, 18:00 Uhr - 19:00 Uhr",
        ort: Ort("Johanneskirche Esslingen", "Neckarstraße 81", "73728 Esslingen"),
      ),
    );

    _box.add(
      new Termin(
        veranstaltung:"Eje-Wochenende",
        motto: "Wir im eje - eine starke Gemeinschaft!",
        bild: "assets/testdata/13.jpg",
        datum: "01.05.2020, 16:00 Uhr - 03.05.2020, 16:00 Uhr",
        text: "Hier packen wir alles in das Wochenende rein, was uns ausmacht.\nKomm mit und erlebe eine tolle Gemeinschaft, in der wir über unseren Glauben nachdenken. Miteinander feiern. Abendmahl halten und mit Spiel und Spaß uns ordentlich die Zeit vertreiben. Und wir erleben natürlich unser Freizeitheim in besonderer Atmosphäre, wenn wir es bis auf den letzten Platz füllen und zum Leben bringen.\n Am eje-Wochenende vereint sich Jung und Alt, mit Erfahrung oder ohne. Alle, die im Kirchenbezirk als Mitarbeiter aktiv sind oder waren sind herzlich eingeladen. Es ist auch Platz, um neues auszuprobieren, wie z.B. BamBall (Muskelkater inklusive). In diesem Jahr wird der Samstag Schwerpunkte haben, wo ihr euch entsprechend einwählen könnt.\n\n In diesem Jahr ist das eje-Wochenende in der XXL-Variante möglich. Sprich, durch den Feiertag gibt es eine Übernachtung mehr. Wer will kann aber auch erst mit dem Freundesfest nach Asch kommen.\n\n Also – schnell anmelden und mit uns zusammen ein tolles Wochenende erleben!",
        ort: Ort("Freizeitheim Asch", "Dorfstrasse 100", "89143 Blaubeuren Asch"),
      ),
    );

    _box.add(
      new Termin(
        veranstaltung:"AHOJ",
        motto: "Der Jugendgottesdienst in Esslingen",
        bild: "assets/testdata/ahoj_logo.png",
        datum: "21.06.2020, 18:00 Uhr - 19:00 Uhr",
        ort: Ort("Johanneskirche Esslingen", "Neckarstraße 81", "73728 Esslingen"),
      ),
    );

    _box.add(
      new Termin(
        veranstaltung:"Eje-Wochenende",
        motto: "Wir im eje - eine starke Gemeinschaft!",
        bild: "assets/testdata/13.jpg",
        datum: "01.05.2020, 16:00 Uhr - 03.05.2020, 16:00 Uhr",
        text: "Hier packen wir alles in das Wochenende rein, was uns ausmacht.\nKomm mit und erlebe eine tolle Gemeinschaft, in der wir über unseren Glauben nachdenken. Miteinander feiern. Abendmahl halten und mit Spiel und Spaß uns ordentlich die Zeit vertreiben. Und wir erleben natürlich unser Freizeitheim in besonderer Atmosphäre, wenn wir es bis auf den letzten Platz füllen und zum Leben bringen.\n Am eje-Wochenende vereint sich Jung und Alt, mit Erfahrung oder ohne. Alle, die im Kirchenbezirk als Mitarbeiter aktiv sind oder waren sind herzlich eingeladen. Es ist auch Platz, um neues auszuprobieren, wie z.B. BamBall (Muskelkater inklusive). In diesem Jahr wird der Samstag Schwerpunkte haben, wo ihr euch entsprechend einwählen könnt.\n\n In diesem Jahr ist das eje-Wochenende in der XXL-Variante möglich. Sprich, durch den Feiertag gibt es eine Übernachtung mehr. Wer will kann aber auch erst mit dem Freundesfest nach Asch kommen.\n\n Also – schnell anmelden und mit uns zusammen ein tolles Wochenende erleben!",
        ort: Ort("Freizeitheim Asch", "Dorfstrasse 100", "89143 Blaubeuren Asch"),
      ),
    );

    _box.add(
      new Termin(
        veranstaltung:"AHOJ",
        motto: "Der Jugendgottesdienst in Esslingen",
        bild: "assets/testdata/ahoj_logo.png",
        datum: "21.06.2020, 18:00 Uhr - 19:00 Uhr",
        ort: Ort("Johanneskirche Esslingen", "Neckarstraße 81", "73728 Esslingen"),
      ),
    );

    _box.add(
      new Termin(
        veranstaltung:"Eje-Wochenende",
        motto: "Wir im eje - eine starke Gemeinschaft!",
        bild: "assets/testdata/13.jpg",
        datum: "01.05.2020, 16:00 Uhr - 03.05.2020, 16:00 Uhr",
        text: "Hier packen wir alles in das Wochenende rein, was uns ausmacht.\nKomm mit und erlebe eine tolle Gemeinschaft, in der wir über unseren Glauben nachdenken. Miteinander feiern. Abendmahl halten und mit Spiel und Spaß uns ordentlich die Zeit vertreiben. Und wir erleben natürlich unser Freizeitheim in besonderer Atmosphäre, wenn wir es bis auf den letzten Platz füllen und zum Leben bringen.\n Am eje-Wochenende vereint sich Jung und Alt, mit Erfahrung oder ohne. Alle, die im Kirchenbezirk als Mitarbeiter aktiv sind oder waren sind herzlich eingeladen. Es ist auch Platz, um neues auszuprobieren, wie z.B. BamBall (Muskelkater inklusive). In diesem Jahr wird der Samstag Schwerpunkte haben, wo ihr euch entsprechend einwählen könnt.\n\n In diesem Jahr ist das eje-Wochenende in der XXL-Variante möglich. Sprich, durch den Feiertag gibt es eine Übernachtung mehr. Wer will kann aber auch erst mit dem Freundesfest nach Asch kommen.\n\n Also – schnell anmelden und mit uns zusammen ein tolles Wochenende erleben!",
        ort: Ort("Freizeitheim Asch", "Dorfstrasse 100", "89143 Blaubeuren Asch"),
      ),
    );

    _box.add(
      new Termin(
        veranstaltung:"AHOJ",
        motto: "Der Jugendgottesdienst in Esslingen",
        bild: "assets/testdata/ahoj_logo.png",
        datum: "21.06.2020, 18:00 Uhr - 19:00 Uhr",
        ort: Ort("Johanneskirche Esslingen", "Neckarstraße 81", "73728 Esslingen"),
      ),
    );

    _box.add(
      new Termin(
        veranstaltung:"Eje-Wochenende",
        motto: "Wir im eje - eine starke Gemeinschaft!",
        bild: "assets/testdata/13.jpg",
        datum: "01.05.2020, 16:00 Uhr - 03.05.2020, 16:00 Uhr",
        text: "Hier packen wir alles in das Wochenende rein, was uns ausmacht.\nKomm mit und erlebe eine tolle Gemeinschaft, in der wir über unseren Glauben nachdenken. Miteinander feiern. Abendmahl halten und mit Spiel und Spaß uns ordentlich die Zeit vertreiben. Und wir erleben natürlich unser Freizeitheim in besonderer Atmosphäre, wenn wir es bis auf den letzten Platz füllen und zum Leben bringen.\n Am eje-Wochenende vereint sich Jung und Alt, mit Erfahrung oder ohne. Alle, die im Kirchenbezirk als Mitarbeiter aktiv sind oder waren sind herzlich eingeladen. Es ist auch Platz, um neues auszuprobieren, wie z.B. BamBall (Muskelkater inklusive). In diesem Jahr wird der Samstag Schwerpunkte haben, wo ihr euch entsprechend einwählen könnt.\n\n In diesem Jahr ist das eje-Wochenende in der XXL-Variante möglich. Sprich, durch den Feiertag gibt es eine Übernachtung mehr. Wer will kann aber auch erst mit dem Freundesfest nach Asch kommen.\n\n Also – schnell anmelden und mit uns zusammen ein tolles Wochenende erleben!",
        ort: Ort("Freizeitheim Asch", "Dorfstrasse 100", "89143 Blaubeuren Asch"),
      ),
    );
  }
}
