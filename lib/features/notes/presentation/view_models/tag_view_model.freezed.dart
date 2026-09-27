// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TagViewModel {

 String get tagId; String get name;
/// Create a copy of TagViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagViewModelCopyWith<TagViewModel> get copyWith => _$TagViewModelCopyWithImpl<TagViewModel>(this as TagViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagViewModel&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,tagId,name);

@override
String toString() {
  return 'TagViewModel(tagId: $tagId, name: $name)';
}


}

/// @nodoc
abstract mixin class $TagViewModelCopyWith<$Res>  {
  factory $TagViewModelCopyWith(TagViewModel value, $Res Function(TagViewModel) _then) = _$TagViewModelCopyWithImpl;
@useResult
$Res call({
 String tagId, String name
});




}
/// @nodoc
class _$TagViewModelCopyWithImpl<$Res>
    implements $TagViewModelCopyWith<$Res> {
  _$TagViewModelCopyWithImpl(this._self, this._then);

  final TagViewModel _self;
  final $Res Function(TagViewModel) _then;

/// Create a copy of TagViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagId = null,Object? name = null,}) {
  return _then(_self.copyWith(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TagViewModel].
extension TagViewModelPatterns on TagViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagViewModel value)  $default,){
final _that = this;
switch (_that) {
case _TagViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _TagViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tagId,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagViewModel() when $default != null:
return $default(_that.tagId,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tagId,  String name)  $default,) {final _that = this;
switch (_that) {
case _TagViewModel():
return $default(_that.tagId,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tagId,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TagViewModel() when $default != null:
return $default(_that.tagId,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _TagViewModel implements TagViewModel {
  const _TagViewModel({required this.tagId, required this.name});
  

@override final  String tagId;
@override final  String name;

/// Create a copy of TagViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagViewModelCopyWith<_TagViewModel> get copyWith => __$TagViewModelCopyWithImpl<_TagViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagViewModel&&(identical(other.tagId, tagId) || other.tagId == tagId)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,tagId,name);

@override
String toString() {
  return 'TagViewModel(tagId: $tagId, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TagViewModelCopyWith<$Res> implements $TagViewModelCopyWith<$Res> {
  factory _$TagViewModelCopyWith(_TagViewModel value, $Res Function(_TagViewModel) _then) = __$TagViewModelCopyWithImpl;
@override @useResult
$Res call({
 String tagId, String name
});




}
/// @nodoc
class __$TagViewModelCopyWithImpl<$Res>
    implements _$TagViewModelCopyWith<$Res> {
  __$TagViewModelCopyWithImpl(this._self, this._then);

  final _TagViewModel _self;
  final $Res Function(_TagViewModel) _then;

/// Create a copy of TagViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagId = null,Object? name = null,}) {
  return _then(_TagViewModel(
tagId: null == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
