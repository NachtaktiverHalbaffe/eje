import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 1)
class Employee extends Equatable {
  @HiveField(0)
  final String image;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String
      function; //Art der Anstelluing(Jugendreferent, Sachverwalter etc)
  @HiveField(3)
  final String introduction; //Text, in den sich hauptamtlicher vorstellt
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String telefon;
  @HiveField(6)
  final String handy;
  @HiveField(7)
  final String threema;

  Employee({
    required this.image,
    required this.name,
    required this.function,
    required this.introduction,
    required this.email,
    required this.telefon,
    required this.handy,
    required this.threema,
  });

  @override
  List<Object> get props =>
      [image, name, function, introduction, email, telefon, handy, threema];
}
