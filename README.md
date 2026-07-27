# BRL Exchange Rate

App Flutter de câmbio do Real (BRL) contra outras moedas: taxa atual + histórico
dos últimos 30 dias com a variação de fechamento (*close diff*).

## Como rodar

Pré-requisito: **Flutter 3.44+** (canal stable).

```bash
flutter pub get
flutter run
```

A API key de teste já vem embutida. Para sobrescrever em build:

```bash
flutter run --dart-define=API_KEY=SUA_CHAVE
```

Testes:

```bash
flutter test
```

## Arquitetura

Camadas *feature-first*, dimensionadas ao escopo:

- **`data/`** — datasource (Dio + interceptors de auth/log), DTOs, repositório
- **`domain/`** — entidades e a lógica do *close diff*
- **`presentation/`** — Cubits (estados) + UI

Base: **Cubit** (estado), **get_it** (DI), **Equatable** (igualdade sem codegen) e erro tipado (`sealed Failure`) lançado na camada de dados e capturado no Cubit.

## Testes

`flutter test` — 16 testes: lógica do *close diff* (casos de borda), Cubits (loading/loaded/error) e widget (busca, erro, validação de código).

## Escopo: MVP vs. este projeto

Suponho que a Action Labs trabalha bastante com MVPs; implementei uma versão **mais estruturada** do que um MVP exigiria (camadas data/domain/presentation, DI, erro tipado) para demonstrar como organizo projetos feitos para **crescer**. Num MVP de prazo curto eu poderia enxugar algumas camadas (ex.: fundir datasource+repositório) ou usar algumas libs de codegen para acelerar o desenvolvimento como freezed.

## Ferramentas e tempo

**~8h**, bem fragmentadas — estava num congresso no Rio de quarta a domingo e finalizei no retorno (dá pra ver no histórico de commits).
Ferramentas: **Flutter/Dart** + **Claude (Anthropic)** como par de programação, **VS Code** como IDE e **GitKraken** para controle do git.
Usei a IA para escrever os **testes** (unitários e de widget), revisar
**vulnerabilidades**/pontos que eu deixaria passar, a **lógica do close diff** (a ideia de ordenar por data antes de calcular saiu dessa troca) e a **lista em slivers**. Conduzi as decisões de arquitetura e revisão crítica inclusive **cortando** o que veio a mais (`Result`, hierarquia dupla de erro, interfaces) por ser over-engineering para o escopo, e ajustando pontos como o corte em 30 dias e a lista preguiçosa.
