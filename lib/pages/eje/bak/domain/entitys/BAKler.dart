import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'BAKler.g.dart';

@HiveType(typeId: 2)
class BAKler extends Equatable {
  @HiveField(0)
  final String bild;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String amt; //Art der Anstelluing(Jugendreferent, Sachverwalter etc)
  @HiveField(3)
  final String vorstellung; //Text, in den sich hauptamtlicher vorstellt
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String threema;

  BAKler({
    @required this.bild,
    @required this.name,
    @required this.amt,
    @required this.vorstellung,
    @required this.email,
    @required this.threema,
  });

  @override
  List<Object> get props => [bild,name,amt,vorstellung,email,threema];
}
