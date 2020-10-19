import 'Article.dart';
import 'Hyperlink.dart';

Article getErrorArticle() {
  return Article(
      url: "",
      titel: "Keine Internetverbindung oder keine Daten im Cache ",
      content:
          "Stellen sie sicher, dass sie eine Internetverbindung haben. Falls Sie dies zum ersten mal aufgrufen haben, dann sind noch keine Daten für den offline-Betrieb gecachded. Ansonsten stellen sie sicher, dass keine Daten von dieser App gelöscht werden. Die App speichert ausschließlich Cache-Daten.",
      bilder: [""],
      hyperlinks: [Hyperlink(link: "", description: "")]);
}
