# Technology Stack

## Architecture

Clean Architecture at the macro level (`domain` / `data` / `presentation`, dependency rule, use cases as the only entry point into business logic), with `flutter_bloc`'s Event-in/State-out loop as an MVI-style presentation layer and ViewModels as the state's data-shaping layer. See `flutter-clean-architecture-guide.md` (repo root) for the full rationale — it is the **binding standard**, not background reading.

**Full standard**: `flutter-clean-architecture-guide.md` — every rule in that document is mandatory unless explicitly marked "guideline." This steering file summarizes it for quick reference; the guide itself is authoritative and must be read directly for code-level patterns, worked examples, and the PR review checklist (§9).

## Core Technologies

- **Language**: Dart 3 (`sdk: ^3.10.4`)
- **Framework**: Flutter
- **State management**: `flutter_bloc` (Bloc + Cubit), sealed states, ViewModel-shaped data
- **Error handling**: Dart 3 sealed classes (`Result<F, S>` / `Failure`) — no `dartz`
- **Models/Entities/ViewModels**: `freezed` + `json_serializable`
- **HTTP client**: `http` package, wrapped by a thin `core/network/ApiClient`
- **Dependency injection**: `get_it` + `injectable` (codegen)
- **Navigation**: `go_router`
- **Unit test mocking**: `mocktail` only — **never `mockito`**
- **Bloc testing**: `bloc_test`
- **Lint baseline**: `flutter_lints` (`analysis_options.yaml`)

## Development Standards

### Type Safety

Non-negotiable, enforced on every PR (see `flutter-clean-architecture-guide.md` §9 checklist):

- **Never use `dynamic`** — not as a variable, parameter, or return type.
- **Never use `Object?` as a substitute for a proper type.** Every value has a concrete type.
- **Never use `Map<String, dynamic>` to pass structured data between functions or layers.** Define a typed model class instead. Bare string-keyed maps (e.g. `{'cityId': ..., 'latitude': ...}`) are typed models in disguise.
  - The only acceptable use of `Map<String, dynamic>` is inside `fromJson`/`toJson` serialization, or for server fields explicitly documented as schema-free opaque blobs — confined to the Model boundary (`data/models/`).
- **Every variable declaration has an explicit, concrete type.** No `var` for non-obvious local types.
- **Every function and method declares an explicit return type.** No inferred/implicit return types, including on private helpers and closures assigned to a variable.
- **Every callback parameter has an explicit, concrete type.**
- A `DataSource` is the only layer allowed to `throw`; everything above receives `Result<Failure, T>` (§4.1–4.3 of the guide).

### Naming

Verbose and contextual — a name must precisely describe what a variable holds or what a function does, even at the cost of brevity. Prefer `selectedProductAvailabilityLabel` over `label`, `fetchFeaturedProductsAndCacheLocally` over `fetch`. This applies uniformly to classes, variables, fields, parameters, and functions.

| Type | Convention |
|---|---|
| Variables & functions | `lowerCamelCase`, verbose/contextual |
| Classes | `UpperCamelCase` — must match filename |
| Files & directories | `snake_case` |
| Use cases | `*_uc.dart` |
| Models | `*_model.dart` |
| Entities | plain noun, e.g. `product.dart` |
| ViewModels | `*_view_model.dart` |
| Widgets | `*_widget.dart` |
| Screens/Pages | `*_screen.dart` / `*_page.dart` |
| DataSource definition / impl | `*_data_source.dart` / `*_data_source_impl.dart` |
| Repository definition / impl | `*_repository.dart` / `*_repository_impl.dart` |
| Bloc / State / Event | `*_bloc.dart` / `*_state.dart` / `*_event.dart` |
| Cubit / State | `*_cubit.dart` / `*_state.dart` |

Bloc/Cubit + their state/event files live in their own folder.

### Code Quality

- No public functions, methods, getters, setters, or variables beyond what a base class (`Bloc`/`Cubit`) already provides, or constructor-injected dependencies.
- One function, one responsibility. DRY — extract duplicated logic.
- No unnecessary comments or documentation. No `// removed` markers or backwards-compat shims for code that is simply deleted.
- No business or presentation-conditional logic in widgets — belongs in a `UseCase` or a `ViewModel` getter.
- Prefer exceptions over error codes/enums at the boundary; `Result`/`Failure` above it.

### Testing

- `domain` and `data`: TDD mandatory, effectively 100% line coverage.
- `presentation`: Bloc/Cubit logic fully covered via `bloc_test`; widget/golden tests are explicitly out of scope for now (guide §8.6).
- `mocktail` exclusively — `mockito` appearing anywhere (dependency or `when(x.method())` positional syntax) is a review-blocking issue.

## Development Environment

### Required Tools

- Flutter SDK matching `environment.sdk: ^3.10.4` in `pubspec.yaml`
- `build_runner` for `freezed` / `json_serializable` / `injectable` codegen

### Common Commands

```bash
# Dev:   flutter run
# Build: flutter build <platform>
# Test:  flutter test
# Codegen: dart run build_runner build --delete-conflicting-outputs
# Analyze: flutter analyze
```

## Key Technical Decisions

- Dart 3 sealed `Result<Failure, T>` instead of `dartz` `Either` — no third-party FP dependency needed once the language has sealed classes + exhaustive `switch`.
- A single `DataSource` abstract contract per feature (Remote/Local/Fake all implement it) rather than separate Remote/Local base types — trades strict ISP for one swappable contract and one Fake per feature (guide §6.2).
- Bloc/Cubit's only public surface is `state` — no convenience getters, to prevent drift between a getter and the emitted state.
- Widget/golden testing is deliberately deferred (guide §8.6) — revisit once ViewModel + sealed-state pattern proves out.

---
_Full rules, code-level examples, and the PR review checklist live in `flutter-clean-architecture-guide.md` — read it directly before designing or reviewing any Flutter code in this repo._
