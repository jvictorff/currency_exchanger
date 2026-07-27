import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/exchange/data/datasources/exchange_remote_data_source.dart';
import '../../features/exchange/data/repositories/exchange_repository.dart';
import '../../features/exchange/presentation/cubit/current_rate_cubit.dart';
import '../../features/exchange/presentation/cubit/history_cubit.dart';
import '../network/dio_client.dart';

/// Service locator global
final GetIt sl = GetIt.instance;

void setupDependencies() {
  // --- Dio ---
  sl.registerLazySingleton<Dio>(buildDioClient);

  // --- Data ---
  sl.registerLazySingleton<ExchangeRemoteDataSource>(
    () => ExchangeRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<ExchangeRepository>(
    () => ExchangeRepository(sl<ExchangeRemoteDataSource>()),
  );

  // --- Presentation ---
  sl.registerFactory<CurrentRateCubit>(
    () => CurrentRateCubit(sl<ExchangeRepository>()),
  );
  sl.registerFactory<HistoryCubit>(() => HistoryCubit(sl<ExchangeRepository>()));
}
