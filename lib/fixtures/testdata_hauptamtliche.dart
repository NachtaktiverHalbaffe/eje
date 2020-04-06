import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:hive/hive.dart';

void testdata_hauptamtliche(Box _box) {
  if (_box.length < 6) {
    _box.add(
      new Hauptamtlicher(
        bild: "assets/testdata/freddy.jpg",
        name: "Frederic Postic",
        bereich: "Bezirksjugendreferent",
        vorstellung: "Seit April 2016 arbeite ich nun als Jugendreferent in Esslingen. Meine Leidenschaft für die Jugendarbeit hat schon als Ehrenamtlicher im CVJM Esslingen mit 16 Jahren begonnen. Dort war ich bei den Pfadfindern aktiv. Meine Ausbildung habe ich an der Evangelischen Hochschule Karlshöhe absolviert. Ich freue mich immer wieder an den Jugendlichen die ich begleiten und schulen darf. Es ist immer wieder ein kleines Stück Himmel, wenn man mit Jugendlichen evangelische Jugendarbeit durchführen darf.Darüber hinaus bin ich Ansprechpartner für folgende Themen: Jungscharbeirat, Konficamp, Jugendgottesdienste, Traineeprojekte, Mitarbeitergewinnung, Vernetzungen im Altersbereich 13-17 Jahre.",
        email: "Frederic.Postic@eje-esslingen.de",
        telefon: "0711 / 39 69 41 - 14",
        handy: "01525-7860531",
        threema: "SFHJEWTT",),
    );
    _box.add(
    new Hauptamtlicher(
      bild: "assets/testdata/micha.jpg",
      name: "Michael Weisbach",
      bereich: "Leitender Referent",
      vorstellung:"Jugendreferent zu sein, bedeutet für mich berufen zu sein. Gott stellt mich in die Aufgabe für Kinder und Jugendliche da zu sein und es Ihm dadurch zu ermöglichen in Kontakt zu treten. Die Leidenschaft für mein Jugendreferenten sein hat schon als Ehrenamtlicher im Jugendwerk Rohr / Dürrlewang (Stuttgart) mit 16 Jahren begonnen. Doch zuerst absolvierte ich eine Ausbildung zum Groß und Außenhandelskaufmann bevor ich dann nach Kassel an die damalige CVJM Sekretärsschule, dem heutigen CVJM Kolleg ging, um dort meine Ausbildung zum Jugendreferenten zu machen. Während meiner Dienstzeit habe ich mich weitergebildet zum Spiritual und einer insoweit erfahrene Fachkraft (Schutzauftrag für Kinder). Seit Jahren arbeite ich auf Landesebene im Fachausschuss Konfirmanden und Jugendliche (PTZ-EJW) und dem Jugendreferentenausschuss (EJW) mit. Jetzt leite ich das eje und freue ich mich an den Herausforderungen. Über die Kinder und Jugendlichen, bis hin zu den Hauptamtlichen Kolleginnen und Kollegen möchte ich die Faszination von Berufung, Verkündigung und gelebter Jugendarbeit ermöglichen und deutlich machen.Mich kann man mit folgenden Themen ansprechen: Personal, Öffentlichkeitsarbeit, Jungbläserschulung, Fragen zum Jugendwerk, Ortsverantwortliche, BAK, Vorstand oder Delegiertenversammlung." ,
      email: "Michael.Weisbach@eje-esslingen.de",
      telefon: "0711 / 39 69 41 - 0",
      handy: "0172 / 45 75 45 1",
      threema: "H23JU77M",),
  );
    _box.add(
      new Hauptamtlicher(
        bild: "assets/testdata/nicole.jpg",
        name: "Nicole Schnaars",
        bereich: "Bezirksjugendreferent",
        vorstellung:"Hallo zusammen! Ich darf mich euch kurz vorstellen. Meine Name ist Nicole Schnaars, ich bin stolze 40 Jahre alt, ein echtes Schwarzwaldmadel, beziehungsorientiert, kreativ, Genießermensch und bekennende Nachteule. Junge Menschen zu begleiten, mit ihnen Glaube und Leben zu teilen ist mir eine besondere Freude. Dabei ist es mir stets ein Anliegen, dass wir uns gemeinsam unseres Auftrages bewusst sind, und Jesus Christus unser Mittelpunkt bildet.Seit dem 1. April 2020 bin ich für die Bereiche Freizeitarbeit, Mitarbeiterbildung und die FSJler zuständig. Zudem werde ich theologische Angebote für Junge Erwachsene anbieten.Nun freue ich mich auf alle Begegnungen mit euch. Wer mehr wissen möchte ist jederzeit auf einen Kaffee im Büro willkommen",
        email: "Nicole.Schnaars@eje-esslingen.de",
        telefon: "0711 / 39 69 41 - 20",
        handy: " 0174 / 1698234",
        threema: "MH4VJF2D",),
    );
    _box.add(
      new Hauptamtlicher(
        bild: "assets/testdata/kaddy.jpg",
        name: "Kathrin Mildenberger",
        bereich: "Bezirksjugendreferent",
        vorstellung:"Seit April 2019 bin ich im Evangelischen Jugendwerk Bezirk Esslingen, der Kirchengemeinde Deizisau und dem CVJM Plochingen unterwegs. Unterwegs mit euch, den ehrenamtlichen Mitarbeitenden, Verantwortlichen, Pfarrerinnen und Pfarrer und natürlich mit vielen ganz unterschiedlichen Teilnehmenden von Jung bis Alt. Es macht mir großen Spaß mit euch Neues zu entwickeln, Altes neu zu beleben, Ideen zu spinnen, Ansprechperson zu sein und Neues umzusetzen.Zu meinen Bereichen gehört die Schulung und Begleitung von ehrenamtlichen Mitarbeitenden, der Ahoj to go in Plochingen, das Sportcamp vom CVJM Plochingen, Konfirmandenarbeit, Jungschararbeit, Vernetzung und noch ein paar Dinge mehr.",
        email: "Kathrin.Mildenberger@eje-esslingen.de",
        telefon: "0711/396941-0",
        handy: " 0162/6129973",
        threema: "PARRSF3P",),
    );
    _box.add(
      new Hauptamtlicher(
        bild: "assets/testdata/lars.jpg",
        name: "Lars Gildner",
        bereich: "Bezirksjugendreferent",
        vorstellung:"Seit Juni 2008 arbeite ich als Jugendreferent im eje. Ich hatte schon unterschiedlichste Dienstaufträge von Freizeiten über Schulungen bis zur Jungschararbeit. Ich bin seit meinem Sozialwesen-Studium im hauptamtlichen Dienst für die Jugend tätig. Ich habe zwar die Vocatio zum Religionslehrer, diese ruht jedoch, da mir die freiwillige, informelle Bildung näher liegt. Ich möchte alle (jungen) Menschen ernst nehmen und ihnen in respektvoller, christlicher Haltung begegnen. In meinem Supervisions-Studium habe ich mir Beratungskompetenzen erworben, die der Jugendarbeit stark zugutekommen. Seit September 2017 arbeite ich ausschließlich im Jugendtreff FunTasia. In dieser Funktion ist mir der Blick auf die Kinder und Jugendlichen im ganzen Stadtteil als Gemeinwesen und Kooperationen mit wesentlichen Einrichtungen und Vereinen besonders wichtig.Für folgende Themenbereiche kann man mich ansprechen. Prävention Kindeswohlgefährdung, Kinderbibeltage, alles im Bereich Offene Jugendarbeit",
        email: "Lars.Gildener@eje-esslingen.de",
        telefon: "0711 / 39 69 41 - 17",
        handy: " 0172-6339921",
        threema: "FWN4VTU4",),
    );
    _box.add(
      new Hauptamtlicher(
        bild: "assets/testdata/joerg.jpg",
        name: "Jörg Maurer-Pfeiffer",
        bereich: "Bezirksjugendreferent",
        vorstellung:"Seit 1985 arbeite ich als Jugendreferent in Esslingen. Die ersten 10 Jahre beim CVJM, seither im eje.  Mein Haupteinsatzgebiet war immer die Offene Arbeit. Als ausgebildeter Elektroniker und studierter Diakon und Diplom-Sozialarbeiter passt das ganz gut :)Ich habe lange Zeit mit meiner Frau die Familienarbeit mit den eigenen Kindern geteilt. Jetzt  bin ich wieder voll bezahlt und gemeinsam mit den Kolleginnen Ulrike Kuhn (momentan in Elternzeit) und Rebecca Viereg für den Jugendtreff t1 auf dem Zollberg zuständig.Zu den weiteren Verantwortungsgebieten gehört der Fuhrpark des Jugendwerks.Für den Kirchenbezirk bin ich in der  Mitarbeitenden-Vertretung aktiv.",
        email: "Joerg-Maurer-Pfeiffer@eje-esslingen.de",
        telefon: "0711/396941-15",
        handy: " 0162/6129973",
        threema: "C6CYKZ35",),
    );
  }
}
