/// Adapts `WidgetsBindingObserver` app-lifecycle transitions into a
/// `Stream<AppLifecycleState>`, so a Bloc can react without ever receiving
/// a `BuildContext`.
///
/// This package has zero dependency on any consuming application's types and
/// no dependency-injection framework annotations — implementation is added
/// in a later task (see notes-mvp tasks.md, task 1.4).
library;
