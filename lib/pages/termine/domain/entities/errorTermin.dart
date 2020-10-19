import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';

Termin getErrorTermin() {
  return Termin(
    veranstaltung: "Keine Internetverbindung oder keine Daten im Cache ",
    bild: "",
    motto: "",
    datum: "",
    ort: Ort("", "", ""),
    text:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
  );
}
