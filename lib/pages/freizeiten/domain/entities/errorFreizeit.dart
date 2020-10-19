import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/termine/domain/entities/Ort.dart';

Freizeit getErrorFreizeit() {
  return Freizeit(
    freizeit: "Keine Internetverbindung oder keine Daten im Cache ",
    datum: "",
    alter: "",
    preis: "",
    platz_frei: "",
    ort: Ort("", "", ""),
    link: "",
    bilder: [""],
    beschreibung:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
    anmeldeschluss: "",
    verpflegung: "",
    unterbringung: "",
    anreise: "",
    sonstige_leistungen: "",
    begleiter: [""],
  );
}
