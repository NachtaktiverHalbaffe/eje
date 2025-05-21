import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'field_of_work.g.dart';

@HiveType(typeId: 3)
class FieldOfWork extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final List<String> images;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String link;

  FieldOfWork({
    required this.name,
    required this.images,
    required this.description,
    this.link = "",
  });

  @override
  List<Object> get props => [name, images, description, link];
}
