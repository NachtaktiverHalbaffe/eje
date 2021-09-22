import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:hive/hive.dart';

void testdataFreizeiten(Box _box) {
  if (_box.length < 6) {
    _box.add(
      new Camp(
        name: "Teenie-Camp Hopfensee",
        description:
            "Die Unterkunft\nGruppenzelte mit Holzboden, Vordach und Feldbetten.Keine Minute von deinem Zelt weg, liegt der Hopfensee. Ideal fürs Baden, Kajak fahren oder sonstige Action im Wasser.Atemberaubend ist der Blick von deinem Zelt auf die Allgäuer Alpen mit dem 2000er Säuling und dem Schloss Neuschwanstein.\n\nDas ProgrammBei uns findest du das ultimativ Coole: Baden, Kajak fahren, Fußball, Jugger oder Flagfootball spielen oder die Gipfel der Berge erklimmen. Manche wollen vielleicht doch lieber nach Füssen shoppen gehen oder einfach in der Sonne liegen, chillen und relaxen …Es erwartet dich ein abwechslungsreiches Programm, mit witzigen und herausfordernden Spieleabenden, Lagerfeuer-Romantik und jede Menge tolle Menschen. Gemeinsam wollen wir mit dir Antworten auf wichtige Fragen in unserem Leben suchen und überlegen, ob Gott damit was zu tun hat.\n\nDas TeamTäglich versorgt uns das Küchenteam mit richtig gutem Essen. Das Programmteam gestaltet nicht nur Spiele und Action, sondern nimmt sich Zeit für dich und deine Fragen.Bist du bereit für den perfekten Start in deine Sommerferien?",
        companion: ["Georg Häusler", "Katharina Greiner"],
        price: "260 Euro",
        age: "13-17 Jahre",
        datum: "30.07 - 07.08.2020",
        location:
            Ort("Zeltplatz am Hopfensee", "Dornach 108", "87659 Hopferau"),
        registrationDeadline: "14. Juli 2020",
        catering: "Vollverpflegung",
        lodging: "Zelte mit Boden und Feldbett",
        journey: "Hin- und Rückfahrt mit Reisebus",
        otherServices: "Betreuung und Programm",
        pictures: [
          "assets/testdata/teeniecamp1.jpg",
          "assets/testdata/teeniecamp2.jpg",
          "assets/testdata/teeniecamp3.jpg"
        ],
        freePlaces: "wenige Plätze frei",
        link: "https://anmeldung2.ejw-manager.de/veranstaltung/25324",
        subtitle: "Your adventure starts here!#SommerdeinesLebens",
      ),
    );
    _box.add(
      new Camp(
        name: "Kinderfreizeit Asch",
        description:
            "Schule aus und du hast keinen Plan was du machen sollst? Dann wohnst du vermutlich noch nicht so lange hier, denn sonst wüsstest du, dass Asch eine geniale und legendäre Freizeit für dich ist!\n\n Unser eigenes Haus bietet uns alles, was wir für ein tolles Programm brauchen. In der eigenen Turnhalle steht dem Sport nichts im Weg. Auch draußen auf der Wiese können wir uns voll austoben. Zu Spiel und Spaß gehört bei uns auch dazu, dass wir auf Gottes Wort hören wollen.Egal ob auf hoher See oder im alten Ägypten, in der Bibel gibt es viele spannende Geschichten, die wir jeden Tag gemeinsam entdecken wollen.\n\nWir wollen Singen, Basteln, Toben, Spielen, vielleicht auch ums Lagerfeuer sitzen oder eine Wasserschlacht machen, aber vor allem gemeinsam eine tolle Zeit verbringen.Untergebracht sind wir in Zwei– bis Vier-Bett-Zimmern. Und unser eigenes Küchenteam verzaubert uns immer wieder mit leckeren Gerichten.\n\nEin bewährtes Mitarbeiterteam wird sich wieder die ganzen neun Tage lang um dich kümmern. Das wird ein Urlaub mit einem „Rundumsorglosprogramm“.\n\nWir freuen uns auf dich!\n\nFreizeitpreis-Ermäßigung:\nFür das zweite, dritte usw. Kind einer Familie, das auf einer der folgenden Freizeiten: Kinder-Asch, Kids-Camp Hopfensee und Teenie-Camp Hopfensee angemeldet wird erhalten Familien einen Nachlass von je 50€.",
        companion: ["Georg Häusler", "Katharina Greiner"],
        price: "295 Euro",
        age: "8 - 12 Jahre",
        datum: "30.07 - 07.08.2020",
        location:
            Ort("Freizeitheim Asch", "Dorfstraße 100", "12345 Blaubeuren"),
        registrationDeadline: "14. Juli 2020",
        catering: "Vollverpflegung",
        lodging: "Zelte mit Boden und Feldbett",
        journey: "Hin- und Rückfahrt mit Reisebus",
        otherServices: "Betreuung und Programm",
        pictures: [
          "assets/testdata/kidscamp1.jpg",
          "assets/testdata/kidscamp2.jpg",
          "assets/testdata/kidscamp3.jpg"
        ],
        freePlaces: "wenige Plätze frei",
        link: "https://anmeldung2.ejw-manager.de/veranstaltung/25324",
        subtitle: "So starten die Somemrferien für dich!",
      ),
    );
  }
}
