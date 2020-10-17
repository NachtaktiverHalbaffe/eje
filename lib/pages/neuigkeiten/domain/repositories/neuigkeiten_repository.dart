import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';

abstract class NeuigkeitenRepository {
  Future<Either<Failure, List<Article>>> getNeuigkeit(
      String titel); // Einen Artikel laden
  Future<Either<Failure, List<Neuigkeit>>>
      getNeuigkeiten(); // Alle Artike laden
}
