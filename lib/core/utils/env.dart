import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'assets/config/.env')
abstract class Env {
  // * Remote data sources
  // API Endpoint to feed "Freizeiten" and "Termine"
  @EnviedField(obfuscate: true, varName: 'AMOSURL')
  static final String amosURL = _Env.amosURL;
  // Token for AmosWeb
  @EnviedField(obfuscate: true, varName: 'AMOSTOKEN')
  static final String amosToken = _Env.amosToken;
}
