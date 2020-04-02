import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:hive/hive.dart';

void testdata_neuigkeiten(Box _box) {
  if (_box.length < 6) {
    print("Triggered Function getCachedNeuigkeiten");
    List<String> bilder = new List();
    bilder.add("assets/testdata/kc.jpg");
    bilder.add("assets/testdata/kc_2.jpg");
    bilder.add("assets/testdata/kc_3.jpg");
    bilder.add("assets/testdata/kc_4.jpg");
    _box.add(
      new Neuigkeit(
        titel: "Konficamp 2019- Schön wars!",
        text_preview: "Frieden gesucht!",
        text:
            "Unter diesem Motto machten sich über 350 Konfirmanden mit Ihren Mitarbeitern auf nach Rötenbach zum diesjährigen Konfirmandencamp. Dort erlebten sie eine tolle Auftaktshow mit vielen Spielelementen. Im Anschluß konnten die Jugendlichen dann über das ganze Gelände verteilt Aktionen wie Human-table-soccer, Sumoringer, Gladiator, Bistro, Fußball oder Kletterwand nutzen um mit viel Bewegung den Abend zu gestalten. Um 23.15 Uhr ging es dann wieder in Richtung Himmelszelt indem der Tag mit einem Gebet zu Nacht beendet wurde. Der Samstag fing mit ....... einem leckeren Frühstück an. So gestärkt jagten wir dem Frieden nach. In den Konfieinheiten wurde in Vielfältigsterweise über den Frieden auf der Welt, in Deutschland, bis hin bei mir selbst nachgedacht, gearbeitet oder kreativ umgesetzt. Auch im Alltag des Camps sollte deutlich werden, hier suchen wir aktiv nach Frieden, was sich im miteinander deutlich machte. Das Chaosspiel am Nachmittag sorgte für einen Riesenspaß und endete in einer gigantischen Wasserschlacht. Trotz zwischenzeitlichem Stromausfall konnte am Abend im Himmelszelt ein weiterer Programmpunkt und damit die Suche nach dem Frieden stattfinden. Das Konzert mit unserer Band Vollgas ergänzte das offen Angebot vom Freitag Abend nochmals zusätzlich.\n\n Als wir am Sonntag in das Himmelszelt eintraten traute mancher seinen Augen nicht. Mitten auf der Bühne stand ein Weihnachtsbaum und es lief das Lied Stille Nacht, Heilige Nacht. Und das bei Temperaturen über 30 ° Celisus. Nun, die Botschaft war klar, denn Jesus kommt an Weihnachten als Friedensbringer zu uns Menschen. Und deswegen können wir auch mitten im Jahr Weihnachten feiern.\n \nGegen 14 Uhr verlassen die Konfirmandengruppen gut gestärkt durch unser hervorragendes Küchenteam das Gelände und nehmen die Friedensbotschaft mit zurück in unserem Kirchenbezirk. Und wer weiß, vielleicht entdecken Sie ja mal einen unserer Friedensbringer Beutel",
        bilder: bilder,
      ),
    );
    bilder = new List();
    bilder.add("assets/testdata/ferienprogramm.jpg");
    _box.add(
      new Neuigkeit(
        titel: "Das neue Ferienprogramm ist da!",
        text_preview:
            "Seid einigen Wochen ist das Freizeitenprogramm für 2020 online und in den Gemeindehäusern verteilt. Jetzt sind sie dran. Stöbern Sie darin und suchen sich was interessantes heraus. Wir bieten für Kinder, Jugendliche und Junge Erwachse Freizeitprogramm an. Das meiste davon auf unseren eigenen Plätzen und am Anfang der Sommerferien. Viel Spaß beim lesen!",
        text:
            "Seid einigen Wochen ist das Freizeitenprogramm für 2020 online und in den Gemeindehäusern verteilt. Jetzt sind sie dran. Stöbern Sie darin und suchen sich was interessantes heraus. Wir bieten für Kinder, Jugendliche und Junge Erwachse Freizeitprogramm an. Das meiste davon auf unseren eigenen Plätzen und am Anfang der Sommerferien. Viel Spaß beim lesen!Das Programm ist vielseitig. Für Kinder, Jugendliche und junge Erwachse bieten für Ferienprogramme unterschiedlichster Art.",
        bilder: bilder,
        weiterfuehrender_link:
            "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Freizeiten/eje_Freizeiten_2020_Web.pdf",
      ),
    );
    bilder = new List();
    bilder.add("assets/testdata/corona.jpg");
    _box.add(
      new Neuigkeit(
        titel: "Corona Pandemie",
        text_preview:
        "Das Evangelische Jugendwerk Bezirk Esslingen ist bis auf weiteres geschlossen. Alle Veranstaltungen, Gruppen und Kreise, Planungstreffen oder Besprechungen sind abgesagt. Es finden keine Vermietungen oder Öffnungszeiten jedweder Form statt. Die Hauptamtlichen sind aber eingeschränkt digital erreichbar. Wir verweisen auf die Empfehlungen und Anordnungen des Kirchenbezirks.",
        text:
        "Das Evangelische Jugendwerk Bezirk Esslingen ist bis auf weiteres geschlossen. Alle Veranstaltungen, Gruppen und Kreise, Planungstreffen oder Besprechungen sind abgesagt. Es finden keine Vermietungen oder Öffnungszeiten jedweder Form statt. Die Hauptamtlichen sind aber eingeschränkt digital erreichbar. Wir verweisen auf die Empfehlungen und Anordnungen des Kirchenbezirks. \n\n Stand 18-03-2020 \n\nEuer Michael Weisbach",
        bilder: bilder,
      ),
    );
  }
}
