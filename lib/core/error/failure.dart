import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable implements Exception {
  const Failure([this.detail]);

  final String? detail;

  @override
  List<Object?> get props => [detail];
}

/// Falha de rede.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.detail]);
}

/// Limite de chamadas excedido.
final class RateLimitFailure extends Failure {
  const RateLimitFailure([super.detail]);
}

/// Código de moeda inexistente.
final class CurrencyNotFoundFailure extends Failure {
  const CurrencyNotFoundFailure([super.detail]);
}

/// Erro do servidor.
final class ServerFailure extends Failure {
  const ServerFailure([super.detail]);
}

/// Erro desconhecido.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.detail]);
}
