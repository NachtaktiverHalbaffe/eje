import 'package:dartz/dartz.dart';
import 'package:eje/models/einstellung.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/SharedPreferencesRepository.dart';
import 'package:get_storage/get_storage.dart';

class SettingsService {
  final SharedPreferencesRepository repository;

  SettingsService.SharedPreferencesService({required this.repository});

  Future<Either<Failure, Einstellung>> getPrefrence({
    String? preference,
  }) async {
    return await repository.getElement("", preference!);
  }

  Future<Either<Failure, GetStorage>> getPrefrences() async {
    return await repository.getPrefrences();
  }

  Future<Either<Failure, void>> setPrefrence(
      {String? preference, bool? state}) async {
    return await repository.storePrefrences(preference ?? "", state ?? false);
  }
}
