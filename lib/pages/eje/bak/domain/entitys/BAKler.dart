import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'bakler.g.dart';

@HiveType(typeId: 2)
class BAKler extends Equatable {
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
  final String threema;

  BAKler({
    @required this.image,
    @required this.name,
    @required this.function,
    @required this.introduction,
    @required this.email,
    @required this.threema,
  });

  @override
  List<Object> get props =>
      [image, name, function, introduction, email, threema];
}
