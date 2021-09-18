import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:hive/hive.dart';

void dataServices(Box _box) {
  if (_box.length < 5) {
    List<String> bilder = new List.empty(growable: true);
    bilder.add("assets/images/info.jpg");
    List<Hyperlink> hyperlinks = new List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=311673",
        description: "eje-infos"));
    _box.add(
      new Service(
          service: "eje-Info",
          bilder: bilder,
          inhalt:
              "Das eje-INFO erscheint dreimal im Jahr in einer Auflage von 1000 Exemplaren und wird an alle Interessierte verteilt. Hier kannst du es als PDF runterladen\n\nDas eje-INFO erscheint dreimal im Jahr in einer Auflage von 1000 Exemplaren und wird an alle Interessierte verteilt.",
          hyperlinks: hyperlinks),
    );

    bilder = new List.empty(growable: true);
    bilder.add("assets/images/rent.jpg");
    hyperlinks = new List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=264807",
        description: "Verleih-Liste runterladen"));
    _box.add(new Service(
        service: "Verleih",
        bilder: bilder,
        inhalt:
            "Das eje verleiht an kirchliche Gruppen und Vereine ausgewähltes Material. Die Verleihliste kann als PDF heruntergeladen werden",
        hyperlinks: hyperlinks));

    bilder = new List.empty(growable: true);
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Freizeitheim_Asch/Freizeitheim_Asch.jpg");
    hyperlinks = new List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=305545",
        description: "Freizeitheim Asch"));
    _box.add(
      new Service(
        bilder: bilder,
        hyperlinks: hyperlinks,
        service: "Freizeitheim Asch",
        inhalt: "",
      ),
    );

    bilder = new List.empty(growable: true);
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Zeltplatz_Hopfensee/HOPFENSEELOGO.jpg");
    hyperlinks = new List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=264813",
        description: "Hopfensee"));
    _box.add(
      new Service(
        bilder: bilder,
        hyperlinks: hyperlinks,
        service: "Zeltplatz Hopfensee",
        inhalt: "",
      ),
    );

    bilder = new List.empty(growable: true);
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Bilder_fuer_NEWS/Delegiertenversammlung_2018_14.jpg");
    hyperlinks = new List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=285500",
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
