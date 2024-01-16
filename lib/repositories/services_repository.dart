import 'package:dartz/dartz.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/failures.dart';

abstract class ServicesRepository {
  Future<Either<Failure, OfferedService>> getService(
      OfferedService service); // Einen Service laden
  Future<Either<Failure, List<OfferedService>>>
      getServices(); // Alle Services laden
}
