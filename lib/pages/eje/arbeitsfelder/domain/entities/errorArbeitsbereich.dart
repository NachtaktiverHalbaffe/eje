import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';

FieldOfWork getErrorArbeitsbereich() {
  return FieldOfWork(
    arbeitsfeld: "Keine Internetverbindung oder keine Daten im Cache ",
    bilder: [""],
    inhalt:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
    url: "",
  );
}
