# Flutter Clean Architecture & TDD Standard

**Status:** Adopted convention (greenfield) — this document is the source of truth.
**Audience:** Human engineers and Claude coding/review agents implementing or reviewing Flutter code under this standard.
**Derived from:** Reso Coder's *Flutter TDD Clean Architecture* course (14 parts, 2019), modernized for Dart 3 / Flutter 3.x.

**Stack this guide targets:**
| Concern | Choice |
|---|---|
| State management | `flutter_bloc` (Bloc + Cubit), sealed states, ViewModel-shaped data |
| Domain/Data error handling | Dart 3 sealed classes (`Result<F, S>`), no `dartz` |
| Models/Entities/ViewModels | `freezed` + `json_serializable` |
| HTTP client | `http` package |
| Dependency injection | `get_it` + `injectable` (codegen) |
| Navigation | `go_router` |
| Repo layout | Single app, feature-first folders under `lib/` |
| Unit test mocking | `mocktail` only — **never mockito** |
| Bloc testing | `bloc_test` |
| Widget testing | Out of scope for now (see §8.6) |

Agents implementing or reviewing code under this standard MUST treat every rule in this document as binding unless a section explicitly says "guideline" instead of "rule." Where this document is silent, fall back to the principles in §2, not to whatever pattern the original Reso Coder course used (that course used dartz/mockito/dispatch()-era Bloc/manual get_it/separate Remote+Local contracts — all superseded here).

---

## 1. What Pattern Are We Actually Following? (MVC / MVP / MVVM / MVI vs. Clean Architecture)

This gets asked often enough that it's worth answering precisely instead of using these terms loosely.

**Clean Architecture is not a UI pattern.** It says nothing about how a View talks to its logic-holder. It's a rule about *dependency direction across the whole app* — Entities and Use Cases (domain) at the center, knowing nothing about the outside; Data and Presentation as outer rings that depend inward, never the reverse. You could put MVC, MVP, MVVM, or MVI inside Clean Architecture's presentation ring and still be doing Clean Architecture. They answer different questions.

The UI patterns, for comparison:

- **MVC (Model-View-Controller):** the Controller mediates between Model and View. In practice on mobile this tends to collapse into a "Massive View Controller" — the lifecycle-bound class (Activity/ViewController/State) ends up holding both view wiring and business logic, because there's no structural pressure keeping them apart.
- **MVP (Model-View-Presenter):** the Presenter holds all presentation logic and drives a passive View through an explicit interface — imperative, "tell the view what to do" (`view.showLoading()`, `view.showError(msg)`). The View has no direct Model access.
- **MVVM (Model-View-ViewModel):** the ViewModel exposes observable/bindable state that the View subscribes to; the ViewModel has *no reference to the View at all*. Classically this is two-way data binding (View writes back into the ViewModel for input fields) plus one-way binding for display.
- **MVI (Model-View-Intent):** strictly unidirectional. The View emits an Intent (a user action), it's processed against the current Model to produce a brand-new immutable State object, and the View renders that whole State. No in-place mutation, no partial updates — always a fresh, complete state each cycle.

**What we are actually doing here, honestly:** Clean Architecture at the macro level (domain/data/presentation, dependency rule, use cases as the only entry point into business logic) — that part is unambiguous. Inside the presentation ring, `flutter_bloc`'s Event-in/State-out loop is structurally **MVI**, not MVVM: Events are Intents, State is an immutable render model, there is no two-way binding and no ViewModel object that exists independently of the state stream.

What we're layering on top (§7.2, per your requirements) is a **ViewModel-shaped object living inside each MVI State** — an immutable, computed-getter data holder that the View reads from. This borrows MVVM's *idea* (expose ready-to-render getters, not raw data) without borrowing MVVM's *mechanism* (there's still only one subscription point — `bloc.stream`/`state` — not an independently observable ViewModel). Calling the whole thing "MVVM" would be a stretch and I'd rather not let that label stick if it isn't accurate. If you want a precise name for what's in this document: **"Clean Architecture with an MVI-style Bloc presentation layer, using ViewModels as the state's data-shaping layer."** In everyday conversation, "Bloc pattern" is sufficient and accurate — Bloc itself is Google's own named pattern, not textbook MVI or MVVM, and what's described here is a fairly standard modern application of it.

---

## 2. Core Principles

