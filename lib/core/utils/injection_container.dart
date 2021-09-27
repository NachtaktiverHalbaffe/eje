import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/articles/data/datasources/articlesLocalDatasource.dart';
import 'package:eje/pages/articles/data/repository/articlesRepositoryImpl.dart';
import 'package:eje/pages/articles/domain/repositories/ArticlesRepository.dart';
import 'package:eje/pages/articles/domain/usecases/getArticle.dart';
import 'package:eje/pages/articles/domain/usecases/getArticles.dart';
import 'package:eje/pages/articles/presentation/bloc/articles_bloc.dart';
import 'package:eje/pages/einstellungen/data/repositories/einstellungen_repository_impl.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:eje/pages/einstellungen/domain/usecases/getPreference.dart';
import 'package:eje/pages/einstellungen/domain/usecases/getPreferences.dart';
import 'package:eje/pages/einstellungen/domain/usecases/setPrefrences.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_local_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/repositories/arbeitsbereich_repository_impl.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/arbeitsbereich_repository.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/GetArbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/GetArbeitsbereiche.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:eje/pages/eje/bak/data/datasources/bak_local_datasource.dart';
import 'package:eje/pages/eje/bak/data/datasources/bak_remote_datasource.dart';
import 'package:eje/pages/eje/bak/data/repositories/bak_repository_impl.dart';
import 'package:eje/pages/eje/bak/domain/repositories/bak_repository.dart';
import 'package:eje/pages/eje/bak/domain/usecases/GetBAK.dart';
import 'package:eje/pages/eje/bak/domain/usecases/GetBAKler.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/hauptamtliche_local_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/hauptamtliche_remote_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/repositories/hauptamliche_repository_impl.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/hauptamtliche_repository.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:eje/pages/eje/services/data/datasources/ServicesLocalDatasource.dart';
import 'package:eje/pages/eje/services/data/datasources/ServicesRemoteDatasource.dart';
import 'package:eje/pages/eje/services/data/repositories/services_repository_impl.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';
import 'package:eje/pages/eje/services/domain/usecases/GetService.dart';
import 'package:eje/pages/eje/services/domain/usecases/GetServices.dart';
import 'package:eje/pages/eje/services/presentation/bloc/services_bloc.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_local_datasource.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_remote_datasource.dart';
import 'package:eje/pages/freizeiten/data/repositories/camps_repository_impl.dart';
import 'package:eje/pages/freizeiten/domain/repositories/camp_repository.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camp.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camps.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/repositories/neuigkeiten_repository_impl.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/GetNeuigkeiten.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/termine/data/datasources/events_local_datasource.dart';
import 'package:eje/pages/termine/data/datasources/events_remote_datasource.dart';
import 'package:eje/pages/termine/data/repositories/events_repositoy_impl.dart';
import 'package:eje/pages/termine/domain/repsoitories/events_repository.dart';
import 'package:eje/pages/termine/domain/usecases/get_Event.dart';
import 'package:eje/pages/termine/domain/usecases/get_Events.dart';
import 'package:eje/pages/termine/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
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
    () => NeuigkeitenRemoteDatasource(),
  );
  sl.registerLazySingleton(() => NeuigkeitenLocalDatasource());

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
  sl.registerLazySingleton(() => HauptamtlicheLocalDatasource());
  sl.registerLazySingleton(() => HauptamtlicheRemoteDatasource(client: sl()));

  // ! BAK
  // * Bloc
  sl.registerFactory(() => BakBloc(
        getBAK: sl(),
        getBAKler: sl(),
      ));
  // * Use cases
  sl.registerLazySingleton(() => GetBAKler(sl()));
  sl.registerLazySingleton(() => GetBAK(repository: sl()));
  // * Repository
  sl.registerLazySingleton<BAKRepository>(() => BAKRepositoryImpl(
        remoteDataSource: sl(),
        localDatasource: sl(),
        networkInfo: sl(),
      ));
  // * Datasources
  sl.registerLazySingleton(() => BAKLocalDatasource());
  sl.registerLazySingleton(() => BAKRemoteDatasource(client: sl()));

  // ! Arbeitsbereiche
  // * Bloc
  sl.registerFactory(
    () => ArbeitsbereicheBloc(
      getArbeitsbereich: sl(),
      getArbeitsbereiche: sl(),
    ),
  );
  // * Usecases
  sl.registerLazySingleton(() => GetArbeitsbereich(sl()));
  sl.registerLazySingleton(() => GetArbeitsbereiche(repository: sl()));
  // * Repsoitory
  sl.registerLazySingleton<ArbeitsbereichRepository>(
      () => ArbeitsbereichRepositoryImpl(
            remoteDataSource: sl(),
            localDatasource: sl(),
            networkInfo: sl(),
          ));
  // * Datasources
  sl.registerLazySingleton(() => ArbeitsbereicheLocalDatasource());
  sl.registerLazySingleton(() => ArbeitsbereichRemoteDatasource(client: sl()));

  // ! Services
  sl.registerFactory(() => ServicesBloc(
        getService: sl(),
        getServices: sl(),
      ));
  // * Usecases
  sl.registerLazySingleton(() => GetService(sl()));
  sl.registerLazySingleton(() => GetServices(repository: sl()));
  // * Repository
  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl(
        remoteDataSource: sl(),
        localDatasource: sl(),
        networkInfo: sl(),
      ));
  // * Datrasources
  sl.registerLazySingleton(() => ServicesLocalDatasource());
  sl.registerLazySingleton(() => ServicesRemoteDatasource(client: sl()));

  // ! Termine
  // * Bloc
  sl.registerFactory(() => TermineBloc(getEvents: sl(), getEvent: sl()));
  // * Usecases
  sl.registerLazySingleton(() => GetEvent(sl()));
  sl.registerLazySingleton(() => GetEvents(repository: sl()));
  // * Repository
  sl.registerLazySingleton<EventsRepository>(() => EventsRepositoryImpl(
        remoteDataSource: sl(),
        localDatasource: sl(),
        networkInfo: sl(),
      ));
  // * Datasources
  sl.registerLazySingleton(() => EventLocalDatasource());
  sl.registerLazySingleton(() => TermineRemoteDatasource(client: sl()));

  // ! Freizeiten
  sl.registerFactory(() => CampsBloc(
        getCamp: sl(),
        getCamps: sl(),
      ));
  // * Usecases
  sl.registerLazySingleton(() => GetCamp(sl()));
  sl.registerLazySingleton(() => GetCamps(repository: sl()));
  // * Repository
  sl.registerLazySingleton<CampRepository>(() => CampRepositoryImpl(
        remoteDataSource: sl(),
        localDatasource: sl(),
        networkInfo: sl(),
      ));
  // * Datasources
  sl.registerLazySingleton(() => CampsLocalDatasource());
  sl.registerLazySingleton(() => CampsRemoteDatasource());

  // ! Articles
  sl.registerFactory(() => ArticlesBloc(
        getArticle: sl(),
        getArticles: sl(),
      ));
  // * Usecases
  sl.registerLazySingleton(() => GetArticle(sl()));
  sl.registerLazySingleton(() => GetArticles(sl()));
  // * Repository
  sl.registerLazySingleton<ArticlesRepository>(() => ArticlesRepositoryImpl(
        localDatasource: sl(),
        networkInfo: sl(),
      ));
  // * Datasources
  sl.registerLazySingleton(() => ArticlesLocalDatasource());

  // ! Core
  // * NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl(), sl()));

  // ! External
  // * Remote Access
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
