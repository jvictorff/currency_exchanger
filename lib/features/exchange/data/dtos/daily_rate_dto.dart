import 'package:equatable/equatable.dart';

import '../../domain/entities/daily_rate.dart';

class DailyRateDto extends Equatable {
  const DailyRateDto({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory DailyRateDto.fromJson(Map<String, dynamic> json) {
    return DailyRateDto(
      date: DateTime.parse(json['date'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
    );
  }

  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  DailyRate toEntity() => DailyRate(
    date: date,
    open: open,
    high: high,
    low: low,
    close: close,
  );

  @override
  List<Object?> get props => [date, open, high, low, close];
}