1. **Dependency Rule**: source code dependencies point inward only. `presentation` depends on `domain`. `data` depends on `domain`. `domain` depends on **nothing** else in the project except shared kernel primitives (`Result`, `Failure`, base `UseCase` types). Domain never imports `data`, `presentation`, `flutter`, `http`, or a freezed-generated Model/ViewModel type.
2. **Contracts live in `domain`, implementations live in `data`.** A `Repository` is an abstract class defined in `domain/repositories/`; its concrete class lives in `data/repositories/` and is named `<X>RepositoryImpl`.
3. **Entities vs. Models are different types, not the same class reused.** An `Entity` (domain) is the pure business object. A `Model` (data) is the wire/cache representation with `fromJson`/`toJson`. Models do **not** extend Entities (see §6.1).
4. **Errors are values, not control flow**, from the Data Source boundary inward. A `DataSource` is the *only* place allowed to `throw`. Everything above it (`Repository`, `UseCase`, `Bloc`) receives a `Result<Failure, T>` and must handle both branches — no bare try/catch swallowing failures silently, no rethrowing across a repository boundary.
5. **A DataSource is a single abstract contract.** Remote, Local, and any Mock/Fake test double all implement the *same* interface — there is no separate `RemoteDataSource` base type and `LocalDataSource` base type (see §6.2 for the full pattern and its tradeoffs).
6. **TDD is mandatory for `domain` and `data`, and for Bloc/Cubit logic via `bloc_test`.** Every `UseCase`, `RepositoryImpl`, `DataSource` implementation, mapper, and Bloc/Cubit handler must have a test written test-first (red → green → refactor) with a mirrored path under `test/`. Widget tests are explicitly **not** part of this standard right now (§8.6).
7. **No business or presentation-conditional logic in widgets.** Any `if`/`switch` deciding *what the data means* — not just how to lay it out — belongs in a `UseCase` (domain rules) or a `ViewModel` getter (presentation-ready shaping), never inline in a `build()` method.
8. **A Bloc/Cubit's only public surface is its `state`.** No additional public getters or fields beyond what `Bloc`/`Cubit` already provides (`state`, `stream`, `close()`). If a widget needs derived data, it reads that data from `state` — never from a bloc-level convenience getter that could drift out of sync with the emitted state.

---

## 3. Repo Layout (Reference Structure)

A plain, single-app, feature-first layout — no monorepo, no separate packages required for this to work:

```
lib/
├── main.dart
├── app.dart                       # MaterialApp.router + go_router config root
├── bootstrap.dart                 # calls configureDependencies()
├── core/
│   ├── error/                     # Failure, Result<F,S>, ServerException/CacheException
│   ├── usecase/                   # UseCase / UseCaseNoParams / SyncUseCase / SyncUseCaseNoParams
│   ├── network/                   # NetworkInfo, ApiClient
│   ├── di/                        # get_it instance + injectable config
│   ├── router/                    # shared go_router primitives, route guards
│   └── domain_shared/             # cross-feature entities: Money, User, Address, etc.
└── features/
    └── products/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/      # abstract contracts
        │   └── usecases/
        ├── data/
        │   ├── models/
        │   ├── datasources/
        │   │   ├── products_data_source.dart          # single abstract contract
        │   │   ├── products_remote_data_source.dart    # implements it
        │   │   └── products_local_data_source.dart      # implements it too
        │   └── repositories/      # <X>RepositoryImpl
        └── presentation/
            ├── bloc/ (or cubit/)
            ├── view_models/
            ├── pages/
            └── widgets/

test/
├── fixtures/
└── features/
    └── products/                  # mirrors lib/features/products/ 1:1
```

**Rules:**
- `core/` has no dependency on anything under `features/`. Features depend on `core/`, never the reverse.
- Cross-feature composition (e.g. a "Checkout" feature needing both product and order entities) happens by importing the other feature's `domain/` types only — never its `data/` or `presentation/`.
- Shared entities that more than one feature needs (`Money`, `User`, `Address`) go in `core/domain_shared/`, not duplicated per feature.
- There is no compiler-enforced package boundary here (that would require splitting into packages, which this standard deliberately does not require). Treat the folder boundaries above as a **hard review rule** instead: a PR that imports another feature's `data/` or `presentation/` internals should be rejected on that basis alone (see §9).

---

## 4. Core Utilities (`lib/core/`)

### 4.1 Result type (replaces dartz `Either`)

