import 'package:knowledge_hub/core/error/failure.dart';

/// Matches the exact wording `NotesLocalDataSourceImpl._selectNoteById`
/// throws (`'Note $noteId not found'`) so a not-found `CacheFailure` can be
/// distinguished from a genuine storage failure without a dedicated
/// `NotFoundFailure` type. Case-insensitive so the same check also covers
/// any future folder/tag "not found" wording that follows the same phrase.
final RegExp _notFoundCacheFailurePattern = RegExp('not found', caseSensitive: false);

/// Matches the exact wording `DuplicateNameException` carries from
/// `FoldersLocalDataSourceImpl.createFolder`/`TagsLocalDataSourceImpl.createTag`
/// (`'A folder named "$name" already exists'` / `'A tag named "$name"
/// already exists'`), capturing the noun and the attempted name so they can
/// be reformatted into the design.md-specified user-facing template.
final RegExp _duplicateNameFailurePattern = RegExp(
  '^A (folder|tag) named "(.+)" already exists\$',
);

const String _cacheFailureMessage =
    "We couldn't complete that action because of a local storage problem. "
    'Please try again in a moment — your notes are safe.';

/// design.md's Error Categories table (`.kiro/specs/notes-mvp/design.md`)
/// documents this exact string as the catchall for "any other/future
/// `Failure` subtype". `NetworkFailure` is not thrown anywhere in this
/// offline-only feature today (network support is deferred to v1.1) — a
/// pure "future" subtype this row anticipates. `ServerFailure` IS thrown
/// today, but only as `NotesRepositoryImpl`/`FoldersRepositoryImpl`/
/// `TagsRepositoryImpl`'s generic `catch (e)` fallback for an unexpected
/// (non-`CacheException`) local-storage exception — a reused generic type
/// rather than a genuine network/server failure, since this feature has no
/// server to fail against. Either way the message below never mentions
/// "server" or "network", so no network-related copy is ever shown to the
/// user (notes-mvp Requirement 8.2).
const String _catchAllFailureMessage =
    "We couldn't complete that action. Please try again — your notes are safe.";

/// Converts every known [Failure] subtype into a specific, actionable,
/// user-facing message. Never falls back to a generic "Something went
/// wrong." string. Exhaustive over the sealed [Failure] hierarchy, so
/// adding a new subtype without updating this function is a compile error.
String mapFailureToMessage(Failure failure) {
  return switch (failure) {
    CacheFailure() => _mapCacheFailureToMessage(failure),
    DuplicateNameFailure() => _mapDuplicateNameFailureToMessage(failure),
    ServerFailure() => _catchAllFailureMessage,
    NetworkFailure() => _catchAllFailureMessage,
    ValidationFailure() => failure.message,
  };
}

String _mapCacheFailureToMessage(CacheFailure failure) {
  if (_notFoundCacheFailurePattern.hasMatch(failure.message)) {
    // The desired end state ("item is gone") is already true -- treated as
    // a silent no-op refresh, per design.md's Error Categories table.
    return '';
  }
  return _cacheFailureMessage;
}

String _mapDuplicateNameFailureToMessage(DuplicateNameFailure failure) {
  final RegExpMatch? match = _duplicateNameFailurePattern.firstMatch(failure.message);
  if (match == null) {
    return '${failure.message} — choose a different name.';
  }
  final String kind = match.group(1)!;
  final String attemptedName = match.group(2)!;
  return 'A $kind named "$attemptedName" already exists — choose a different name.';
}
