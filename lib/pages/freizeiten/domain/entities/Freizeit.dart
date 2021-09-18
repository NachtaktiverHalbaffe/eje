import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Freizeit.g.dart';

@HiveType(typeId: 5)
class Freizeit extends Equatable {
  @HiveField(0)
  final String freizeit;
  @HiveField(1)
  final String datum;
  @HiveField(2)
  final String alter;
  @HiveField(3)
  final String preis;
  @HiveField(4)
  final String platz_frei;
  @HiveField(5)
  final Ort ort;
  @HiveField(6)
  final String link;
  @HiveField(7)
  final List<String> bilder;
  @HiveField(8)
  final String beschreibung;
  @HiveField(9)
  final String anmeldeschluss;
  @HiveField(10)
  final String verpflegung;
  @HiveField(11)
  final String unterbringung;
  @HiveField(12)
  final String anreise;
  @HiveField(13)
  final String sonstige_leistungen;
  @HiveField(14)
  final String motto;
  @HiveField(15)
  final List<String> begleiter;

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
