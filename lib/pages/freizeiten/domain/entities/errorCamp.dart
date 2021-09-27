import 'package:eje/core/platform/location.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';

Camp getErrorCamp() {
  return Camp(
    name: "Keine Internetverbindung oder keine Daten im Cache ",
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    ageFrom: 0,
    ageTo: 0,
    price: 0,
    occupancy: "",
    location: Location("", "", ""),
    registrationLink: "",
    pictures: [""],
    description:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
    registrationEnd: DateTime.now(),
    catering: "",
    accommodation: "",
    journey: "",
    otherServices: "",
    companions: [""],
  );
}
