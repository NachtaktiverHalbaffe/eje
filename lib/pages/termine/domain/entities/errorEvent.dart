import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';

Event getErrorTermin() {
  return Event(
    name: "Keine Internetverbindung oder keine Daten im Cache ",
    images: [""],
    motto: "",
    startDate: DateTime.now(),
    location: Ort("", "", ""),
    description:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
  );
}
