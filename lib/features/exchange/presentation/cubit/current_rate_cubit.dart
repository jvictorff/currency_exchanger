import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../data/repositories/exchange_repository.dart';
import '../../domain/entities/exchange_rate.dart';

/// Estados da taxa atual
sealed class CurrentRateState extends Equatable {
  const CurrentRateState();

  @override
  List<Object?> get props => [];
}

final class CurrentRateInitial extends CurrentRateState {
  const CurrentRateInitial();
}

final class CurrentRateLoading extends CurrentRateState {
  const CurrentRateLoading();
}

final class CurrentRateLoaded extends CurrentRateState {
  const CurrentRateLoaded(this.rate);

  final ExchangeRate rate;

  @override
  List<Object?> get props => [rate];
}

final class CurrentRateError extends CurrentRateState {
  const CurrentRateError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class CurrentRateCubit extends Cubit<CurrentRateState> {
  CurrentRateCubit(this._repository) : super(const CurrentRateInitial());

  final ExchangeRepository _repository;

  Future<void> load(String currency) async {
    emit(const CurrentRateLoading());
    try {
      final rate = await _repository.getCurrentRate(currency);
      emit(CurrentRateLoaded(rate));
    } on Failure catch (failure) {
      emit(CurrentRateError(failure));
    }
  }
}
