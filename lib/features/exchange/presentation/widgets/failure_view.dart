import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';

class FailureView extends StatelessWidget {
  const FailureView({required this.failure, super.key});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    final message = switch (failure) {
      NetworkFailure() => 'Sem conexão. Verifique sua internet.',
      RateLimitFailure() =>
        'Muitas consultas em pouco tempo. Aguarde um instante.',
      CurrencyNotFoundFailure() =>
        'Moeda não encontrada. Confira o código (ex: USD, EUR).',
      ServerFailure() => 'Servidor indisponível. Tente novamente.',
      UnknownFailure() => 'Algo deu errado. Tente novamente.',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
