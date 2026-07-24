//Centraliza toda a configuração da API BRL Exchange num único lugar.
abstract final class ApiConfig {
  static const String baseUrl =
      'https://api-brl-exchange.actionlabs.com.br/api/1.0';

  // build `--dart-define=API_KEY=...`.
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'RVZG0GHEV2KORLNA',
  );

  static const String baseCurrency = 'BRL';

  static const String currentRatePath = '/open/currentExchangeRate';
  static const String dailyRatePath = '/open/dailyExchangeRate';
}
