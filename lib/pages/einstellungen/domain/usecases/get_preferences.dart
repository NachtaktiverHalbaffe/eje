import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:get_storage/get_storage.dart';

class GetPreferences implements UseCase<GetStorage> {
  final EinstellungenRepository repository;

  GetPreferences(this.repository);

  @override
  Future<Either<Failure, GetStorage>> call() async {
    return await repository.getPrefrences();
  }
}
