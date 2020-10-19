import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';

Hauptamtlicher getErrorHauptamtlicher() {
  return Hauptamtlicher(
    bild: "",
    name: "Keine Internetverbindung oder keine Daten im Cache ",
    bereich: "",
    vorstellung:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
    email: "",
    telefon: "",
    handy: "",
    threema: "",
  );
}
