import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';

class SetPreferences implements UseCase<void> {
  final EinstellungenRepository repository;

  SetPreferences(this.repository);

  @override
  Future<Either<Failure, void>> call({
    String? preference,
    bool? state,
  }) async {
    return await repository.storePrefrences(preference ?? "", state ?? false);
  }
}
