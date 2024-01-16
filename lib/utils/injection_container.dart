import 'dart:ffi';

import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/datasources/bak_remote_datasource.dart';
import 'package:eje/datasources/camps_remote_datasource.dart';
import 'package:eje/datasources/employees_remote_datasource.dart';
import 'package:eje/datasources/news_remote_datasource.dart';
import 'package:eje/datasources/services_remote_datasource.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/models/news.dart';
import 'package:eje/repositories/bak_repository.dart';
import 'package:eje/repositories/employees_repository.dart';
import 'package:eje/repositories/articles_repository.dart';
import 'package:eje/repositories/einstellungen_repository.dart';
import 'package:eje/repositories/field_of_work_repository.dart';
import 'package:eje/repositories/camp_repository.dart';
import 'package:eje/repositories/news_repository.dart';
import 'package:eje/datasources/events_remote_datasource.dart';
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
  sl.registerLazySingleton(
    () => NewsRepository(
        remoteDataSource: sl(), localDatasource: sl(), networkInfo: sl()),
  );
  // * Datasources
  sl.registerLazySingleton(
    () => NewsRemoteDatasource(),
  );
  sl.registerLazySingleton(() => LocalDataSource<News, String>());

  // ! Einstellungen
  // * Bloc
  sl.registerFactory(() => EinstellungBloc(settingsService: sl()));
  // * Services
  sl.registerLazySingleton(() => SettingsService(repository: sl()));
  // * Repository
  sl.registerLazySingleton(() => SettingsRepository());

  // ! Hauptamtliche
  // * Bloc
  sl.registerFactory(() => EmployeesBloc(employeeService: sl()));
  // * Service
  sl.registerLazySingleton(() => EmployeeService(repository: sl()));
  // * Repository
  sl.registerLazySingleton(
    () => EmployeesRepository(
        remoteDataSource: sl(), localDatasource: sl(), networkInfo: sl()),
  );
  // * Datasources
  sl.registerLazySingleton(() => LocalDataSource<Employee, String>());
  sl.registerLazySingleton(() => EmployeesRemoteDatasource(client: sl()));

  // ! BAK
  // * Bloc
  sl.registerFactory(() => BakBloc(bakSerivce: sl()));
  // * Services
  sl.registerLazySingleton(() => BakService(repository: sl()));
  // * Repository
  sl.registerLazySingleton(() => BAKRepository(
      remoteDataSource: sl(), localDatasource: sl(), networkInfo: sl()));
  // * Datasources
  sl.registerLazySingleton(() => LocalDataSource<BAKler, String>());
  sl.registerLazySingleton(() => BAKRemoteDatasource(client: sl()));

  // ! Arbeitsbereiche
  // * Bloc
  sl.registerFactory(
    () => FieldsOfWorkBloc(fieldsOfWorkService: sl()),
  );
  // * Services
  sl.registerLazySingleton(() => FieldsOfWorkService(repository: sl()));
  // * Repsoitory
  sl.registerLazySingleton(() => FieldOfWorkRepository(
      remoteDataSource: sl(), localDatasource: sl(), networkInfo: sl()));
  // * Datasources
  sl.registerLazySingleton(() => LocalDataSource<FieldOfWork, String>());
  sl.registerLazySingleton(() => ArbeitsbereichRemoteDatasource(client: sl()));

  // ! Services
  sl.registerFactory(() => ServicesBloc(offeredServicesService: sl()));
  // * Services
  sl.registerLazySingleton(() => OfferedServicesService(repository: sl()));
  // * Repository
  sl.registerLazySingleton(() => ServicesRepository(
      remoteDataSource: sl(), localDatasource: sl(), networkInfo: sl()));
  // * Datrasources
  sl.registerLazySingleton(() => LocalDataSource<OfferedService, String>());
  sl.registerLazySingleton(() => ServicesRemoteDatasource(client: sl()));

  // ! Termine
  // * Bloc
  sl.registerFactory(() => EventsBloc(eventService: sl()));
  // * Services
  sl.registerLazySingleton(() => EventService(repository: sl()));
  // * Repository
  sl.registerLazySingleton(() => EventsRepository(
      remoteDataSource: sl(), localDatasource: sl(), networkInfo: sl()));
  // * Datasources
  sl.registerLazySingleton(() => LocalDataSource<Event, int>());
  sl.registerLazySingleton(() => TermineRemoteDatasource(client: sl()));

  // ! Freizeiten
  sl.registerFactory(() => CampsBloc(campService: sl()));
  // * Services
  sl.registerLazySingleton(() => CampService(repository: sl()));
  // * Repository
  sl.registerLazySingleton(() => CampRepository(
      remoteDataSource: sl(), localDatasource: sl(), networkInfo: sl()));
  // * Datasources
  sl.registerLazySingleton(() => LocalDataSource<Camp, int>());
  sl.registerLazySingleton(() => CampsRemoteDatasource());

  // ! Articles
  sl.registerFactory(() => ArticlesBloc(articleService: sl()));
  // * Services
  sl.registerLazySingleton(() => ArticleService(sl()));
  // * Repository
  sl.registerLazySingleton(
      () => ArticlesRepository(localDatasource: sl(), networkInfo: sl()));
  // * Datasources
  sl.registerLazySingleton(() => LocalDataSource<Article, String>());

  // ! Core
  // * NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl(), sl()));

  // ! External
  // * Remote Access
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
