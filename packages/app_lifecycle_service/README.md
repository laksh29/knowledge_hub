# app_lifecycle_service

Adapts `WidgetsBindingObserver` app-lifecycle transitions into a
`Stream<AppLifecycleState>`, so a Bloc can react to lifecycle changes without
ever receiving a `BuildContext`.

Zero dependency on any consuming application's types and no
dependency-injection framework annotations — copyable verbatim into any
Flutter project per `flutter-clean-architecture-guide.md` §3.1's "zero
project context" test.

Currently a scaffolded, empty placeholder — implementation lands in the
`notes-mvp` feature's task 1.4.
