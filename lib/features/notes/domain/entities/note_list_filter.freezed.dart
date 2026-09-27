// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_list_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteListFilterParams {

 String? get folderId; List<String> get tagIds; TagFilterMode get tagFilterMode; NoteLifecycleScope get lifecycleScope;
/// Create a copy of NoteListFilterParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteListFilterParamsCopyWith<NoteListFilterParams> get copyWith => _$NoteListFilterParamsCopyWithImpl<NoteListFilterParams>(this as NoteListFilterParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteListFilterParams&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other.tagIds, tagIds)&&(identical(other.tagFilterMode, tagFilterMode) || other.tagFilterMode == tagFilterMode)&&(identical(other.lifecycleScope, lifecycleScope) || other.lifecycleScope == lifecycleScope));
}


@override
int get hashCode => Object.hash(runtimeType,folderId,const DeepCollectionEquality().hash(tagIds),tagFilterMode,lifecycleScope);

@override
String toString() {
  return 'NoteListFilterParams(folderId: $folderId, tagIds: $tagIds, tagFilterMode: $tagFilterMode, lifecycleScope: $lifecycleScope)';
}


}

/// @nodoc
abstract mixin class $NoteListFilterParamsCopyWith<$Res>  {
  factory $NoteListFilterParamsCopyWith(NoteListFilterParams value, $Res Function(NoteListFilterParams) _then) = _$NoteListFilterParamsCopyWithImpl;
@useResult
$Res call({
 String? folderId, List<String> tagIds, TagFilterMode tagFilterMode, NoteLifecycleScope lifecycleScope
});




}
/// @nodoc
class _$NoteListFilterParamsCopyWithImpl<$Res>
    implements $NoteListFilterParamsCopyWith<$Res> {
  _$NoteListFilterParamsCopyWithImpl(this._self, this._then);

  final NoteListFilterParams _self;
  final $Res Function(NoteListFilterParams) _then;

/// Create a copy of NoteListFilterParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderId = freezed,Object? tagIds = null,Object? tagFilterMode = null,Object? lifecycleScope = null,}) {
  return _then(_self.copyWith(
folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,tagFilterMode: null == tagFilterMode ? _self.tagFilterMode : tagFilterMode // ignore: cast_nullable_to_non_nullable
as TagFilterMode,lifecycleScope: null == lifecycleScope ? _self.lifecycleScope : lifecycleScope // ignore: cast_nullable_to_non_nullable
as NoteLifecycleScope,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteListFilterParams].
extension NoteListFilterParamsPatterns on NoteListFilterParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteListFilterParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteListFilterParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteListFilterParams value)  $default,){
final _that = this;
switch (_that) {
case _NoteListFilterParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteListFilterParams value)?  $default,){
final _that = this;
switch (_that) {
case _NoteListFilterParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? folderId,  List<String> tagIds,  TagFilterMode tagFilterMode,  NoteLifecycleScope lifecycleScope)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteListFilterParams() when $default != null:
return $default(_that.folderId,_that.tagIds,_that.tagFilterMode,_that.lifecycleScope);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? folderId,  List<String> tagIds,  TagFilterMode tagFilterMode,  NoteLifecycleScope lifecycleScope)  $default,) {final _that = this;
switch (_that) {
case _NoteListFilterParams():
return $default(_that.folderId,_that.tagIds,_that.tagFilterMode,_that.lifecycleScope);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? folderId,  List<String> tagIds,  TagFilterMode tagFilterMode,  NoteLifecycleScope lifecycleScope)?  $default,) {final _that = this;
switch (_that) {
case _NoteListFilterParams() when $default != null:
return $default(_that.folderId,_that.tagIds,_that.tagFilterMode,_that.lifecycleScope);case _:
  return null;

}
}

}

/// @nodoc


class _NoteListFilterParams implements NoteListFilterParams {
  const _NoteListFilterParams({this.folderId, final  List<String> tagIds = const <String>[], this.tagFilterMode = TagFilterMode.anyOf, this.lifecycleScope = NoteLifecycleScope.active}): _tagIds = tagIds;
  

@override final  String? folderId;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}

@override@JsonKey() final  TagFilterMode tagFilterMode;
@override@JsonKey() final  NoteLifecycleScope lifecycleScope;

/// Create a copy of NoteListFilterParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteListFilterParamsCopyWith<_NoteListFilterParams> get copyWith => __$NoteListFilterParamsCopyWithImpl<_NoteListFilterParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteListFilterParams&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds)&&(identical(other.tagFilterMode, tagFilterMode) || other.tagFilterMode == tagFilterMode)&&(identical(other.lifecycleScope, lifecycleScope) || other.lifecycleScope == lifecycleScope));
}


@override
int get hashCode => Object.hash(runtimeType,folderId,const DeepCollectionEquality().hash(_tagIds),tagFilterMode,lifecycleScope);

@override
String toString() {
  return 'NoteListFilterParams(folderId: $folderId, tagIds: $tagIds, tagFilterMode: $tagFilterMode, lifecycleScope: $lifecycleScope)';
}


}

/// @nodoc
abstract mixin class _$NoteListFilterParamsCopyWith<$Res> implements $NoteListFilterParamsCopyWith<$Res> {
  factory _$NoteListFilterParamsCopyWith(_NoteListFilterParams value, $Res Function(_NoteListFilterParams) _then) = __$NoteListFilterParamsCopyWithImpl;
@override @useResult
$Res call({
 String? folderId, List<String> tagIds, TagFilterMode tagFilterMode, NoteLifecycleScope lifecycleScope
});




}
/// @nodoc
class __$NoteListFilterParamsCopyWithImpl<$Res>
    implements _$NoteListFilterParamsCopyWith<$Res> {
  __$NoteListFilterParamsCopyWithImpl(this._self, this._then);

  final _NoteListFilterParams _self;
  final $Res Function(_NoteListFilterParams) _then;

/// Create a copy of NoteListFilterParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderId = freezed,Object? tagIds = null,Object? tagFilterMode = null,Object? lifecycleScope = null,}) {
  return _then(_NoteListFilterParams(
folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,tagFilterMode: null == tagFilterMode ? _self.tagFilterMode : tagFilterMode // ignore: cast_nullable_to_non_nullable
as TagFilterMode,lifecycleScope: null == lifecycleScope ? _self.lifecycleScope : lifecycleScope // ignore: cast_nullable_to_non_nullable
as NoteLifecycleScope,
  ));
}


}

// dart format on
