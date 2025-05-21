import 'package:eje/app_config.dart';
import 'package:eje/datasources/local_data_source.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/datasources/articles_remote_datasource.dart';
import 'package:eje/datasources/bak_remote_datasource.dart';
import 'package:eje/datasources/camps_remote_datasource.dart';
import 'package:eje/datasources/employees_remote_datasource.dart';
import 'package:eje/datasources/news_remote_datasource.dart';
import 'package:eje/datasources/services_remote_datasource.dart';
import 'package:eje/models/article.dart';
import 'package:eje/models/bakler.dart';
import 'package:eje/models/event.dart';
import 'package:eje/models/offered_service.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/models/news.dart';
import 'package:eje/repositories/cached_remote_repository.dart';
import 'package:eje/repositories/cached_remote_single_element_repository.dart';
import 'package:eje/repositories/shared_preferences_repository.dart';
import 'package:eje/datasources/events_remote_datasource.dart';
import 'package:eje/services/news_service.dart';
import 'package:eje/services/offered_services_service.dart';
import 'package:eje/services/readonly_service.dart';
import 'package:eje/services/readonly_single_element_service.dart';
import 'package:eje/services/shared_preferences_service.dart';
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

final diContainer = GetIt.instance;

Future<void> init() async {
  final AppConfig appConfig = await AppConfig.loadConfig();

  // ! Neuigkeiten
  // * Bloc
  diContainer.registerFactory(
    () => NewsBloc(newsService: diContainer()),
  );
  // * Services
  diContainer.registerLazySingleton(() =>
      NewsService(repository: diContainer(), articleRepository: diContainer()));
  // * Repository
  diContainer.registerLazySingleton(() => CachedRemoteRepository<News, String>(
      remoteDatasource: diContainer(),
      localDatasource: diContainer(),
      networkInfo: diContainer(),
      reverse: true,
      sortStrategy: (a, b) => a.published.compareTo(b.published)));
  // * Datasources
  diContainer.registerLazySingleton<RemoteDataSource<News, String>>(
      () => NewsRemoteDatasource(client: diContainer()));
  diContainer.registerLazySingleton(() =>
      LocalDataSource<News, String>(idKey: "title", boxKey: appConfig.newsBox));

  // ! Einstellungen
  // * Bloc
  diContainer
      .registerFactory(() => EinstellungBloc(settingsService: diContainer()));
  // * Services
  diContainer
      .registerLazySingleton(() => SettingsService(repository: diContainer()));
  // * Repository
  diContainer.registerLazySingleton(() => SharedPreferencesRepository());

  // ! Hauptamtliche
  // * Bloc
  diContainer
      .registerFactory(() => EmployeesBloc(employeeService: diContainer()));
  // * Service
  diContainer.registerLazySingleton(
      () => ReadOnlyCachedService<Employee, String>(repository: diContainer()));
  // * Repository
  diContainer
      .registerLazySingleton(() => CachedRemoteRepository<Employee, String>(
            remoteDatasource: diContainer(),
            localDatasource: diContainer(),
            networkInfo: diContainer(),
          ));
  // * Datasources
  diContainer.registerLazySingleton(() => LocalDataSource<Employee, String>(
      idKey: 'name', boxKey: appConfig.employeesBox));
  diContainer.registerLazySingleton<RemoteDataSource<Employee, String>>(
      () => EmployeesRemoteDatasource(client: diContainer()));

  // ! BAK
  // * Bloc
  diContainer.registerFactory(() => BakBloc(bakSerivce: diContainer()));
  // * Services
  diContainer.registerLazySingleton(
      () => ReadOnlyCachedService<BAKler, String>(repository: diContainer()));
  // * Repository
  diContainer
      .registerLazySingleton(() => CachedRemoteRepository<BAKler, String>(
            remoteDatasource: diContainer(),
            localDatasource: diContainer(),
            networkInfo: diContainer(),
          ));
  // * Datasources
  diContainer.registerLazySingleton(() =>
      LocalDataSource<BAKler, String>(idKey: "name", boxKey: appConfig.bakBox));
  diContainer.registerLazySingleton<RemoteDataSource<BAKler, String>>(
      () => BAKRemoteDatasource(client: diContainer()));

  // ! Arbeitsbereiche
  // * Bloc
  diContainer.registerFactory(
    () => FieldsOfWorkBloc(fieldsOfWorkService: diContainer()),
  );
  // * Services
  diContainer.registerLazySingleton(() =>
      ReadOnlyCachedService<FieldOfWork, String>(repository: diContainer()));
  // * Repsoitory
  diContainer
      .registerLazySingleton(() => CachedRemoteRepository<FieldOfWork, String>(
            remoteDatasource: diContainer(),
            localDatasource: diContainer(),
            networkInfo: diContainer(),
          ));
  // * Datasources
  diContainer.registerLazySingleton(() => LocalDataSource<FieldOfWork, String>(
      idKey: "link", boxKey: appConfig.fieldOfWorkBox));
  diContainer.registerLazySingleton<RemoteDataSource<FieldOfWork, String>>(
      () => ArbeitsbereichRemoteDatasource(client: diContainer()));

  // ! Services
  diContainer.registerFactory(
      () => ServicesBloc(offeredServicesService: diContainer()));
  // * Services
  diContainer.registerLazySingleton(
      () => OfferedServicesService(repository: diContainer()));
  // * Repository
  diContainer.registerLazySingleton(
      () => CachedRemoteRepository<OfferedService, String>(
            remoteDatasource: diContainer(),
            localDatasource: diContainer(),
            networkInfo: diContainer(),
          ));
  // * Datrasources
  diContainer.registerLazySingleton(() =>
      LocalDataSource<OfferedService, String>(
          idKey: "service", boxKey: appConfig.servicesBox));
  diContainer.registerLazySingleton<RemoteDataSource<OfferedService, String>>(
      () => ServicesRemoteDatasource(
          cache: diContainer(),
          articleDataSource: diContainer(),
          client: diContainer()));

  // ! Termine
  // * Bloc
  diContainer.registerFactory(() => EventsBloc(eventService: diContainer()));
  // * Services
  diContainer.registerLazySingleton(
      () => ReadOnlyCachedService<Event, int>(repository: diContainer()));
  // * Repository
  diContainer.registerLazySingleton(() => CachedRemoteRepository<Event, int>(
        remoteDatasource: diContainer(),
        localDatasource: diContainer(),
        networkInfo: diContainer(),
        reverse: true,
        sortStrategy: (a, b) => a.startDate.compareTo(b.startDate),
      ));
  // * Datasources
  diContainer.registerLazySingleton(() =>
      LocalDataSource<Event, int>(boxKey: appConfig.eventsBox, idKey: 'id'));
  diContainer.registerLazySingleton<RemoteDataSource<Event, int>>(
      () => TermineRemoteDatasource(client: diContainer()));

  // ! Freizeiten
  diContainer.registerFactory(() => CampsBloc(campService: diContainer()));
  // * Services
  diContainer.registerLazySingleton(
      () => ReadOnlyCachedService<Camp, int>(repository: diContainer()));
  // * Repository
  diContainer.registerLazySingleton(() => CachedRemoteRepository<Camp, int>(
        remoteDatasource: diContainer(),
        localDatasource: diContainer(),
        networkInfo: diContainer(),
        sortStrategy: (a, b) => a.startDate.compareTo(b.startDate),
      ));
  // * Datasources
  diContainer.registerLazySingleton(() =>
      LocalDataSource<Camp, int>(idKey: "id", boxKey: appConfig.campsBox));
  diContainer.registerLazySingleton<RemoteDataSource<Camp, int>>(
      () => CampsRemoteDatasource(client: diContainer()));

  // ! Articles
  diContainer
      .registerFactory(() => ArticlesBloc(articleService: diContainer()));
  // * Services
  diContainer.registerLazySingleton(() =>
      ReadOnlySingleElementService<Article, String>(repository: diContainer()));
  // * Repository
  diContainer.registerLazySingleton(
      () => CachedRemoteSingleElementRepository<Article, String>(
            localDatasource: diContainer(),
            networkInfo: diContainer(),
            remoteDatasource: diContainer(),
          ));
  // * Datasources
  diContainer.registerLazySingleton<RemoteDataSource<Article, String>>(
      () => ArticlesRemoteDatasource(client: diContainer()));
  diContainer.registerLazySingleton(() => LocalDataSource<Article, String>(
      idKey: "url", boxKey: appConfig.articlesBox));

  // ! Core
  // * NetworkInfo
  diContainer.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(diContainer(), diContainer()));

  // ! External
  // * Remote Access
  diContainer.registerLazySingleton(() => Connectivity());
  diContainer.registerLazySingleton(() => http.Client());
  diContainer.registerLazySingleton(() => InternetConnectionChecker.instance);
}
