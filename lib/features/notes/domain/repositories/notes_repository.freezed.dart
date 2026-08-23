// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaveNoteContentParams {

 String get noteId; String get title; String get body;
/// Create a copy of SaveNoteContentParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveNoteContentParamsCopyWith<SaveNoteContentParams> get copyWith => _$SaveNoteContentParamsCopyWithImpl<SaveNoteContentParams>(this as SaveNoteContentParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveNoteContentParams&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,body);

@override
String toString() {
  return 'SaveNoteContentParams(noteId: $noteId, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class $SaveNoteContentParamsCopyWith<$Res>  {
  factory $SaveNoteContentParamsCopyWith(SaveNoteContentParams value, $Res Function(SaveNoteContentParams) _then) = _$SaveNoteContentParamsCopyWithImpl;
@useResult
$Res call({
 String noteId, String title, String body
});




}
/// @nodoc
class _$SaveNoteContentParamsCopyWithImpl<$Res>
    implements $SaveNoteContentParamsCopyWith<$Res> {
  _$SaveNoteContentParamsCopyWithImpl(this._self, this._then);

  final SaveNoteContentParams _self;
  final $Res Function(SaveNoteContentParams) _then;

/// Create a copy of SaveNoteContentParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? title = null,Object? body = null,}) {
  return _then(_self.copyWith(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveNoteContentParams].
extension SaveNoteContentParamsPatterns on SaveNoteContentParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveNoteContentParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveNoteContentParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveNoteContentParams value)  $default,){
final _that = this;
switch (_that) {
case _SaveNoteContentParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveNoteContentParams value)?  $default,){
final _that = this;
switch (_that) {
case _SaveNoteContentParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String noteId,  String title,  String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveNoteContentParams() when $default != null:
return $default(_that.noteId,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String noteId,  String title,  String body)  $default,) {final _that = this;
switch (_that) {
case _SaveNoteContentParams():
return $default(_that.noteId,_that.title,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String noteId,  String title,  String body)?  $default,) {final _that = this;
switch (_that) {
case _SaveNoteContentParams() when $default != null:
return $default(_that.noteId,_that.title,_that.body);case _:
  return null;

}
}

}

/// @nodoc


class _SaveNoteContentParams implements SaveNoteContentParams {
  const _SaveNoteContentParams({required this.noteId, required this.title, required this.body});
  

@override final  String noteId;
@override final  String title;
@override final  String body;

/// Create a copy of SaveNoteContentParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveNoteContentParamsCopyWith<_SaveNoteContentParams> get copyWith => __$SaveNoteContentParamsCopyWithImpl<_SaveNoteContentParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveNoteContentParams&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,body);

@override
String toString() {
  return 'SaveNoteContentParams(noteId: $noteId, title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$SaveNoteContentParamsCopyWith<$Res> implements $SaveNoteContentParamsCopyWith<$Res> {
  factory _$SaveNoteContentParamsCopyWith(_SaveNoteContentParams value, $Res Function(_SaveNoteContentParams) _then) = __$SaveNoteContentParamsCopyWithImpl;
@override @useResult
$Res call({
 String noteId, String title, String body
});




}
/// @nodoc
class __$SaveNoteContentParamsCopyWithImpl<$Res>
    implements _$SaveNoteContentParamsCopyWith<$Res> {
  __$SaveNoteContentParamsCopyWithImpl(this._self, this._then);

  final _SaveNoteContentParams _self;
  final $Res Function(_SaveNoteContentParams) _then;

/// Create a copy of SaveNoteContentParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? title = null,Object? body = null,}) {
  return _then(_SaveNoteContentParams(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
