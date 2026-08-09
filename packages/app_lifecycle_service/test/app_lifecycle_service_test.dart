import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_lifecycle_service/app_lifecycle_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLifecycleServiceImpl appLifecycleServiceImpl;

  setUp(() {
    appLifecycleServiceImpl = AppLifecycleServiceImpl();
  });

  tearDown(() {
    appLifecycleServiceImpl.dispose();
  });

  test(
    'emits each lifecycle transition on lifecycleChanges exactly once',
    () async {
      final List<AppLifecycleState> emittedLifecycleStates =
          <AppLifecycleState>[];
      final Stream<AppLifecycleState> broadcastLifecycleChanges =
          appLifecycleServiceImpl.lifecycleChanges;
      final StreamSubscription<AppLifecycleState> subscription =
          broadcastLifecycleChanges.listen(emittedLifecycleStates.add);

      const List<AppLifecycleState> transitionsToDrive = <AppLifecycleState>[
        AppLifecycleState.inactive,
        AppLifecycleState.paused,
        AppLifecycleState.resumed,
        AppLifecycleState.detached,
      ];

      for (final AppLifecycleState lifecycleState in transitionsToDrive) {
        appLifecycleServiceImpl.didChangeAppLifecycleState(lifecycleState);
      }

      await Future<void>.delayed(Duration.zero);
      await subscription.cancel();

      expect(emittedLifecycleStates, equals(transitionsToDrive));
    },
  );

  test(
    'lifecycleChanges is a stream exposed via the AppLifecycleService contract',
    () {
      final AppLifecycleService appLifecycleService = appLifecycleServiceImpl;

      expect(appLifecycleService.lifecycleChanges, isA<Stream<AppLifecycleState>>());
    },
  );
}
