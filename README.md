# BRL Exchange Rate

App Flutter de câmbio do Real (BRL) contra outras moedas: taxa atual + histórico
dos últimos 30 dias com a variação de fechamento (*close diff*).

## Demo & download

- 🌐 **Web:** https://jvictorff.github.io/currency_exchanger/ - roda no navegador. Deploy automático no **GitHub Pages** com o GitHub Actions.
- 📱 **APK Android:** nos [Releases](https://github.com/jvictorff/currency_exchanger/releases) - instalação via *sideload*.

## Como rodar

Pré-requisito: **Flutter 3.44+**.

```bash
flutter pub get
flutter run
```

A API key de teste já vem embutida, mas para sobrescrever em build:

```bash
flutter run --dart-define=API_KEY=SUA_CHAVE
```

Testes:

```bash
flutter test
```

## Arquitetura

Camadas *feature-first*, dimensionadas ao escopo:

- **`data/`** - datasource (Dio + interceptors de auth/log), DTOs, repositório
- **`domain/`** - entidades e a lógica do *close diff*
- **`presentation/`** - Cubits (estados) + UI

Base: **Cubit** (estado), **get_it** (DI), **Equatable** (igualdade sem codegen) e erro tipado (`sealed Failure`) lançado na camada de dados e capturado no Cubit.

## Testes

`flutter test` - 16 testes: lógica do *close diff* (casos de borda), Cubits (loading/loaded/error) e widget (busca, erro, validação de código).
