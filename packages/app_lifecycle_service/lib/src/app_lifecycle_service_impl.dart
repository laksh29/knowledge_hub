import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_lifecycle_service.dart';

/// Wraps [WidgetsBindingObserver] to forward every app lifecycle transition
/// reported by the Flutter engine onto a broadcast [Stream].
///
/// Call [dispose] when this instance is no longer needed so it is removed
/// from [WidgetsBinding]'s observer list.
class AppLifecycleServiceImpl extends WidgetsBindingObserver
    implements AppLifecycleService {
  AppLifecycleServiceImpl() {
    WidgetsBinding.instance.addObserver(this);
  }

  final StreamController<AppLifecycleState> _lifecycleChangesController =
      StreamController<AppLifecycleState>.broadcast();

  @override
  Stream<AppLifecycleState> get lifecycleChanges =>
      _lifecycleChangesController.stream;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleChangesController.add(state);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lifecycleChangesController.close();
  }
}
