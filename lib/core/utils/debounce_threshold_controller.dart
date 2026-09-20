import 'dart:async';

/// A reusable, per-field debounce controller with a character-count
/// threshold override.
///
/// Behaviour:
/// - While `currentCount < threshold`, calls are debounced (only the last
///   call within [debounceDuration] actually executes).
/// - Once `currentCount >= threshold`, execution is forced immediately,
///   bypassing the debounce delay.
/// - On a successful forced execution, the threshold jumps to
///   `currentCount + thresholdStep` (not a fixed grid — it tracks from
///   wherever the success happened).
/// - On a failed forced execution, the threshold is left unchanged, so the
///   very next event (regardless of debounce) forces execution again.
///
/// One instance = one independent threshold/debounce timeline. If a single
/// BLoC has multiple fields/handlers that each need this behaviour, create
/// one controller per field (see [DebounceThresholdRegistry] below for a
/// keyed variant).
class DebounceThresholdController {
  DebounceThresholdController({
    this.thresholdStep = 300,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : _nextThreshold = thresholdStep;

  /// How far past a successful force-execution the next threshold is set.
  final int thresholdStep;

  /// Delay used for the "normal" (below-threshold) debounced path.
  final Duration debounceDuration;

  /// The character count at which the next force-execution kicks in.
  int _nextThreshold;

  /// Exposed for logging/inspection if you need it.
  int get nextThreshold => _nextThreshold;

  int _currentCount = 0;
  int get currentCount => _currentCount;

  // Used to invalidate stale debounced calls when a newer event arrives.
  int _generation = 0;

  bool _disposed = false;

  /// Call this from inside your (async) BLoC event handler.
  ///
  /// [currentCount] — the character count carried by the incoming event.
  /// [execute] — the actual action to run (e.g. hit a repository/save
  ///   method). Must return `true` on success, `false` on failure — this
  ///   drives whether the threshold advances.
  ///
  /// Must be awaited from the event handler so `emit` (if used inside
  /// [execute]) remains valid for the whole debounce/force lifecycle.
  Future<void> run({
    required int currentCount,
    required Future<bool> Function() execute,
  }) async {
    _currentCount = currentCount;

    if (currentCount >= _nextThreshold) {
      // Force path: bypass debounce entirely, cancel any pending debounced
      // call by bumping the generation.
      _generation++;
      final success = await execute();
      if (_disposed) return;
      if (success) {
        _nextThreshold = currentCount + thresholdStep;
      }
      // else: leave _nextThreshold as-is so the next event forces again.
      return;
    }

    // Debounce path.
    final int myGeneration = ++_generation;
    await Future.delayed(debounceDuration);
    if (_disposed || myGeneration != _generation) {
      // A newer event (debounced or forced) superseded this one.
      return;
    }
    await execute();
  }

  /// Call from the BLoC's `close()` to invalidate any in-flight debounced
  /// call so it doesn't try to run (or emit) after teardown.
  void dispose() {
    _disposed = true;
    _generation++;
  }
}

/// Convenience wrapper when one BLoC needs this behaviour for *several*
/// independent fields (e.g. title, description, notes — each with its own
/// character count and threshold timeline) without hand-rolling a map of
/// controllers in every BLoC.
class DebounceThresholdRegistry {
  DebounceThresholdRegistry({
    this.thresholdStep = 300,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  final int thresholdStep;
  final Duration debounceDuration;

  final Map<Object, DebounceThresholdController> _controllers = {};

  /// [key] identifies the field/handler (e.g. an enum, a string, the event
  /// type). A controller is created lazily on first use.
  Future<void> run({
    required Object key,
    required int currentCount,
    required Future<bool> Function() execute,
  }) {
    final controller = _controllers.putIfAbsent(
      key,
      () => DebounceThresholdController(
        thresholdStep: thresholdStep,
        debounceDuration: debounceDuration,
      ),
    );
    return controller.run(currentCount: currentCount, execute: execute);
  }

  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
  }
}