```dart
// lib/core/error/result.dart
sealed class Result<F extends Failure, S> {
  const Result();

  T when<T>({
    required T Function(F failure) failure,
    required T Function(S success) success,
  }) => switch (this) {
    Err(:final failure_) => failure(failure_),
    Ok(:final value) => success(value),
  };

  bool get isOk => this is Ok<F, S>;
  bool get isErr => this is Err<F, S>;
}

final class Ok<F extends Failure, S> extends Result<F, S> {
  const Ok(this.value);
  final S value;
}

final class Err<F extends Failure, S> extends Result<F, S> {
  const Err(this.failure_);
  final F failure_;
}
```

Use `switch` expressions at call sites in preference to `.when(...)` where it reads more clearly — both are acceptable, but **be consistent within a file**.

### 4.2 Failure hierarchy

```dart
// lib/core/error/failure.dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No cached data available']);
}
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
```

Feature folders MAY extend `Failure` with domain-specific subtypes (e.g. `OutOfStockFailure`), but MUST NOT redefine `ServerFailure`/`CacheFailure`/`NetworkFailure` locally — those are shared vocabulary and a Bloc's exhaustive `switch` over `Failure` relies on that shared set plus its own feature-specific additions.

### 4.3 Exceptions (Data layer only)

```dart
// lib/core/error/exception.dart
class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;
}
class CacheException implements Exception {
  const CacheException([this.message]);
}
```

A `DataSource` throws these. A `RepositoryImpl` catches them and converts to the matching `Failure`. Nothing above the repository ever sees a `ServerException`/`CacheException`.

### 4.4 UseCase base classes — sync/async × with-params/no-params

Not all domain logic is I/O-bound. Forcing a pure, synchronous computation through an async contract just adds `Future` wrapping noise for no reason. Four base classes cover the real combinations:

```dart
// lib/core/usecase/usecase.dart

/// Async, takes params — the common case: hits a repository/data source.
abstract class UseCase<S, P> {
  Future<Result<Failure, S>> call(P params);
}

/// Async, no params — e.g. "refresh the cached list", "get the current user".
abstract class UseCaseNoParams<S> {
  Future<Result<Failure, S>> call();
}

/// Sync, takes params — pure computation on already-available data, no I/O.
abstract class SyncUseCase<S, P> {
  Result<Failure, S> call(P params);
}

/// Sync, no params — pure computation needing no input.
abstract class SyncUseCaseNoParams<S> {
  Result<Failure, S> call();
}
```

Examples of each, so the distinction is concrete rather than theoretical:

```dart
// Async + params — hits the repository.
class SearchProducts implements UseCase<List<Product>, ProductSearchParams> {
  const SearchProducts(this._repository);
  final ProductsRepository _repository;

  @override
  Future<Result<Failure, List<Product>>> call(ProductSearchParams params) =>
      _repository.searchProducts(params);
}

// Async + no params — hits the repository, but needs no input.
class GetFeaturedProducts implements UseCaseNoParams<List<Product>> {
  const GetFeaturedProducts(this._repository);
  final ProductsRepository _repository;

  @override
  Future<Result<Failure, List<Product>>> call() => _repository.getFeatured();
}

// Sync + params — pure validation, no I/O, no async gap.
class ValidateDiscountCode implements SyncUseCase<bool, String> {
  const ValidateDiscountCode();

  @override
  Result<Failure, bool> call(String code) {
    final isValid = RegExp(r'^[A-Z0-9]{6,12}$').hasMatch(code);
    return isValid ? const Ok(true) : const Err(ValidationFailure('Invalid discount code format'));
  }
}

// Sync + no params — pure business-rule constant, no I/O, no input.
class GetDefaultSortOrder implements SyncUseCaseNoParams<SortOrder> {
  const GetDefaultSortOrder();

  @override
  Result<Failure, SortOrder> call() => const Ok(SortOrder.relevance);
}
```

Pick the narrowest base class that matches what the use case actually does — a sync use case wrapped in `Future.value(...)` just to satisfy `UseCase` is a review-flaggable smell (§9).

