import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/einstellungen/data/repositories/einstellungen_repository_impl.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:eje/pages/einstellungen/domain/usecases/getPreference.dart';
import 'package:eje/pages/einstellungen/domain/usecases/getPreferences.dart';
import 'package:eje/pages/einstellungen/domain/usecases/setPrefrences.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/hauptamtliche_local_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/hauptamtliche_remote_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/repositories/hauptamliche_repository_impl.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/hauptamtliche_repository.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/repositories/neuigkeiten_repository_impl.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeiten.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // ! Pages

  // ! Neuigkeiten
  // * Bloc
  sl.registerFactory(
    () => NeuigkeitenBlocBloc(
      getNeuigkeit: sl(),
      getNeuigkeiten: sl(),
    ),
  );
  // * Use cases
  sl.registerLazySingleton(() => GetNeuigkeit(sl()));
  sl.registerLazySingleton(() => GetNeuigkeiten(sl()));
  // * Repository
  sl.registerLazySingleton<NeuigkeitenRepository>(
    () => NeuigkeitenRepositoryImpl(
      remoteDataSource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  // * Datasources
  sl.registerLazySingleton(
    () => NeuigkeitenRemoteDatasource(
      client: sl(),
    ),
  );
  sl.registerLazySingleton(() => NeuigkeitenLocalDatasource(sl()));

  // ! Einstellungen
  // * Bloc
  sl.registerFactory(() => EinstellungBloc(sl(), sl(), sl()));
  // * Use cases
  sl.registerLazySingleton(() => GetPreference(sl()));
  sl.registerLazySingleton(() => SetPreferences(sl()));
  sl.registerLazySingleton(() => GetPreferences(sl()));
  // * Repository
  sl.registerLazySingleton<EinstellungenRepository>(
      () => EinstellungenRepositoryImpl());

  // ! Hauptamtliche
  // * Bloc
  sl.registerFactory(
    () => HauptamtlicheBloc(
      getHauptamtliche: sl(),
      getHauptamtlicher: sl(),
    ),
  );
  // * Use cases
  sl.registerLazySingleton(() => GetHauptamtliche(repository: sl()));
  sl.registerLazySingleton(() => GetHauptamtlicher(sl()));
  // * Repository
  sl.registerLazySingleton<HauptamtlicheRepository>(
    () => HauptamtlicheRepositoryImpl(
      remoteDataSource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  // * Datasources
  sl.registerLazySingleton(()=>HauptamtlicheLocalDatasource(sl()));
  sl.registerLazySingleton(()=> HauptamtlicheRemoteDatasource(client: sl()));

  // ! Core
  // * NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ! External
  // * Hive
  final Box neuigkeiten_box = await Hive.openBox('Neuigkeiten');
  sl.registerLazySingleton(() => neuigkeiten_box);
  final Box hauptamtliche_box = await Hive.openBox('Hauptamtliche');
  sl.registerLazySingleton(() => hauptamtliche_box);
  // * Remote Access
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
