/// Adapts `WidgetsBindingObserver` app-lifecycle transitions into a
/// `Stream<AppLifecycleState>`, so a Bloc can react without ever receiving
/// a `BuildContext`.
///
/// This package has zero dependency on any consuming application's types and
/// no dependency-injection framework annotations.
library;

export 'src/app_lifecycle_service.dart';
export 'src/app_lifecycle_service_impl.dart';