### 4.5 `NetworkInfo`

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
```
Implemented using a maintained, null-safe connectivity-checking package that verifies actual internet reachability, not just radio/interface state (the original course's `connectivity`/`data_connection_checker` packages only report platform-level connection type and are effectively unmaintained). Registered as a lazy singleton via `@LazySingleton(as: NetworkInfo)`.

### 4.6 DI convention (`get_it` + `injectable`)

- Every injectable class is annotated at its declaration site: `@LazySingleton()` for stateless singletons (repositories, data sources, use cases, mappers), `@injectable` for anything needing a fresh instance per resolution.
- Interface bindings use `@LazySingleton(as: AbstractType)`.
- **Multiple implementations of the same contract are disambiguated with `@Named`**, which is exactly the mechanism that makes the single-DataSource-contract rule (§2.5, §6.2) work: `@Named('remote')` and `@Named('local')` on two classes that both implement `ProductsDataSource`.
- Blocs/Cubits are **not** registered in `get_it` as singletons. They are constructed via `BlocProvider(create: (_) => ProductsSearchBloc(getIt(), getIt()))` at the point of navigation (typically inside the `go_router` route builder), so their lifecycle matches the page, not the app.
- HTTP `Client` and any low-level SDK instances are registered once in `core`'s DI module as lazy singletons and injected into each feature's data source constructors.

### 4.7 Networking (`http` package)

`core` provides a thin `ApiClient` wrapper — not a full abstraction that hides `http`, just a place for shared headers, base URL config, and centralized JSON decoding/error-code translation, so no data source hand-rolls status code checks:

```dart
class ApiClient {
  ApiClient(this._client, {required this.baseUrl});
  final http.Client _client;
  final String baseUrl;

  Future<Map<String, dynamic>> getJson(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final response = await _client.get(uri, headers: _defaultHeaders);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw ServerException('GET $path failed with ${response.statusCode}');
  }
  // postJson, putJson, deleteJson follow the same shape
}
```

---

## 5. Domain Layer

### 5.1 Entities (freezed)

```dart
// lib/features/products/domain/entities/product.dart
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required Money price,
    required bool inStock,
  }) = _Product;
}
```

- Entities contain **no** JSON logic, no `@JsonSerializable()`, no persistence annotations.
- Entities may contain simple derived getters that are genuine *business* logic (e.g. `bool get isOnSale => price.discounted;`) — display formatting is a ViewModel concern (§7.2), not an entity concern.
- Shared entities (`Money`, `User`, `Address`) live in `core/domain_shared/` as described in §3.

### 5.2 Repository contracts

```dart
// lib/features/products/domain/repositories/products_repository.dart
abstract class ProductsRepository {
  Future<Result<Failure, List<Product>>> searchProducts(ProductSearchParams params);
  Future<Result<Failure, Product>> getProductDetails(String productId);
  Future<Result<Failure, List<Product>>> getFeatured();
}
```

One repository contract per bounded concept within a feature — don't force every feature into exactly one repository.

### 5.3 Use cases

See §4.4 for the four base-class variants and worked examples. The rule that matters here: a use case that does nothing but forward to the repository is completely normal for CRUD-shaped operations — the value is the stable, mockable seam, not necessarily complex logic inside it. Use cases MUST NOT catch exceptions — they only see `Result` from the repository and pass through or transform failures via `Result` combinators, never `try/catch`.

---

## 6. Data Layer

### 6.1 Models (freezed + json_serializable)

```dart
// lib/features/products/data/models/product_model.dart
@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String name,
    required String description,
    required int priceMinorUnits,   // wire format: minor units, not a Money entity
    required String priceCurrency,
    required bool inStock,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Product toEntity() => Product(
        id: id,
        name: name,
        description: description,
        price: Money(amountMinor: priceMinorUnits, currency: priceCurrency),
        inStock: inStock,
      );
}
```

**Models do not `extend` Entities.** The wire shape and the domain shape diverge the moment a real API is involved (minor-units integer vs. a `Money` value object, an extra field, a nullable API field that's a non-null business invariant once validated). Every Model instead exposes an explicit `toEntity()` (and `Model.fromEntity(entity)` if the feature ever sends domain data back to an API). This mapping is pure, deterministic, and must be unit tested.

### 6.2 A single DataSource contract — Remote, Local, and Fake all implement it

```dart
// lib/features/products/data/datasources/products_data_source.dart
abstract class ProductsDataSource {
  /// Fetch matching a query. Remote hits the network; Local reads its own store.
  Future<List<ProductModel>> fetchProducts(ProductSearchParams params);

  /// Persist results. Meaningful for Local; Remote treats this as a no-op
  /// (documented, not silently inherited — see below).
  Future<void> saveProducts(List<ProductModel> models);

