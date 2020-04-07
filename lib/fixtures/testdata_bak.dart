import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:hive/hive.dart';

void testdata_bak(Box _box){
  if (_box.length < 6) {
    _box.add(
      new BAKler(
        bild: "assets/testdata/christina.jpg",
        name: "Christina Kurz",
        amt: "Vorsitzende",
        vorstellung:"Jugendarbeit prägt meinen Alltag schon seit vielen Jahren. Durch Teilnahme und Mitarbeit in Jungschar, Jugendgruppe, Mitarbeiterschulungen, Freizeiten und Ferienprogrammen hat diese Leidenschaft immer einen großen Teil meiner Freizeit eingenommen.  Damit Kinder und Jugendliche heute und in Zukunft ebenfalls die Chance haben tolle Erfahrungen in der evangelischen Jugendarbeit zu machen engagiere ich mich seit 2011 im BAK und bin seit 2017 Vorsitzende des eje." ,
        email: "Christina.Kurz@eje-esslingen.de",
        threema: "3U8T7XHZ",),
    );
    _box.add(
      new BAKler(
        bild: "assets/testdata/nici.jpg",
        name: "Nicolai Schmauder",
        amt: "stv. Vorsitzender",
        vorstellung:"Zur Zeit wohne ich in Kernen im Remstal, davor habe ich vier Jahre lange in Denkendorf gelebt und war dort im CVJM Teenkreis Mitarbeiter. Seit November 2014 bin ich im BAK und seit 2017 stellvertretender Vorsitzender des eje.Ich liebe Jugendarbeit und wünsche mir, dass wir als eje dazu beitragen, die Kinder- und Jugendarbeit voranzubringen und sie auch für die Zukunft gut aufstellen können. ",
        email: "Nicolai.Schmauder@eje-esslingen.de",
        threema: "8F8EV7M5",),
    );
    _box.add(
      new BAKler(
        bild: "assets/testdata/patrick.jpg",
        name: "Patric Wittman",
        amt: "Vorstandsmitglied",
        vorstellung:"Jugendarbeit ist für mich: Jungschar, Kinderkirche, Eichenkreuz, Freizeiten, Schulungen. Kurz, schon immer Teil meines Lebens. Spätestens seit meinem FSJ im eje ist mir klar, dass ich mich einbringen, ewas zurückgeben und vor allem bewegen möchte: Kindern & Jugendlichen zeigen wie toll Evangelische Jugendarbeit ist - ganz nach dem Motto „einfach lebendig“. Diese Chance habe ich seit 2017 im BAK und ich freue mich darauf.",
        email: "Patric.Wittman@eje-esslingen.de",
        threema: "",),
    );
    _box.add(
      new BAKler(
        bild: "assets/testdata/krische.jpg",
        name: "Christian Diehl",
        amt: "Rechner",
        vorstellung:"Jugendarbeit ist für mich: Jungschar, Kinderkirche, Eichenkreuz, Freizeiten, Schulungen. Kurz, schon immer Teil meines Lebens. Spätestens seit meinem FSJ im eje ist mir klar, dass ich mich einbringen, ewas zurückgeben und vor allem bewegen möchte: Kindern & Jugendlichen zeigen wie toll Evangelische Jugendarbeit ist - ganz nach dem Motto „einfach lebendig“. Diese Chance habe ich seit 2017 im BAK und ich freue mich darauf.",
        email: "Chrsitian.Diehl@eje-esslingen.de",
        threema: "ANWKWBRM",),
    );
    _box.add(
      new BAKler(
        bild: "assets/testdata/lena.jpg",
        name: "Lena-Marie Maisenhölder",
        amt: "Schriftführerin",
        vorstellung:"Ursprünglich aus Aichwald studiere ich nun Lehramt mit den Fächern Mathematik und evangelische Theologie in Ludwigsburg. Das eje und vor allem die Freizeitarbeit liegen mir am Herzen und daher bin ich seit 2016 im BAK, um das Jugendwerk mitzugestalten und mich aktiv einzubringen.",
        email: "lena-marie.schnabl@eje-esslingen.de",
        threema: "ANWKWBRM",),
    );
    _box.add(
      new BAKler(
        bild: "assets/testdata/debora.jpg",
        name: "Debora Graf",
        amt: "BAK",
        vorstellung:"Von klein auf bin ich mit der evangelischen Jugendarbeit verbunden: Kindergruppen, Jungschar, Freizeiten, Eichenkreuzsport und Posaunenchor haben mich als Kind und Jugendliche geprägt, so dass ich nach meinem Grund- und Aufbaukurs selbst Mitarbeiterin werden wollte. Seit 2017 bringe ich mich im BAK ein, da ich diese positiven Erlebnisse auch anderen Kindern und Jugendlichen ermöglichen möchte.",
        email: "debora.graf@eje-esslingen.de",
        threema: "ANWKWBRM",),
    );

  }
}