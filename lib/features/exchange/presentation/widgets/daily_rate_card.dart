import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/daily_rate_with_diff.dart';

/// Card de um dia do histórico
class DailyRateCard extends StatelessWidget {
  const DailyRateCard({required this.item, super.key});

  final DailyRateWithDiff item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rate = item.rate;

    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDate(rate.date),
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'OPEN',
                    value: formatBrlPrecise(rate.open),
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'HIGH',
                    value: formatBrlPrecise(rate.high),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'CLOSE',
                    value: formatBrlPrecise(rate.close),
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'LOW',
                    value: formatBrlPrecise(rate.low),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CloseDiff(percent: item.closeDiffPercent),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CloseDiff extends StatelessWidget {
  const _CloseDiff({required this.percent});

  final double? percent;

  @override
  Widget build(BuildContext context) {
    const label = Text(
      'CLOSE DIFF (%): ',
      style: TextStyle(color: Colors.black54, fontSize: 12),
    );

    if (percent == null) {
      return const Row(children: [label, Text('—')]);
    }

    final isPositive = percent! >= 0;
    final color = isPositive ? AppColors.positive : AppColors.negative;
    final icon = isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return Row(
      children: [
        label,
        Text(
          formatCloseDiffPercent(percent!),
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Icon(icon, color: color, size: 20),
      ],
    );
  }
}