  /// Read whatever was last persisted. Meaningful for Local; Remote does not
  /// support this and says so explicitly.
  Future<List<ProductModel>> getCachedProducts();
}
```

```dart
@Named('remote')
@LazySingleton(as: ProductsDataSource)
class ProductsRemoteDataSourceImpl implements ProductsDataSource {
  const ProductsRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<ProductModel>> fetchProducts(ProductSearchParams params) async {
    final json = await _apiClient.getJson('/products/search', query: params.toQuery());
    final results = json['results'] as List;
    return results.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveProducts(List<ProductModel> models) async {
    // Remote is not a cache target. Intentional no-op, stated here so a
    // reviewer sees the decision instead of an unexplained empty method.
  }

  @override
  Future<List<ProductModel>> getCachedProducts() {
    throw UnsupportedError('Remote data source does not support reading a cache.');
  }
}
```

```dart
@Named('local')
@LazySingleton(as: ProductsDataSource)
class ProductsLocalDataSourceImpl implements ProductsDataSource {
  const ProductsLocalDataSourceImpl(this._store);
  final CacheStore _store; // e.g. a Hive box or Drift DAO

  @override
  Future<List<ProductModel>> fetchProducts(ProductSearchParams params) {
    // Local's "fetch" IS its cache read; params are unused unless the local
    // store itself is queryable (e.g. Drift).
    return getCachedProducts();
  }

