import 'package:equatable/equatable.dart';

/// Cotação de um único dia de uma moeda contra BRL
class DailyRate extends Equatable {
  const DailyRate({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  @override
  List<Object?> get props => [date, open, high, low, close];
}
