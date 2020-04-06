import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'hauptamtlicher.g.dart';

@HiveType(typeId: 1)
class Hauptamtlicher extends Equatable {
  @HiveField(0)
  final String bild;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String bereich; //Art der Anstelluing(Jugendreferent, Sachverwalter etc)
  @HiveField(3)
  final String vorstellung; //Text, in den sich hauptamtlicher vorstellt
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String telefon;
  @HiveField(6)
  final String handy;
  @HiveField(7)
  final String threema;

  Hauptamtlicher({
    @required this.bild,
    @required this.name,
    @required this.bereich,
    @required this.vorstellung,
    @required this.email,
    @required this.telefon,
    @required this.handy,
    @required this.threema,
  });

  @override
  List<Object> get props => [bild,name,bereich,vorstellung,email,telefon,handy,threema];
}
