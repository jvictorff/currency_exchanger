import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/history_cubit.dart';
import 'daily_rate_card.dart';
import 'failure_view.dart';

/// Seção "LAST 30 DAYS" 
class HistorySliver extends StatefulWidget {
  const HistorySliver({required this.currency, super.key});

  final String currency;

  @override
  State<HistorySliver> createState() => _HistorySliverState();
}

class _HistorySliverState extends State<HistorySliver> {
  bool _expanded = false;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded && context.read<HistoryCubit>().state is HistoryInitial) {
      context.read<HistoryCubit>().load(widget.currency);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LAST 30 DAYS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggle,
                      color: AppColors.primary,
                      icon: Icon(_expanded ? Icons.remove : Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_expanded) const _HistoryListSliver(),
      ],
    );
  }
}

class _HistoryListSliver extends StatelessWidget {
  const _HistoryListSliver();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) => switch (state) {
        HistoryInitial() => const SliverToBoxAdapter(child: SizedBox.shrink()),
        HistoryLoading() => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        HistoryError(:final failure) => SliverToBoxAdapter(
          child: FailureView(failure: failure),
        ),
        HistoryLoaded(:final days) => SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.builder(
            itemCount: days.length,
            itemBuilder: (context, index) => DailyRateCard(item: days[index]),
          ),
        ),
      },
    );
  }
}
