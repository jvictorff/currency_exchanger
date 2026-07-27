import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/current_rate_cubit.dart';
import '../cubit/history_cubit.dart';
import '../widgets/current_rate_card.dart';
import '../widgets/failure_view.dart';
import '../widgets/history_sliver.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CurrentRateCubit>()),
        BlocProvider(create: (_) => sl<HistoryCubit>()),
      ],
      child: const ExchangeView(),
    );
  }
}

class ExchangeView extends StatefulWidget {
  const ExchangeView({super.key});

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final currency = _controller.text.trim().toUpperCase();
    if (currency.length != 3) return;
    FocusScope.of(context).unfocus();
    context.read<CurrentRateCubit>().load(currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _Header(),
                              const SizedBox(height: 24),
                              _CurrencyField(
                                controller: _controller,
                                onSubmitted: (_) => _search(),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _search,
                                child: const Text('EXCHANGE RESULT'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: _CurrentRateSection(),
                        ),
                      ),
                      const _HistorySliverArea(),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                ),
              ),
            ),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 48,
          semanticLabel: 'Action Labs',
        ),
        const Divider(height: 32),
        Text(
          'BRL EXCHANGE RATE',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _CurrencyField extends StatelessWidget {
  const _CurrencyField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      maxLength: 3,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
        _UpperCaseFormatter(),
      ],
      decoration: const InputDecoration(
        labelText: 'Enter the currency code',
        filled: true,
        counterText: '',
      ),
    );
  }
}

class _CurrentRateSection extends StatelessWidget {
  const _CurrentRateSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentRateCubit, CurrentRateState>(
      builder: (context, state) => switch (state) {
        CurrentRateInitial() => const SizedBox.shrink(),
        CurrentRateLoading() => const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
        CurrentRateError(:final failure) => FailureView(failure: failure),
        CurrentRateLoaded(:final rate) => CurrentRateCard(rate: rate),
      },
    );
  }
}
class _HistorySliverArea extends StatelessWidget {
  const _HistorySliverArea();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentRateCubit, CurrentRateState>(
      builder: (context, state) => state is CurrentRateLoaded
          // key por moeda: ao trocar de moeda, a seção nasce recolhida de novo.
          ? HistorySliver(
              key: ValueKey(state.rate.fromSymbol),
              currency: state.rate.fromSymbol,
            )
          : const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: const Text(
        'Copyright · Action Labs',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
