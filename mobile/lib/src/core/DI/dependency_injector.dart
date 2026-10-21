import 'package:musicbox/src/app/features/artist/presentation/bloc/artist_bloc.dart';
import 'package:musicbox/src/app/features/catalog/data/repositories/catalog_repository_mock.dart';
import 'package:musicbox/src/app/features/catalog/domain/repositories/catalog_repository_interface.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/get_artist_catalog_usecase.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/get_release_usecase.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/list_releases_usecase.dart';
import 'package:musicbox/src/app/features/catalog/domain/usecases/search_artists_usecase.dart';
import 'package:musicbox/src/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:musicbox/src/app/features/library/data/repositories/library_repository_mock.dart';
import 'package:musicbox/src/app/features/library/domain/repositories/library_repository_interface.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/delete_user_release_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/get_user_release_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/list_user_releases_usecase.dart';
import 'package:musicbox/src/app/features/library/domain/usecases/save_user_release_usecase.dart';
import 'package:musicbox/src/app/features/library/presentation/bloc/library_bloc.dart';
import 'package:musicbox/src/app/features/log/presentation/bloc/log_bloc.dart';
import 'package:musicbox/src/app/features/release/presentation/bloc/release_bloc.dart';
import 'package:musicbox/src/app/features/search/presentation/bloc/search_bloc.dart';
import 'package:musicbox/src/app/features/auth/domain/usecases/register_usecase.dart';
import 'package:musicbox/src/app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:musicbox/src/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:musicbox/src/app/features/auth/data/repositories/auth_repository_mock.dart';
import 'package:musicbox/src/app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:musicbox/src/app/features/auth/domain/usecases/login_usecase.dart';
import 'package:musicbox/src/app/features/auth/infrastructure/auth_interceptor.dart';
import 'package:musicbox/src/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:musicbox/src/core/cache/shared_preferences/shared_preferences_impl.dart';
import 'package:musicbox/src/core/client_http/dio/rest_client_dio_impl.dart';
import 'package:musicbox/src/core/client_http/logger/client_interceptor_logger_impl.dart';
import 'package:musicbox/src/core/services/session_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final injector = GetIt.instance;

void setupDependencyInjector({bool loggerApi = false, bool useMocks = true, Logger? logger}) {
  injector.registerLazySingleton<Logger>(() => logger ?? Logger());

  injector.registerFactory<RestClientDioImpl>(() {
    final instance = RestClientDioImpl(
      dio: DioFactory.dio(),
    );

    instance.addInterceptors(AuthInterceptor(
      sessionService: injector<SessionService>(),
    ));

    if (loggerApi) {
      instance.addInterceptors(ClientInterceptorLoggerImpl(logger: injector<Logger>()));
    }

    return instance;
  });

  injector.registerLazySingleton<SessionService>(() {
    return SessionService(
      sharedPreferencesImpl: SharedPreferencesImpl(),
    );
  });

  injector.registerLazySingleton<AuthRemoteDatasource>(() {
    return AuthRemoteDatasource(
      restClient: injector<RestClientDioImpl>(),
    );
  });

  if (useMocks) {
    injector.registerLazySingleton<IAuthRepository>(() => AuthRepositoryMock());
  } else {
    injector.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(authRemoteDatasource: injector<AuthRemoteDatasource>()));
  }

  injector.registerLazySingleton(() => AuthBloc(
        loginUsecase: LoginUsecase(
          authRepository: injector<IAuthRepository>(),
          sessionService: injector<SessionService>(),
        ),
        registerUsecase: RegisterUsecase(
          authRepository: injector<IAuthRepository>(),
          sessionService: injector<SessionService>(),
        ),
      ));

  _setupCatalogAndLibrary();
}

/// Catálogo e biblioteca ainda só têm repositórios de mentira: o backend está
/// pronto, mas as implementações `*RepositoryImpl` (datasource + models) ainda
/// não existem. Quando existirem, o `useMocks` de [setupDependencyInjector]
/// passa a escolher entre as duas, como já faz com `IAuthRepository`.
void _setupCatalogAndLibrary() {
  // Repositórios (singletons: o mock da biblioteca guarda os registros em memória).
  injector.registerLazySingleton<ICatalogRepository>(() => CatalogRepositoryMock());
  injector.registerLazySingleton<ILibraryRepository>(
    () => LibraryRepositoryMock(catalogRepository: injector<ICatalogRepository>()),
  );

  // Usecases do catálogo.
  injector.registerFactory(() => SearchArtistsUsecase(catalogRepository: injector<ICatalogRepository>()));
  injector.registerFactory(() => GetArtistCatalogUsecase(catalogRepository: injector<ICatalogRepository>()));
  injector.registerFactory(() => GetReleaseUsecase(catalogRepository: injector<ICatalogRepository>()));
  injector.registerFactory(() => ListReleasesUsecase(catalogRepository: injector<ICatalogRepository>()));

  // Usecases da biblioteca.
  injector.registerFactory(() => ListUserReleasesUsecase(libraryRepository: injector<ILibraryRepository>()));
  injector.registerFactory(() => GetUserReleaseUsecase(libraryRepository: injector<ILibraryRepository>()));
  injector.registerFactory(() => SaveUserReleaseUsecase(libraryRepository: injector<ILibraryRepository>()));
  injector.registerFactory(() => DeleteUserReleaseUsecase(libraryRepository: injector<ILibraryRepository>()));

  // Blocs por tela: factories, cada página recebe a sua instância.
  injector.registerFactory(() => HomeBloc(
        listReleasesUsecase: injector<ListReleasesUsecase>(),
        listUserReleasesUsecase: injector<ListUserReleasesUsecase>(),
      ));
  injector.registerFactory(() => SearchBloc(searchArtistsUsecase: injector<SearchArtistsUsecase>()));
  injector.registerFactory(() => ArtistBloc(
        getArtistCatalogUsecase: injector<GetArtistCatalogUsecase>(),
        listUserReleasesUsecase: injector<ListUserReleasesUsecase>(),
      ));
  injector.registerFactory(() => ReleaseBloc(
        getReleaseUsecase: injector<GetReleaseUsecase>(),
        getUserReleaseUsecase: injector<GetUserReleaseUsecase>(),
        deleteUserReleaseUsecase: injector<DeleteUserReleaseUsecase>(),
      ));
  injector.registerFactory(() => LogBloc(
        getReleaseUsecase: injector<GetReleaseUsecase>(),
        getUserReleaseUsecase: injector<GetUserReleaseUsecase>(),
        saveUserReleaseUsecase: injector<SaveUserReleaseUsecase>(),
      ));
  injector.registerFactory(() => LibraryBloc(listUserReleasesUsecase: injector<ListUserReleasesUsecase>()));
}
