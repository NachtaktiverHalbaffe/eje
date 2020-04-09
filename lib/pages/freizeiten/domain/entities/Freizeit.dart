import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Freizeit.g.dart';

@HiveType(typeId: 5)
class Freizeit extends Equatable {
  @HiveField(0)
  String freizeit;
  @HiveField(1)
  String datum;
  @HiveField(2)
  String alter;
  @HiveField(3)
  String preis;
  @HiveField(4)
  String platz_frei;
  @HiveField(5)
  Ort ort;
  @HiveField(6)
  String link;
  @HiveField(7)
  List<String> bilder;
  @HiveField(8)
  String beschreibung;
  @HiveField(9)
  String anmeldeschluss;
  @HiveField(10)
  String verpflegung;
  @HiveField(11)
  String unterbringung;
  @HiveField(12)
  String anreise;
  @HiveField(13)
  String sonstige_leistungen;
  @HiveField(14)
  String motto;
  @HiveField(15)
  List<String> begleiter;

  Freizeit(
      {this.freizeit,
      this.datum,
      this.alter,
      this.preis,
      this.platz_frei,
      this.ort,
      this.link,
      this.bilder,
      this.beschreibung,
      this.anmeldeschluss,
      this.verpflegung,
      this.unterbringung,
      this.anreise,
      this.sonstige_leistungen,
      this.motto,
      this.begleiter});

  @override
  List<Object> get props => [
        freizeit,
        datum,
        alter,
        preis,
        platz_frei,
        ort,
        link,
        bilder,
        beschreibung,
        anmeldeschluss,
        verpflegung,
        unterbringung,
        anreise,
        sonstige_leistungen,
        begleiter
      ];
}
