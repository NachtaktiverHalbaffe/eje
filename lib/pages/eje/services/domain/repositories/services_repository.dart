import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';

abstract class ServicesRepository {
  Future<Either<Failure, Service>> getService(
      Service service); // Einen Service laden
  Future<Either<Failure, List<Service>>> getServices(); // Alle Services laden
}
