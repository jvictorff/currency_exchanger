import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/exchange/presentation/pages/exchange_page.dart';

void main() {
  setupDependencies();
  runApp(const CurrencyExchangerApp());
}

class CurrencyExchangerApp extends StatelessWidget {
  const CurrencyExchangerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BRL Exchange Rate',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const ExchangePage(),
    );
  }
}
