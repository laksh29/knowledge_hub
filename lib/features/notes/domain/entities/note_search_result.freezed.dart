// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteSearchResult {

 Note get note; String get highlightedTitleSnippet; String get highlightedBodySnippet;
/// Create a copy of NoteSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteSearchResultCopyWith<NoteSearchResult> get copyWith => _$NoteSearchResultCopyWithImpl<NoteSearchResult>(this as NoteSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteSearchResult&&(identical(other.note, note) || other.note == note)&&(identical(other.highlightedTitleSnippet, highlightedTitleSnippet) || other.highlightedTitleSnippet == highlightedTitleSnippet)&&(identical(other.highlightedBodySnippet, highlightedBodySnippet) || other.highlightedBodySnippet == highlightedBodySnippet));
}


@override
int get hashCode => Object.hash(runtimeType,note,highlightedTitleSnippet,highlightedBodySnippet);

@override
String toString() {
  return 'NoteSearchResult(note: $note, highlightedTitleSnippet: $highlightedTitleSnippet, highlightedBodySnippet: $highlightedBodySnippet)';
}


}

/// @nodoc
abstract mixin class $NoteSearchResultCopyWith<$Res>  {
  factory $NoteSearchResultCopyWith(NoteSearchResult value, $Res Function(NoteSearchResult) _then) = _$NoteSearchResultCopyWithImpl;
@useResult
$Res call({
 Note note, String highlightedTitleSnippet, String highlightedBodySnippet
});


$NoteCopyWith<$Res> get note;

}
/// @nodoc
class _$NoteSearchResultCopyWithImpl<$Res>
    implements $NoteSearchResultCopyWith<$Res> {
  _$NoteSearchResultCopyWithImpl(this._self, this._then);

  final NoteSearchResult _self;
  final $Res Function(NoteSearchResult) _then;

/// Create a copy of NoteSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? note = null,Object? highlightedTitleSnippet = null,Object? highlightedBodySnippet = null,}) {
  return _then(_self.copyWith(
note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as Note,highlightedTitleSnippet: null == highlightedTitleSnippet ? _self.highlightedTitleSnippet : highlightedTitleSnippet // ignore: cast_nullable_to_non_nullable
as String,highlightedBodySnippet: null == highlightedBodySnippet ? _self.highlightedBodySnippet : highlightedBodySnippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of NoteSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCopyWith<$Res> get note {
  
  return $NoteCopyWith<$Res>(_self.note, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoteSearchResult].
extension NoteSearchResultPatterns on NoteSearchResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteSearchResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _NoteSearchResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _NoteSearchResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Note note,  String highlightedTitleSnippet,  String highlightedBodySnippet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteSearchResult() when $default != null:
return $default(_that.note,_that.highlightedTitleSnippet,_that.highlightedBodySnippet);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Note note,  String highlightedTitleSnippet,  String highlightedBodySnippet)  $default,) {final _that = this;
switch (_that) {
case _NoteSearchResult():
return $default(_that.note,_that.highlightedTitleSnippet,_that.highlightedBodySnippet);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Note note,  String highlightedTitleSnippet,  String highlightedBodySnippet)?  $default,) {final _that = this;
switch (_that) {
case _NoteSearchResult() when $default != null:
return $default(_that.note,_that.highlightedTitleSnippet,_that.highlightedBodySnippet);case _:
  return null;

}
}

}

/// @nodoc


class _NoteSearchResult implements NoteSearchResult {
  const _NoteSearchResult({required this.note, required this.highlightedTitleSnippet, required this.highlightedBodySnippet});
  

@override final  Note note;
@override final  String highlightedTitleSnippet;
@override final  String highlightedBodySnippet;

/// Create a copy of NoteSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteSearchResultCopyWith<_NoteSearchResult> get copyWith => __$NoteSearchResultCopyWithImpl<_NoteSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteSearchResult&&(identical(other.note, note) || other.note == note)&&(identical(other.highlightedTitleSnippet, highlightedTitleSnippet) || other.highlightedTitleSnippet == highlightedTitleSnippet)&&(identical(other.highlightedBodySnippet, highlightedBodySnippet) || other.highlightedBodySnippet == highlightedBodySnippet));
}


@override
int get hashCode => Object.hash(runtimeType,note,highlightedTitleSnippet,highlightedBodySnippet);

@override
String toString() {
  return 'NoteSearchResult(note: $note, highlightedTitleSnippet: $highlightedTitleSnippet, highlightedBodySnippet: $highlightedBodySnippet)';
}


}

/// @nodoc
abstract mixin class _$NoteSearchResultCopyWith<$Res> implements $NoteSearchResultCopyWith<$Res> {
  factory _$NoteSearchResultCopyWith(_NoteSearchResult value, $Res Function(_NoteSearchResult) _then) = __$NoteSearchResultCopyWithImpl;
@override @useResult
$Res call({
 Note note, String highlightedTitleSnippet, String highlightedBodySnippet
});


@override $NoteCopyWith<$Res> get note;

}
/// @nodoc
class __$NoteSearchResultCopyWithImpl<$Res>
    implements _$NoteSearchResultCopyWith<$Res> {
  __$NoteSearchResultCopyWithImpl(this._self, this._then);

  final _NoteSearchResult _self;
  final $Res Function(_NoteSearchResult) _then;

/// Create a copy of NoteSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? note = null,Object? highlightedTitleSnippet = null,Object? highlightedBodySnippet = null,}) {
  return _then(_NoteSearchResult(
note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as Note,highlightedTitleSnippet: null == highlightedTitleSnippet ? _self.highlightedTitleSnippet : highlightedTitleSnippet // ignore: cast_nullable_to_non_nullable
as String,highlightedBodySnippet: null == highlightedBodySnippet ? _self.highlightedBodySnippet : highlightedBodySnippet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of NoteSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCopyWith<$Res> get note {
  
  return $NoteCopyWith<$Res>(_self.note, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}

// dart format on
