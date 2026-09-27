import 'package:flutter/widgets.dart';

/// Exposes app lifecycle transitions as a stream, so a Bloc can react to
/// foreground/background/detached transitions without ever receiving a
/// `BuildContext`.
abstract class AppLifecycleService {
  Stream<AppLifecycleState> get lifecycleChanges;
}
