import '../entities/daily_rate.dart';
import '../entities/daily_rate_with_diff.dart';

/// Calcula o `close diff` de cada dia: a diferença entre o fechamento do dia e
/// o do dia anterior.
///
/// Regras:
/// - ordena por data (ascendente) antes de calcular — não confia na ordem da API;
/// - o dia mais antigo fica com `closeDiff == null` (não há anterior);
/// - a lista de entrada NÃO é modificada (trabalha sobre uma cópia);
/// - devolve do mais recente para o mais antigo (ordem de exibição).
List<DailyRateWithDiff> computeCloseDiffs(List<DailyRate> rates) {
  if (rates.isEmpty) return const [];

  final ascending = [...rates]..sort((a, b) => a.date.compareTo(b.date));

  final withDiff = <DailyRateWithDiff>[];
  for (var i = 0; i < ascending.length; i++) {
    final closeDiff = i == 0
        ? null
        : ascending[i].close - ascending[i - 1].close;
    withDiff.add(DailyRateWithDiff(rate: ascending[i], closeDiff: closeDiff));
  }

  return withDiff.reversed.toList();
}
