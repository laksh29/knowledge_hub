# Project Structure

## Organization Philosophy

Feature-first, layered by Clean Architecture ring: each feature under `lib/features/<feature>/` contains its own `domain/`, `data/`, and `presentation/` subtrees. Cross-feature shared code lives in `lib/core/`. See `flutter-clean-architecture-guide.md` §3 for the full reference layout and rules — this file is a quick-reference summary, not a replacement.

## Directory Patterns

### `lib/core/`
**Location**: `lib/core/`
**Purpose**: Cross-feature primitives with no dependency on `features/` — `error/` (`Failure`, `Result<F,S>`, exceptions), `usecase/` (base `UseCase` classes), `network/` (`NetworkInfo`, `ApiClient`), `di/` (`get_it` + `injectable` config), `router/` (shared `go_router` primitives), `domain_shared/` (cross-feature entities: `Money`, `User`, `Address`).
**Example**: `lib/core/error/result.dart`, `lib/core/usecase/usecase.dart`

### `lib/features/<feature>/domain/`
**Location**: `lib/features/<feature>/domain/{entities,repositories,usecases}/`
**Purpose**: Pure business objects (Entities), abstract repository contracts, use cases. No imports from `data/`, `presentation/`, `flutter`, `http`, or any freezed Model/ViewModel type.
**Example**: `lib/features/products/domain/entities/product.dart`

### `lib/features/<feature>/data/`
**Location**: `lib/features/<feature>/data/{models,datasources,repositories}/`
**Purpose**: Wire/cache Models (`fromJson`/`toJson`), a single `DataSource` abstract contract implemented by Remote/Local/Fake, and `<X>RepositoryImpl` classes that own caching policy.
**Example**: `lib/features/products/data/datasources/products_data_source.dart`

### `lib/features/<feature>/presentation/`
**Location**: `lib/features/<feature>/presentation/{bloc,cubit,view_models,pages,widgets}/`
**Purpose**: Bloc/Cubit (state is the only public surface), ViewModels (presentation-ready getters), pages, and reusable widgets. No raw entity/Failure ever reaches a widget.
**Example**: `lib/features/products/presentation/view_models/product_view_model.dart`

### `test/`
**Location**: `test/features/<feature>/...` mirroring `lib/features/<feature>/...` 1:1, with fixtures under `test/fixtures/*.json`.
**Purpose**: TDD-first tests for `domain`, `data`, and Bloc/Cubit logic.
**Example**: `test/features/products/domain/usecases/search_products_test.dart`

## Naming Conventions

- **Files & directories**: `snake_case`
- **Classes**: `UpperCamelCase`, must match filename
- **Variables & functions**: `lowerCamelCase`, verbose and contextual (see `tech.md`)
- **Suffix conventions**: `*_uc.dart` (use case), `*_model.dart`, `*_view_model.dart`, `*_widget.dart`, `*_screen.dart`/`*_page.dart`, `*_data_source.dart`/`*_data_source_impl.dart`, `*_repository.dart`/`*_repository_impl.dart`, `*_bloc.dart`/`*_state.dart`/`*_event.dart`, `*_cubit.dart`/`*_state.dart`

## Import Organization

Plain imports preferred; avoid `show` unless resolving a genuine name collision between two imports.

```dart
import 'package:knowledge_hub/features/products/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
```

**Path Aliases**: None — use full `package:knowledge_hub/...` imports; no relative `../../` traversal across feature boundaries.

## Code Organization Principles

- **Dependency Rule**: source dependencies point inward only. `presentation` → `domain`, `data` → `domain`. `domain` depends on nothing else in the project except `core` shared kernel primitives (`Result`, `Failure`, base `UseCase` types).
- `core/` has no dependency on anything under `features/`. Features depend on `core/`, never the reverse.
- Cross-feature composition imports another feature's `domain/` types only — never its `data/` or `presentation/` internals.
- Shared entities used by more than one feature go in `core/domain_shared/`, not duplicated per feature.
- No compiler-enforced package boundary (single app, no monorepo) — treat the folder boundaries as a hard review rule instead (`flutter-clean-architecture-guide.md` §9).
- Separate widget classes only — no widget-returning functions/methods for repeated or complex subtrees.
- Blocs/Cubits are constructed at navigation time via `BlocProvider(create: ...)`, never inside `build()` and never registered in `get_it` as singletons.

---
_Full repo layout reference, rationale, and the PR review checklist live in `flutter-clean-architecture-guide.md` §3 and §9._
