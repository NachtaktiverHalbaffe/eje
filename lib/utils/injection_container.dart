import 'package:eje/datasources/arbeitsbereich_local_datasource.dart';
import 'package:eje/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/datasources/articles_local_datasource.dart';
import 'package:eje/datasources/bak_local_datasource.dart';
import 'package:eje/datasources/bak_remote_datasource.dart';
import 'package:eje/datasources/camps_local_datasource.dart';
import 'package:eje/datasources/camps_remote_datasource.dart';
import 'package:eje/datasources/employees_local_datasource.dart';
import 'package:eje/datasources/employees_remote_datasource.dart';
import 'package:eje/datasources/news_local_datasource.dart';
import 'package:eje/datasources/news_remote_datasource.dart';
import 'package:eje/datasources/services_local_datasource.dart';
import 'package:eje/datasources/services_remote_datasource.dart';
import 'package:eje/repositories/bak_repository.dart';
import 'package:eje/repositories/employees_repository.dart';
import 'package:eje/repositories/impl/arbeitsbereich_repository_impl.dart';
import 'package:eje/repositories/impl/articles_repository_impl.dart';
import 'package:eje/repositories/articles_repository.dart';
import 'package:eje/repositories/impl/bak_repository_impl.dart';
import 'package:eje/repositories/impl/einstellungen_repository_impl.dart';
import 'package:eje/repositories/einstellungen_repository.dart';
import 'package:eje/repositories/field_of_work_repository.dart';
import 'package:eje/repositories/impl/camps_repository_impl.dart';
import 'package:eje/repositories/camp_repository.dart';
import 'package:eje/repositories/impl/employees_repository_impl.dart';
import 'package:eje/repositories/impl/news_repository_impl.dart';
import 'package:eje/repositories/impl/services_repository_impl.dart';
import 'package:eje/repositories/news_repository.dart';
import 'package:eje/datasources/events_local_datasource.dart';
import 'package:eje/datasources/events_remote_datasource.dart';
import 'package:eje/repositories/impl/events_repositoy_impl.dart';
import 'package:eje/repositories/events_repository.dart';
import 'package:eje/repositories/services_repository.dart';
import 'package:eje/services/ArticleService.dart';
import 'package:eje/services/BakService.dart';
import 'package:eje/services/CampSerivce.dart';
import 'package:eje/services/EmployeeService.dart';
import 'package:eje/services/EventService.dart';
import 'package:eje/services/FieldOfWorkService.dart';
import 'package:eje/services/NewsService.dart';
import 'package:eje/services/OfferedServicesService.dart';
import 'package:eje/services/SettingsService.dart';
import 'package:eje/utils/network_info.dart';
import 'package:eje/widgets/pages/fields_of_work/bloc/fields_of_work_bloc.dart';
import 'package:eje/widgets/pages/articles/bloc/articles_bloc.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_bloc.dart';
import 'package:eje/widgets/pages/settings/bloc/einstellung_bloc.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_bloc.dart';
import 'package:eje/widgets/pages/employees/bloc/employees_bloc.dart';
import 'package:eje/widgets/pages/news/bloc/news_bloc.dart';
import 'package:eje/widgets/pages/offeredServices/bloc/services_bloc.dart';
import 'package:eje/widgets/pages/events/bloc/events_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Pages

  // ! Neuigkeiten
  // * Bloc
  sl.registerFactory(
    () => NewsBloc(newsService: sl()),
  );
  // * Services
  sl.registerLazySingleton(() => NewsService(repository: sl()));
  // * Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  // * Datasources
  sl.registerLazySingleton(
    () => NewsRemoteDatasource(),
  );
  sl.registerLazySingleton(() => NewsLocalDatasource());

  // ! Einstellungen
  // * Bloc
  sl.registerFactory(() => EinstellungBloc(settingsService: sl()));
  // * Services
  sl.registerLazySingleton(() => SettingsService(repository: sl()));
  // * Repository
  sl.registerLazySingleton<EinstellungenRepository>(
      () => EinstellungenRepositoryImpl());

  // ! Hauptamtliche
  // * Bloc
  sl.registerFactory(() => EmployeesBloc(employeeService: sl()));
  // * Service
  sl.registerLazySingleton(() => EmployeeService(repository: sl()));
  // * Repository
  sl.registerLazySingleton<EmployeesRepository>(
    () => EmployeesRepositoryImpl(
      remoteDataSource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  // * Datasources
  sl.registerLazySingleton(() => EmployeesLocalDatasource());
  sl.registerLazySingleton(() => EmployeesRemoteDatasource(client: sl()));

  // ! BAK
  // * Bloc
  sl.registerFactory(() => BakBloc(bakSerivce: sl()));
  // * Services
  sl.registerLazySingleton(() => BakService(repository: sl()));
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
    () => FieldsOfWorkBloc(fieldsOfWorkService: sl()),
  );
  // * Services
  sl.registerLazySingleton(() => FieldsOfWorkService(repository: sl()));
  // * Repsoitory
  sl.registerLazySingleton<FieldOfWorkRepository>(
      () => ArbeitsbereichRepositoryImpl(
            remoteDataSource: sl(),
            localDatasource: sl(),
            networkInfo: sl(),
          ));
  // * Datasources
  sl.registerLazySingleton(() => ArbeitsbereicheLocalDatasource());
  sl.registerLazySingleton(() => ArbeitsbereichRemoteDatasource(client: sl()));

  // ! Services
  sl.registerFactory(() => ServicesBloc(offeredServicesService: sl()));
  // * Services
  sl.registerLazySingleton(() => OfferedServicesService(repository: sl()));
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
  sl.registerFactory(() => EventsBloc(eventService: sl()));
  // * Services
  sl.registerLazySingleton(() => EventService(repository: sl()));
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
  sl.registerFactory(() => CampsBloc(campService: sl()));
  // * Services
  sl.registerLazySingleton(() => CampService(repository: sl()));
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
  sl.registerFactory(() => ArticlesBloc(articleService: sl()));
  // * Services
  sl.registerLazySingleton(() => ArticleService(sl()));
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
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
