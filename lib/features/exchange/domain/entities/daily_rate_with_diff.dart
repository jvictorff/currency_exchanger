import 'package:equatable/equatable.dart';

import 'daily_rate.dart';

/// Um dia do histórico já acompanhado da diferença de fechamento para o dia anterior

class DailyRateWithDiff extends Equatable {
  const DailyRateWithDiff({required this.rate, this.closeDiff});

  final DailyRate rate;
  final double? closeDiff;

  @override
  List<Object?> get props => [rate, closeDiff];
}
