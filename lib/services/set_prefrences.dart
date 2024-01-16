import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/repositories/einstellungen_repository.dart';

class SetPreferences implements Service<void> {
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
