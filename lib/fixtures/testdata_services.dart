import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:hive/hive.dart';

void data_services(Box _box) {
  if (_box.length < 2) {
    List<String> bilder = new List();
    bilder.add("assets/images/info.jpg");
    List<String> hyperlinks = new List();
    hyperlinks.add("https://www.eje-esslingen.de/service/eje-info/");
    _box.add(
      new Service(
          service: "eje-Info",
          bilder: bilder,
          inhalt:
              "Das eje-INFO erscheint dreimal im Jahr in einer Auflage von 1000 Exemplaren und wird an alle Interessierte verteilt. Hier kannst du es als PDF runterladen\n\nDas eje-INFO erscheint dreimal im Jahr in einer Auflage von 1000 Exemplaren und wird an alle Interessierte verteilt.",
          hyperlinks: hyperlinks),
    );

    bilder = new List();
    bilder.add("assets/images/rent.jpg");
    hyperlinks = new List();
    hyperlinks.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Service/Ausleihgebuehren_2018_Homepage.pdf");
    hyperlinks.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Service/Ausleihgebuehren_2018_Homepage.pdf");
    _box.add(new Service(
        service: "Verleih",
        bilder: bilder,
        inhalt:
            "Das eje verleiht an kirchliche Gruppen und Vereine ausgewähltes Material. Die Verleihliste kann als PDF heruntergeladen werden",
        hyperlinks: hyperlinks));
  }
}
