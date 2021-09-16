import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'Arbeitsbereich.g.dart';

@HiveType(typeId: 3)
class FieldOfWork extends Equatable {
  @HiveField(0)
  final String arbeitsfeld;
  @HiveField(1)
  final List<String> bilder;
  @HiveField(2)
  final String inhalt;
  @HiveField(3)
  final String url;

  FieldOfWork({
    @required this.arbeitsfeld,
    @required this.bilder,
    @required this.inhalt,
    this.url,
  });

  @override
  List<Object> get props => [arbeitsfeld, bilder, inhalt, url];
}
