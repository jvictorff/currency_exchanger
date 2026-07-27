import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../data/repositories/exchange_repository.dart';
import '../../domain/entities/daily_rate_with_diff.dart';
import '../../domain/logic/close_diff.dart';

/// Estados do histórico de 30 dias
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

final class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.days);

  final List<DailyRateWithDiff> days;

  @override
  List<Object?> get props => [days];
}

final class HistoryError extends HistoryState {
  const HistoryError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryInitial());

  final ExchangeRepository _repository;

  Future<void> load(String currency) async {
    emit(const HistoryLoading());
    try {
      final rates = await _repository.getDailyRates(currency);
      emit(HistoryLoaded(computeCloseDiffs(rates)));
    } on Failure catch (failure) {
      emit(HistoryError(failure));
    }
  }
}
