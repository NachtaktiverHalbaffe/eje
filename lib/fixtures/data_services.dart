// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:eje/models/hyperlink.dart';
import 'package:eje/models/offered_service.dart';
import 'package:hive_ce/hive.dart';

Future<void> dataServices(String boxName) async {
  final Box _box = await Hive.openBox(boxName);
  await _box.clear();

  if (_box.length < 6) {
    List<String> bilder = List.empty(growable: true);
    bilder.add("assets/images/info.jpg");
    List<Hyperlink> hyperlinks = List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=311673",
        description: "eje-infos"));
    await _box.add(
      OfferedService(
          service: "eje-Info",
          images: bilder,
          description:
              "Das eje-INFO erscheint dreimal im Jahr in einer Auflage von 1000 Exemplaren und wird an alle Interessierte verteilt. Hier kannst du es als PDF runterladen\n\nDas eje-INFO erscheint dreimal im Jahr in einer Auflage von 1000 Exemplaren und wird an alle Interessierte verteilt.",
          hyperlinks: hyperlinks),
    );

    bilder = List.empty(growable: true);
    bilder.add("assets/images/rent.jpg");
    hyperlinks = List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=264807",
        description: "Verleih-Liste runterladen"));
    await _box.add(OfferedService(
        service: "Verleih",
        images: bilder,
        description:
            "Das eje verleiht an kirchliche Gruppen und Vereine ausgewähltes Material. Die Verleihliste kann als PDF heruntergeladen werden",
        hyperlinks: hyperlinks));

    bilder = List.empty(growable: true);
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Freizeitheim_Asch/Freizeitheim_Asch.jpg");
    hyperlinks = List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=305545",
        description: "Freizeitheim Asch"));
    await _box.add(
      OfferedService(
        images: bilder,
        hyperlinks: hyperlinks,
        service: "Freizeitheim Asch",
        description: "",
      ),
    );

    bilder = List.empty(growable: true);
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Zeltplatz_Hopfensee/HOPFENSEELOGO.jpg");
    hyperlinks = List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=264813",
        description: "Hopfensee"));
    await _box.add(
      OfferedService(
        images: bilder,
        hyperlinks: hyperlinks,
        service: "Zeltplatz Hopfensee",
        description: "",
      ),
    );

    bilder = List.empty(growable: true);
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/mediapool/gemeinden/ejw_esslingen/Bilder_fuer_NEWS/Delegiertenversammlung_2018_14.jpg");
    hyperlinks = List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=285500",
        description: "Vernetzung"));
    await _box.add(
      OfferedService(
        images: bilder,
        hyperlinks: hyperlinks,
        service: "Vernetzung",
        description: "",
      ),
    );

    bilder = List.empty(growable: true);
    bilder.add(
        "https://www.eje-esslingen.de/fileadmin/_processed_/6/4/csm_Schulungswoche201805_2536da718b.jpg");
    hyperlinks = List.empty(growable: true);
    hyperlinks.add(Hyperlink(
        link: "https://www.eje-esslingen.de/?id=330343",
        description: "Konzepte"));
    await _box.add(
      OfferedService(
        images: bilder,
        hyperlinks: hyperlinks,
        service: "Konzepte",
        description: "",
      ),
    );

    await _box.close();
  }
}
