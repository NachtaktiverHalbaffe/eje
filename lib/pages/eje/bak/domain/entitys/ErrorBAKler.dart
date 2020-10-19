import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';

BAKler getErrorBAKler() {
  return BAKler(
      bild: "",
      name: "Keine Internetverbindung oder keine Daten im Cache ",
      amt: "null",
      vorstellung:
          "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
      email: "",
      threema: "");
}
