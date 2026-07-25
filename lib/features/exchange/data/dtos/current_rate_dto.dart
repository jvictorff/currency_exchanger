import 'package:equatable/equatable.dart';

import '../../domain/entities/exchange_rate.dart';

class CurrentRateDto extends Equatable {
  const CurrentRateDto({
    required this.exchangeRate,
    required this.fromSymbol,
    required this.toSymbol,
    required this.lastUpdatedAt,
  });

  factory CurrentRateDto.fromJson(Map<String, dynamic> json) {
    return CurrentRateDto(
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      fromSymbol: json['fromSymbol'] as String,
      toSymbol: json['toSymbol'] as String,
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );
  }

  final double exchangeRate;
  final String fromSymbol;
  final String toSymbol;
  final DateTime lastUpdatedAt;

  ExchangeRate toEntity() => ExchangeRate(
    fromSymbol: fromSymbol,
    toSymbol: toSymbol,
    rate: exchangeRate,
    updatedAt: lastUpdatedAt,
  );

  @override
  List<Object?> get props => [
    exchangeRate,
    fromSymbol,
    toSymbol,
    lastUpdatedAt,
  ];
}
