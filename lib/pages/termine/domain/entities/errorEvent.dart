import 'package:eje/core/platform/location.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';

Event getErrorTermin() {
  return Event(
    id: 0,
    name: "Keine Internetverbindung oder keine Daten im Cache ",
    images: [""],
    motto: "",
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    location: Location("", "", ""),
    description:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
  );
}
