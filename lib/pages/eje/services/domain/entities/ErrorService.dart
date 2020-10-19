import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';

Service getErrorService() {
  return Service(
      service: "Keine Internetverbindung oder keine Daten im Cache ",
      bilder: [""],
      inhalt:
          "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
      hyperlinks: [Hyperlink(link: "", description: "")]);
}
