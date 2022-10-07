import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/articles/data/datasources/articles_local_datasource.dart';
import 'package:eje/pages/articles/data/repository/articles_repository_impl.dart';
import 'package:eje/pages/articles/domain/repositories/articles_repository.dart';
import 'package:eje/pages/articles/domain/usecases/get_article.dart';
import 'package:eje/pages/articles/domain/usecases/get_articles.dart';
import 'package:eje/pages/articles/presentation/bloc/articles_bloc.dart';
import 'package:eje/pages/einstellungen/data/repositories/einstellungen_repository_impl.dart';
import 'package:eje/pages/einstellungen/domain/repositories/einstellungen_repository.dart';
import 'package:eje/pages/einstellungen/domain/usecases/get_preference.dart';
import 'package:eje/pages/einstellungen/domain/usecases/get_preferences.dart';
import 'package:eje/pages/einstellungen/domain/usecases/set_prefrences.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_local_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/repositories/arbeitsbereich_repository_impl.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/field_of_work_repository.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/get_field_of_work.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/usecases/get_fields_of_work.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/fields_of_work_bloc.dart';
import 'package:eje/pages/eje/bak/data/datasources/bak_local_datasource.dart';
import 'package:eje/pages/eje/bak/data/datasources/bak_remote_datasource.dart';
import 'package:eje/pages/eje/bak/data/repositories/bak_repository_impl.dart';
import 'package:eje/pages/eje/bak/domain/repositories/bak_repository.dart';
import 'package:eje/pages/eje/bak/domain/usecases/get_bak.dart';
import 'package:eje/pages/eje/bak/domain/usecases/get_bakler.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/employees_local_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/employees_remote_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/repositories/employees_repository_impl.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/employees_repository.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/get_employees.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/get_employee.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:eje/pages/eje/services/data/datasources/services_local_datasource.dart';
import 'package:eje/pages/eje/services/data/datasources/services_remote_datasource.dart';
import 'package:eje/pages/eje/services/data/repositories/services_repository_impl.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';
import 'package:eje/pages/eje/services/domain/usecases/get_service.dart';
import 'package:eje/pages/eje/services/domain/usecases/get_services.dart';
import 'package:eje/pages/eje/services/presentation/bloc/services_bloc.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_local_datasource.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_remote_datasource.dart';
import 'package:eje/pages/freizeiten/data/repositories/camps_repository_impl.dart';
import 'package:eje/pages/freizeiten/domain/repositories/camp_repository.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camp.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camps.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/news_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/news_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/repositories/news_repository_impl.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/news_repository.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/get_single_news.dart';
import 'package:eje/pages/neuigkeiten/domain/usecases/get_news.dart';
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
    () => NewsBloc(
      getSingleNews: sl(),
      getNews: sl(),
    ),
  );
  // * Use cases
  sl.registerLazySingleton(() => GetSingleNews(sl()));
  sl.registerLazySingleton(() => GetNews(sl()));
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
    () => EmployeesBloc(
      getEmployees: sl(),
      getEmployee: sl(),
    ),
  );
  // * Use cases
  sl.registerLazySingleton(() => GetEmployees(repository: sl()));
  sl.registerLazySingleton(() => GetEmployee(sl()));
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
    () => FieldsOfWorkBloc(
      getFieldOfWork: sl(),
      getFieldsOfWork: sl(),
    ),
  );
  // * Usecases
  sl.registerLazySingleton(() => GetFieldOfWork(sl()));
  sl.registerLazySingleton(() => GetFieldsOfWork(repository: sl()));
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
