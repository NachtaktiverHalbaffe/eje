import 'package:eje/core/platform/Hyperlink.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:hive/hive.dart';

void data_services(Box _box) {
  if (_box.length < 5) {
    List<String> bilder = new List();
    bilder.add("assets/images/info.jpg");
    List<Hyperlink> hyperlinks = new List();
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/service/eje-info/",
        description: "eje-infos"));
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
    hyperlinks.add(Hyperlink(
        link:
            "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Service/Ausleihgebuehren_2018_Homepage.pdf",
        description: "Verleih-Liste runterladen"));
    _box.add(new Service(
        service: "Verleih",
        bilder: bilder,
        inhalt:
            "Das eje verleiht an kirchliche Gruppen und Vereine ausgewähltes Material. Die Verleihliste kann als PDF heruntergeladen werden",
        hyperlinks: hyperlinks));

    bilder = new List();
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Freizeitheim_Asch/Freizeitheim_Asch.jpg");
    hyperlinks = new List();
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/service/freizeitheim-asch/",
        description: "Freizeitheim Asch"));
    _box.add(
      new Service(
        bilder: bilder,
        hyperlinks: hyperlinks,
        service: "Freizeitheim Asch",
        inhalt: "",
      ),
    );

    bilder = new List();
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Zeltplatz_Hopfensee/HOPFENSEELOGO.jpg");
    hyperlinks = new List();
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/service/zeltplatz-hopfensee/",
        description: "Hopfensee"));
    _box.add(
      new Service(
        bilder: bilder,
        hyperlinks: hyperlinks,
        service: "Zeltplatz Hopfensee",
        inhalt: "",
      ),
    );

    bilder = new List();
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Bilder_fuer_NEWS/Delegiertenversammlung_2018_14.jpg");
    hyperlinks = new List();
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/service/vernetzung/",
        description: "Vernetzung"));
    _box.add(
      new Service(
        bilder: bilder,
        hyperlinks: hyperlinks,
        service: "Vernetzung",
        inhalt: "",
      ),
    );
  }
}
