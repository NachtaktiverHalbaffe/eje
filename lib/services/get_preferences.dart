import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/repositories/einstellungen_repository.dart';
import 'package:get_storage/get_storage.dart';

class GetPreferences implements Service<GetStorage> {
  final EinstellungenRepository repository;

  GetPreferences(this.repository);

  @override
  Future<Either<Failure, GetStorage>> call() async {
    return await repository.getPrefrences();
  }
}
