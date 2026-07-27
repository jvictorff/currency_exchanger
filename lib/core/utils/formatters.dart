import 'package:intl/intl.dart';

// Formatadores
final NumberFormat _brl2 = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 2,
);
final NumberFormat _brl4 = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 4,
);
final DateFormat _dateTime = DateFormat("dd/MM/yyyy - HH'h'mm");
final DateFormat _date = DateFormat('dd/MM/yyyy');

/// `R$ 5,08` — usado na taxa principal.
String formatBrl(double value) => _brl2.format(value);

/// `R$ 5,0666` — mais casas, usado nos valores OHLC do histórico.
String formatBrlPrecise(double value) => _brl4.format(value);

/// `23/07/2026 - 03h00`.
String formatDateTime(DateTime value) => _dateTime.format(value);

/// `23/07/2026`.
String formatDate(DateTime value) => _date.format(value);

/// `+2,00%` / `-1,15%` (com sinal explícito).
String formatCloseDiffPercent(double percent) {
  final sign = percent > 0 ? '+' : '';
  final value = percent.toStringAsFixed(2).replaceAll('.', ',');
  return '$sign$value%';
}
