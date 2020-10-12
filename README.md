# eje
App vom Evangelischen Jugendwerk Esslingen. Entwickelt mit Flutter.

## Architektur
Die Architektur ist in 3 primäre Ebenen aufgeteilt: Data, Domain und Presentation. 

![Modell der Software-Architektur](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi0.wp.com%2Fresocoder.com%2Fwp-content%2Fuploads%2F2019%2F08%2FClean-Architecture-Flutter-Diagram.png%3Fresize%3D556%252C707%26ssl%3D1&f=1&nofb=1)

### Data-Layer
In Data gibt es 2 Datasources, eine Remote die Daten aus dem Internet holt und eine lokale Datenbank, die diese cached un für den Offline-Betrieb bereitstellt. Diese 2 Datasources werden von repositories vereint und stellt die Schnittstelle zwischen Daten- und Domainebene dar. 


### Domain-Layer
In der Domainebene werden die Daten aus dem Backend in den Repositories als Entitäten bereitgestellt. Über die Use-Cases können die Entitäten für verschiedene Anwendungsfälle aufgerufen werden.

### Presentation Layer
In der Presentationebene wird das Statemanagment betrieben, die Logik für das Frontend behandelt und die Widgets gerendert. Diese Ebene stellt das typische Frontend dar


## Module

## Widget-Tree

## Benutzte Librarys
- [Hive](https://github.com/hivedb/hive) und [Path Provider](https://github.com/flutter/plugins) (Depenmdency von Hive) als Offline-Database
- [Webfeed](https://github.com/witochandra/webfeed) zum parsen der RSS-Feeds, über die Daten der ListViews der Homepage des eje bezogen werden
- [HTML](https://github.com/dart-lang/html) für WebScraping, über das Daten einzelner Seiten der Homepage bezogen werden
- [Bloc](https://github.com/felangel/bloc/tree/master/packages/bloc) für State-Managment
- [Equatable](https://github.com/felangel/equatable) und [Dartz](https://github.com/spebbe/dartz) als Tools für die Architektur
- [Data Connection Checker](https://github.com/komapeb/data_connection_checker), [connectivity](https://github.com/flutter/plugins) und [http](https://github.com/dart-lang/http) für online-API-Aufrufe
- [Get it](https://github.com/fluttercommunity/get_it) für Dependency Injection
- [Persistent Bottom Nav Bar](https://github.com/BilalShahid13/PersistentBottomNavBar) als Widget für die Navigation
- [Material Design Icons](https://github.com/ziofat/material_design_icons_flutter) und [Icon Shadow](https://github.com/mehrtarh/flutter_icon_shadow) für Icons
- [WebView](https://github.com/flutter/plugins) und [URL-Launcher](https://github.com/flutter/plugins) für das Anzeigen von Websiten
- [Pageview-Indicators](https://github.com/figengungor/page_view_indicators) für Indicator-Punkte bei Pageviewer (größtenteils swipebare Bilder)
- [Flutter-Swiper](https://github.com/best-flutter/flutter_swiper) für Card-Swipe-Views (Widget im Frontend)
- [Cached Network Image](https://github.com/Baseflow/flutter_cached_network_image) zum cachen von Bildern
