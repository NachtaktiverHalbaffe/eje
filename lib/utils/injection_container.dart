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
import 'package:eje/services/get_Event.dart';
import 'package:eje/services/get_Events.dart';
import 'package:eje/services/get_article.dart';
import 'package:eje/services/get_articles.dart';
import 'package:eje/services/get_bak.dart';
import 'package:eje/services/get_bakler.dart';
import 'package:eje/services/get_camp.dart';
import 'package:eje/services/get_camps.dart';
import 'package:eje/services/get_employee.dart';
import 'package:eje/services/get_employees.dart';
import 'package:eje/services/get_field_of_work.dart';
import 'package:eje/services/get_fields_of_work.dart';
import 'package:eje/services/get_news.dart';
import 'package:eje/services/get_preference.dart';
import 'package:eje/services/get_preferences.dart';
import 'package:eje/services/get_service.dart';
import 'package:eje/services/get_services.dart';
import 'package:eje/services/get_single_news.dart';
import 'package:eje/services/set_prefrences.dart';
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
  sl.registerFactory(() => EventsBloc(getEvents: sl(), getEvent: sl()));
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
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
