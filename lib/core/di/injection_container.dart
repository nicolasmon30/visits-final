import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/authenticate_user.dart';
import '../../features/auth/domain/usecases/check_authentication.dart';
import '../../features/auth/domain/usecases/check_first_time.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/reset_user.dart';
import '../../features/auth/domain/usecases/setup_user_profile.dart';
import '../../features/routes/data/datasources/routes_local_datasource.dart';
import '../../features/routes/data/repositories/routes_repository_impl.dart';
import '../../features/routes/domain/repositories/routes_repository.dart';
import '../../features/routes/domain/usecases/routes_usecases.dart';
import '../../features/congregations/data/datasources/congregations_local_datasource.dart';
import '../../features/congregations/data/repositories/congregations_repository_impl.dart';
import '../../features/congregations/domain/repositories/congregations_repository.dart';
import '../../features/congregations/domain/usecases/congregations_usecases.dart';
import '../../features/recommendations/data/datasources/recommendations_local_datasource.dart';
import '../../features/recommendations/data/repositories/recommendations_repository_impl.dart';
import '../../features/recommendations/domain/repositories/recommendations_repository.dart';
import '../../features/recommendations/domain/usecases/recommendations_usecases.dart';
import '../../features/assemblies/data/datasources/assemblies_local_datasource.dart';
import '../../features/assemblies/data/repositories/assemblies_repository_impl.dart';
import '../../features/assemblies/domain/repositories/assemblies_repository.dart';
import '../../features/assemblies/domain/usecases/assemblies_usecases.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Auth Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Routes Data sources
  sl.registerLazySingleton<RoutesLocalDataSource>(
    () => RoutesLocalDataSourceImpl(sl()),
  );

  // Congregations Data sources
  sl.registerLazySingleton<CongregationsLocalDataSource>(
    () => CongregationsLocalDataSourceImpl(sl()),
  );

  // Recommendations Data sources
  sl.registerLazySingleton<RecommendationsLocalDataSource>(
    () => RecommendationsLocalDataSourceImpl(sl()),
  );

  // Assemblies Data sources
  sl.registerLazySingleton<AssembliesLocalDataSource>(
    () => AssembliesLocalDataSourceImpl(sl()),
  );

  // Auth Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Routes Repositories
  sl.registerLazySingleton<RoutesRepository>(
    () => RoutesRepositoryImpl(sl()),
  );

  // Congregations Repositories
  sl.registerLazySingleton<CongregationsRepository>(
    () => CongregationsRepositoryImpl(sl()),
  );

  // Recommendations Repositories
  sl.registerLazySingleton<RecommendationsRepository>(
    () => RecommendationsRepositoryImpl(sl()),
  );

  // Assemblies Repositories
  sl.registerLazySingleton<AssembliesRepository>(
    () => AssembliesRepositoryImpl(sl()),
  );

  // Auth Use cases
  sl.registerLazySingleton(() => AuthenticateUser(sl()));
  sl.registerLazySingleton(() => CheckAuthentication(sl()));
  sl.registerLazySingleton(() => CheckFirstTime(sl()));
  sl.registerLazySingleton(() => SetupUserProfile(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => ResetUser(sl()));

  // Routes Use cases
  sl.registerLazySingleton(() => GetAllRoutes(sl()));
  sl.registerLazySingleton(() => GetRouteById(sl()));
  sl.registerLazySingleton(() => CreateRoute(sl()));
  sl.registerLazySingleton(() => UpdateRoute(sl()));
  sl.registerLazySingleton(() => DeleteRoute(sl()));
  sl.registerLazySingleton(() => GetRoutesCount(sl()));

  // Congregations Use cases
  sl.registerLazySingleton(() => GetAllCongregations(sl()));
  sl.registerLazySingleton(() => GetCongregationById(sl()));
  sl.registerLazySingleton(() => CreateCongregation(sl()));
  sl.registerLazySingleton(() => UpdateCongregation(sl()));
  sl.registerLazySingleton(() => DeleteCongregation(sl()));
  sl.registerLazySingleton(() => GetCongregationsCount(sl()));
  sl.registerLazySingleton(() => GetCongregationDetails(sl()));
  sl.registerLazySingleton(() => SaveCongregationDetails(sl()));

  // Recommendations Use cases
  sl.registerLazySingleton(() => GetRecommendationsByCongregation(sl()));
  sl.registerLazySingleton(() => GetRecommendationById(sl()));
  sl.registerLazySingleton(() => CreateRecommendation(sl()));
  sl.registerLazySingleton(() => UpdateRecommendation(sl()));
  sl.registerLazySingleton(() => DeleteRecommendation(sl()));
  sl.registerLazySingleton(() => GetRecommendationsCount(sl()));

  // Assemblies Use cases
  sl.registerLazySingleton(() => GetAllAssemblies(sl()));
  sl.registerLazySingleton(() => GetAssemblyById(sl()));
  sl.registerLazySingleton(() => CreateAssembly(sl()));
  sl.registerLazySingleton(() => UpdateAssembly(sl()));
  sl.registerLazySingleton(() => DeleteAssembly(sl()));
  sl.registerLazySingleton(() => GetAssembliesCount(sl()));
}