  @override
  Future<void> saveProducts(List<ProductModel> models) async {
    await _store.write('last_search', models.map((m) => m.toJson()).toList());
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final raw = await _store.read('last_search');
    if (raw == null) throw const CacheException();
    return (raw as List).map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
```

**Honest tradeoff:** this deliberately gives up strict Interface Segregation for a single, uniformly swappable contract. The payoff is concrete: a `RepositoryImpl` (below) holds two fields of the *same* type instead of two different types, dependency injection needs one interface + `@Named` qualifiers instead of two interfaces, and — most usefully for testing/dev-preview — a single in-memory `FakeProductsDataSource implements ProductsDataSource` can stand in for *either* role without needing two separate fakes. Where a method genuinely doesn't apply to a given implementation, make that explicit (a documented no-op, or `UnsupportedError` with a message) rather than a silent empty body — the contract violation should be visible to a reviewer, not hidden.

### 6.3 Repository implementation — the caching policy lives here, nowhere else

```dart
@LazySingleton(as: ProductsRepository)
class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl({
    @Named('remote') required ProductsDataSource remoteDataSource,
    @Named('local') required ProductsDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo;

  final ProductsDataSource _remote;
  final ProductsDataSource _local;
  final NetworkInfo _networkInfo;

  /// Caching policy: always remote when online, cache on success, no offline
  /// fallback. Appropriate for time-sensitive search results that go stale
  /// quickly. Contrast with a "remote-when-online, fall back to cache when
  /// offline" policy, which is a different, equally valid choice for other
  /// repositories — document whichever one applies, per repository.
  @override
  Future<Result<Failure, List<Product>>> searchProducts(ProductSearchParams params) async {
    if (!await _networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }
    try {
      final models = await _remote.fetchProducts(params);
      unawaited(_local.saveProducts(models));
      return Ok(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Err(ServerFailure(e.message ?? 'Server error'));
    }
  }
}
```

`try/catch` for the specific `Exception` types declared by the data source contract is the **only** acceptable use of try/catch in this layer. Catching bare `Exception`/`Object` here is review-blocking.

---

## 7. Presentation Layer (ViewModels + Sealed States + Bloc/Cubit + go_router)

### 7.1 When to use Bloc vs Cubit

- **Cubit**: default choice for a page whose interactions are simple method calls (`ProductDetailsCubit` with a `load(productId)` method). Less boilerplate, easier to test.
- **Bloc**: use when a page has genuinely distinct event types with different handling logic, or needs stream transformers (`debounce`, `restartable`).
- Don't default to Bloc for something that's really a Cubit — a Bloc with exactly one event type is unnecessary ceremony (flag it in review).

### 7.2 ViewModels — all conditions live here as getters, nowhere else

A ViewModel wraps one or more entities and exposes only presentation-ready getters. Widgets read the ViewModel; they never branch on a raw entity field themselves.

```dart
// lib/features/products/presentation/view_models/product_view_model.dart
@freezed
class ProductViewModel with _$ProductViewModel {
  const ProductViewModel._();

  const factory ProductViewModel({
    required String id,
    required String name,
    required Money price,
    required bool inStock,
  }) = _ProductViewModel;

  factory ProductViewModel.fromEntity(Product product) => ProductViewModel(
        id: product.id,
        name: product.name,
        price: product.price,
        inStock: product.inStock,
      );

  // Every display condition is a getter here — not in the widget, not in the Bloc.
  String get displayPrice => price.formatted;          // e.g. "$12.99"
  bool get showOutOfStockBadge => !inStock;
  String get availabilityLabel => inStock ? 'In stock' : 'Out of stock';
}
```

A widget does `Text(viewModel.displayPrice)` and `if (viewModel.showOutOfStockBadge) ...` — it never touches `product.inStock` or formats a price itself. If a new display rule is needed, it's a new getter on the ViewModel, reviewed and unit tested like any other pure function — not a conditional added to a widget's `build()`.

### 7.3 States — one sealed base, explicit subclasses, ViewModels carried across transitions

```dart
// lib/features/products/presentation/bloc/products_search_state.dart
@freezed
sealed class ProductsSearchState with _$ProductsSearchState {
  const factory ProductsSearchState.initial() = ProductsSearchInitial;

  const factory ProductsSearchState.loading({
    @Default(<ProductViewModel>[]) List<ProductViewModel> previousResults,
  }) = ProductsSearchLoading;

  const factory ProductsSearchState.success(
    List<ProductViewModel> results,
  ) = ProductsSearchSuccess;

  const factory ProductsSearchState.failure(
    String message, {
    @Default(<ProductViewModel>[]) List<ProductViewModel> previousResults,
  }) = ProductsSearchFailure;
}
```

Distinct subclasses (rather than one class with a status enum) make each state's valid fields explicit at compile time — `ProductsSearchInitial` simply has no `results` field to accidentally read. Carrying `previousResults` (a list of ViewModels) forward into `Loading`/`Failure` is what lets a refresh keep the last good list visible instead of flashing an empty screen — this is what "use ViewModels to hold and pass data across states" means concretely.

### 7.4 Bloc implementation — state is the only public surface

```dart
class ProductsSearchBloc extends Bloc<ProductsSearchEvent, ProductsSearchState> {
  ProductsSearchBloc(this._searchProducts) : super(const ProductsSearchState.initial()) {
    on<SearchSubmitted>(_onSearchSubmitted);
  }

  final SearchProducts _searchProducts;

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<ProductsSearchState> emit,
  ) async {
    final previous = switch (state) {
      ProductsSearchSuccess(:final results) => results,
      ProductsSearchLoading(:final previousResults) => previousResults,
      ProductsSearchFailure(:final previousResults) => previousResults,
      ProductsSearchInitial() => const <ProductViewModel>[],
    };
    emit(ProductsSearchState.loading(previousResults: previous));

    final result = await _searchProducts(event.params);
    switch (result) {
      case Ok(:final value):
        final vms = value.map(ProductViewModel.fromEntity).toList();
        emit(ProductsSearchState.success(vms));
      case Err(:final failure_):
        emit(ProductsSearchState.failure(
          mapFailureToMessage(failure_),
          previousResults: previous,
        ));
    }
  }
}
```

Note there is **no additional public getter on `ProductsSearchBloc` beyond what `Bloc` itself provides** (`state`, `stream`, `close()`). If a widget needs "the current results," it reads them out of `state` via the sealed `switch` — a convenience getter like `List<ProductViewModel> get currentResults => ...` added directly to the Bloc is exactly the kind of side channel that can silently drift from what's actually been emitted, and is review-blocking (§9).

- Use `on<Event>(handler, transformer: ...)` from `bloc_concurrency` for debounce/throttle/restartable semantics instead of hand-rolled `Stream` gymnastics.
- A Bloc/Cubit depends **only** on use cases, never directly on a repository or data source, and never on `get_it` itself (dependencies are passed via constructor).
- Widgets never see a `Failure` object directly — `mapFailureToMessage(Failure)` (a small pure function, unit tested, shared per feature or in `core`) converts it to a user-facing `String` before it reaches `state`.

### 7.5 go_router integration

- Each feature exports its `GoRoute`/`RouteBase` definitions; the app shell composes them into the root `GoRouter`.
- `BlocProvider`/`RepositoryProvider` wrapping happens inside the route's `builder`/`pageBuilder`, scoping the Bloc's lifecycle to the page.
- Route parameter parsing/validation is presentation-layer glue code — keep it in the route definition, not inside the Bloc.

---

## 8. Testing Standard

### 8.1 Layout

Tests mirror `lib/features/` 1:1 under `test/features/`. Fixtures live in `test/fixtures/*.json`.

### 8.2 Mocking — `mocktail` only, never `mockito`

```dart
class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late SearchProducts usecase;
  late MockProductsRepository repository;

  setUp(() {
    repository = MockProductsRepository();
    usecase = SearchProducts(repository);
  });

  test('forwards params to the repository and returns its result unchanged', () async {
    final params = ProductSearchParams(query: 'shoes', category: 'footwear');
    final tProducts = [tProduct];
    when(() => repository.searchProducts(params))
        .thenAnswer((_) async => Ok(tProducts));

    final result = await usecase(params);

    expect(result, isA<Ok<Failure, List<Product>>>());
    verify(() => repository.searchProducts(params)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
```

Rules:
- Always `mocktail`'s function-call `when(() => ...)` syntax. **`mockito` must not appear anywhere in this codebase's `dev_dependencies` or test files** — if a PR introduces it (or the older positional `when(x.method())` syntax that mockito uses), that's an automatic review rejection, not a style nitpick.
- Every test verifies both the "happy path forwards data unchanged" case and, separately, that failures propagate untouched.
- `verifyNoMoreInteractions` after every interaction-based test.
- Register fallback values (`registerFallbackValue(...)`) once in a shared `test/helpers/` file for any custom `Params`/`Failure` types used with `any()`.

### 8.3 Repository tests

Must cover, at minimum: online+success, online+`ServerException`, offline+cache-hit, offline+cache-miss (`CacheException`) whenever a repository has offline fallback behavior. If a repository has a "no offline fallback" policy (§6.3), the offline branch instead asserts `NetworkFailure` is returned without touching the local data source at all (`verifyNever`).

### 8.4 DataSource tests

Because Remote and Local share one contract (§6.2), their test suites cover different subsets of the same three methods: Remote's suite tests `fetchProducts` (200 → parsed models, non-200 → `ServerException`, malformed JSON → surfaces an error) and asserts `getCachedProducts` throws `UnsupportedError`. Local's suite tests `fetchProducts`/`getCachedProducts` (value present → parsed models, absent → `CacheException`) and `saveProducts` (correct key/serialized value passed to the store, verified via `verify()`).

### 8.5 Bloc/Cubit tests (`bloc_test`)

```dart
blocTest<ProductsSearchBloc, ProductsSearchState>(
  'emits [loading(with previous), success] when search succeeds',
  build: () {
    when(() => searchProducts(any())).thenAnswer((_) async => Ok([tProduct]));
    return ProductsSearchBloc(searchProducts);
  },
  act: (bloc) => bloc.add(SearchSubmitted(tParams)),
  expect: () => [
    isA<ProductsSearchLoading>(),
    isA<ProductsSearchSuccess>(),
  ],
);
```

Use `bloc_test`'s `blocTest` exclusively — never hand-roll `expectLater(bloc.stream, emitsInOrder(...))`. Cover: initial-state assertion (plain `test()`), success path, each distinct `Failure` subtype the feature can produce, and any input-validation failure path.

### 8.6 Widget testing — explicitly out of scope for now

Widget/golden tests are **not required** under this standard at present. This is a deliberate, temporary scoping decision, not an oversight — revisit once the ViewModel + sealed-state pattern above has proven itself across a few real features. `domain`, `data`, and Bloc/Cubit logic remain fully test-gated regardless.

### 8.7 Coverage expectation

`domain` and `data`: effectively 100% line coverage. `presentation`: Bloc/Cubit logic must be fully covered by `bloc_test`; widget rendering code has no coverage requirement per §8.6.

---

## 9. PR Review Checklist (for agents and humans)

Reject or request changes if any of the following are true:

- [ ] A `domain/` file imports anything from `data/`, `presentation/`, `flutter`, `http`, or a freezed **Model**/**ViewModel** class.
- [ ] A `Model` class `extends` an `Entity`, or an `Entity` has `fromJson`/`toJson`.
- [ ] A separate `RemoteDataSource` abstract type and `LocalDataSource` abstract type are introduced instead of one shared `DataSource` contract with `@Named` implementations.
- [ ] A `Repository` implementation catches a bare `Exception`/`Object` instead of the specific declared exception type.
- [ ] A `UseCase`, `Repository`, or `Bloc` contains a `try/catch` around a call that should instead be handled via `Result` from the layer below it.
- [ ] A widget branches on a raw entity field, a raw `Failure`, or contains its own display-condition `if`/`switch` instead of reading a `ViewModel` getter.
- [ ] A Bloc/Cubit declares any public getter or field beyond `state`/`stream`/`close()`.
- [ ] A new feature's Bloc/Cubit is constructed via `getIt<FooBloc>()` as a registered singleton rather than via `BlocProvider(create: ...)` scoped to its page.
- [ ] A repository's caching policy is not documented in a doc-comment, or the tests don't cover the branch matching that documented policy.
- [ ] `mockito` appears anywhere, or a test uses positional `when(x.method(...))` instead of `mocktail`'s `when(() => x.method(...))`.
- [ ] A Bloc test hand-rolls `emitsInOrder` instead of using `blocTest`.
- [ ] A feature imports another feature's `data/` or `presentation/` internals instead of only its `domain/` types.
- [ ] A shared concept (entity, failure type, formatting helper) is duplicated across two or more features instead of promoted to `core/domain_shared`.
- [ ] `Params` classes for use cases with more than one field are plain positional arguments instead of a named class.
- [ ] A sync, non-I/O use case is implemented via the async `UseCase`/`UseCaseNoParams` base class instead of `SyncUseCase`/`SyncUseCaseNoParams` (§4.4).
- [ ] A widget test is added where none was requested/required (§8.6) — not wrong, but flag it so the team decides intentionally rather than by accretion.

---

## 10. Known Deviations From the Source Course (and why)

| Course (2019) | This standard | Why |
|---|---|---|
| `mockito` | `mocktail` only | mockito's null-safety story requires codegen (`@GenerateMocks` + `build_runner`) that mocktail avoids with a simpler function-call API. |
| `bloc.dispatch()` / manual `emitsInOrder` | `bloc.add()` / `bloc_test` | `dispatch` was removed from `flutter_bloc` years ago; `bloc_test` is the maintained, idiomatic testing surface. |
| `dartz` `Either<Failure, T>` | Dart 3 sealed `Result<Failure, T>` | No third-party FP dependency needed once the language has sealed classes + exhaustive `switch`. |
| `Model extends Entity` | `Model.toEntity()` / `Model.fromEntity()` | The course author himself walked this back in later comments — wire shape and domain shape diverge in any real API. |
| `connectivity` / `data_connection_checker` | a maintained, null-safe internet-reachability checker | Former packages report radio/interface state, not actual reachability, and are effectively unmaintained. |
| Separate `RemoteDataSource` / `LocalDataSource` abstract classes | One `DataSource` contract, `@Named('remote')`/`@Named('local')` implementations | Repository and tests depend on one type instead of two; a single Fake covers both roles. Deliberate ISP tradeoff, documented per §6.2. |
| One-freezed-class-with-status-enum state | Sealed base state + explicit subclasses, carrying ViewModels forward | Distinct types make each state's valid fields explicit at compile time; carrying ViewModels into `Loading`/`Failure` avoids UI flicker without stuffing every branch with optional fields. |
| Raw entities reaching the widget, ad hoc formatting in `build()` | Presentation `ViewModel`s expose only getters; widgets never branch on raw data | Keeps all display conditions in one reviewable, testable place instead of scattered across widgets. |
| Bloc exposing convenience getters alongside `state` | Bloc/Cubit's only public surface is `state` | Prevents a getter and the emitted state from silently drifting apart. |
| Single async `UseCase` base class | Four variants: sync/async × with-params/no-params | Not all domain logic is I/O-bound; forcing pure logic through `Future` adds noise for no benefit. |
| No routing covered | `go_router`, route defs owned per feature | Not addressed by the source material at all; added to close a real gap. |
| Ambiguous guidance on shared entities across features | Explicit `core/domain_shared` promotion rule | Removes a real ambiguity the course's own comment section never resolved. |

---

## 11. Open Items For Discussion

Left as discussion points rather than settled rules, pending project-specific input:

1. **Local persistence default** — standardize on `drift`/`hive` as the default for anything beyond trivial `shared_preferences` use, or decide per-feature?
2. **Analytics/observability layer** — not addressed yet. Likely a `core/analytics` contract injected into Blocs, but needs a decision.
3. **Offline-first / sync strategy** beyond simple last-cache-wins — relevant if any feature needs conflict resolution.
4. **Lint ruleset** — a starting point like `very_good_analysis` is a reasonable default but not yet confirmed.
5. **Widget/golden testing** — deliberately deferred (§8.6); revisit scope and tooling once a few reference features exist.

Flag any of these you want locked down now versus revisited after the first feature is built as a reference implementation.
