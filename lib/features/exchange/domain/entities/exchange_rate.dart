import 'package:equatable/equatable.dart';

/// Taxa de câmbio atual de uma moeda contra BRL.
class ExchangeRate extends Equatable {
  const ExchangeRate({
    required this.fromSymbol,
    required this.toSymbol,
    required this.rate,
    required this.updatedAt,
  });

  final String fromSymbol;
  final String toSymbol;
  final double rate;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [fromSymbol, toSymbol, rate, updatedAt];
}
