import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:hive/hive.dart';

void testdata_arbeitsbereiche(Box _box) {
  if (_box.length < 6) {
    List<String> bilder = new List();
    bilder.add("assets/testdata/jungscharlogo.gif");
    bilder.add("assets/testdata/battle.jpg");
    _box.add(
      new Arbeitsbereich(
        arbeitsfeld: "Jungschararbeit",
        bilder: bilder,
        url: "https://www.eje-esslingen.de/arbeitsfelder/kinder-von-6-bis-12/",
        inhalt:
            "Es ist ein Privileg mit Kindern arbeiten zu dürfen. Insbesondere in unseren festen Jungschargruppen. Jungschar bedeute dabei, dass wir den Kindern ein vielseitiges Angebot und Experiementierfeld für Sie anbieten. Jeder kann sich dabei vielfältig ausprobieren. Die Begleitung erfolgt durch gut geschulte Ehren- und Hauptamtliche Mitarbeiter.Sicherlich ist das Jungschar-Camp in Asch und die legendäre Orangenaktion jeweils ein besonderes Highlight im Jahreskalender einer jeder Jungschar. Weiterführende Schulungsangebote runden das Programm ab.Verantwortlicher Ansprechpartner: Frédéric Postic",
      ),
    );
    bilder = new List();
    bilder.add("assets/testdata/13.jpg");
    bilder.add("assets/testdata/15.jpg");
    _box.add(
      new Arbeitsbereich(
        arbeitsfeld: "13-15 Jährige",
        bilder: bilder,
        url:
            "https://www.eje-esslingen.de/arbeitsfelder/jugendliche-von-13-bis-17/",
        inhalt:
            "Du bist voller Power und hast Lust auf Action? Dann haben wir genau die richtigen Sachen für Dich!Klick Dich durch und bei Fragen einfach bei Frederic Postic nachfragen!",
      ),
    );
    bilder = new List();
    bilder.add("assets/testdata/dcn.png");
    _box.add(
      new Arbeitsbereich(
          arbeitsfeld: "16+",
          bilder: bilder,
          url:
              "https://www.eje-esslingen.de/arbeitsfelder/junge-erwachsene-ab-18-jahre/",
          inhalt:
              "Alle Infos zu den Aktionen für Junge Erwachsene gibt es ab dem 1. April bei Nicole Schnaars."),
    );
    bilder = new List();
    bilder.add("assets/testdata/oa.jpg");
    _box.add(
      new Arbeitsbereich(
          arbeitsfeld: "Offene Arbeit",
          bilder: bilder,
          url: "https://www.eje-esslingen.de/arbeitsfelder/jugendtreffs/",
          inhalt:
              "Hier stellen sich die beiden Jugendhausähnlichen Einrichtungen des eje - t1 und FunTasia - vor. Beide Jugendhausähnliche Einrichtungen arbeiten nach den städtischen Qualitätsstandards. Unsere Berichte mailen wir auf Anfrage gerne zu."),
    );
    bilder = new List();
    bilder.add("assets/testdata/bildung.jpg");
    _box.add(
      new Arbeitsbereich(
        arbeitsfeld: "Bildungsangebote",
        bilder: bilder,
        url:
            "https://www.eje-esslingen.de/arbeitsfelder/schulungs-und-bildungsangebote/",
        inhalt:
            "Wir freuen uns, dass Du Dich für eine Mitarbeiterschulung interessierst. Unser Schulungskonzept ist so aufgebaut, dass für viele verschiedenen Interessen und Mitarbeitende etwas dabei ist. Die meisten Schulungsangebote bauen aufeinander auf und ergänzen sich.Die Starterkurse in den Schulen (Schülermentorenkurs oder Jugendbegleiterausbildung) oder vor Ort (Traineekurse) bilden den Start in die Mitarbeiterschaft. Das eje-Team unterstützt gerne die Teams vor Ort, begleitet sie oder ist selbst in der Trägerschaft.Auf dem Grundkurs schulen wir die „Basics“, welche man für eine Mitarbeit in der Jugendarbeit braucht. Deshalb empfehlen wir allen Trainees, Schülermentoren und Jugendbegleitern diesen Standardkurs zur Erlangung der Juleica. Die Anmeldeformulare hierzu gibt es ab Ende Juli.Beim Aufbaukurs geht es um den Erhalt des Knowhows für eine Gruppenleitung oder Freizeitmitarbeit. Darüberhinaus empfehlen wir die Teilnahme an unseren Freizeiten, als einen wichtigen Baustein zur Mitarbeiterschaft. Anmelden kann man sich hierzu ab Ende Juli.Darüber hinaus gibt es noch viele weitere Schulungsangebote. Diese Schulungen werden von einem erfahrenen Team von Haupt- und Ehrenamtlichen geleitet und durchgeführt.Verantwortlich für den Bildungs- und Schulungsbereich im eje ist Nicole Schnaars.",
      ),
    );
  }
}
