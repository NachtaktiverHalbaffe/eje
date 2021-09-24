import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/termine/domain/entities/Ort.dart';

Camp getErrorCamp() {
  return Camp(
    name: "Keine Internetverbindung oder keine Daten im Cache ",
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    startAge: 0,
    endAge: 0,
    price: 0,
    freePlaces: "",
    location: Ort("", "", ""),
    link: "",
    pictures: [""],
    description:
        "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
    registrationDeadline: "",
    catering: "",
    lodging: "",
    journey: "",
    otherServices: "",
    companion: [""],
  );
}
