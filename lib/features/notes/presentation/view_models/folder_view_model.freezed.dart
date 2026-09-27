// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FolderViewModel {

 String get folderId; String get name;
/// Create a copy of FolderViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderViewModelCopyWith<FolderViewModel> get copyWith => _$FolderViewModelCopyWithImpl<FolderViewModel>(this as FolderViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderViewModel&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,folderId,name);

@override
String toString() {
  return 'FolderViewModel(folderId: $folderId, name: $name)';
}


}

/// @nodoc
abstract mixin class $FolderViewModelCopyWith<$Res>  {
  factory $FolderViewModelCopyWith(FolderViewModel value, $Res Function(FolderViewModel) _then) = _$FolderViewModelCopyWithImpl;
@useResult
$Res call({
 String folderId, String name
});




}
/// @nodoc
class _$FolderViewModelCopyWithImpl<$Res>
    implements $FolderViewModelCopyWith<$Res> {
  _$FolderViewModelCopyWithImpl(this._self, this._then);

  final FolderViewModel _self;
  final $Res Function(FolderViewModel) _then;

/// Create a copy of FolderViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderId = null,Object? name = null,}) {
  return _then(_self.copyWith(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FolderViewModel].
extension FolderViewModelPatterns on FolderViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FolderViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FolderViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FolderViewModel value)  $default,){
final _that = this;
switch (_that) {
case _FolderViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FolderViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _FolderViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String folderId,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FolderViewModel() when $default != null:
return $default(_that.folderId,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String folderId,  String name)  $default,) {final _that = this;
switch (_that) {
case _FolderViewModel():
return $default(_that.folderId,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String folderId,  String name)?  $default,) {final _that = this;
switch (_that) {
case _FolderViewModel() when $default != null:
return $default(_that.folderId,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _FolderViewModel implements FolderViewModel {
  const _FolderViewModel({required this.folderId, required this.name});
  

@override final  String folderId;
@override final  String name;

/// Create a copy of FolderViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FolderViewModelCopyWith<_FolderViewModel> get copyWith => __$FolderViewModelCopyWithImpl<_FolderViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FolderViewModel&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,folderId,name);

@override
String toString() {
  return 'FolderViewModel(folderId: $folderId, name: $name)';
}


}

/// @nodoc
abstract mixin class _$FolderViewModelCopyWith<$Res> implements $FolderViewModelCopyWith<$Res> {
  factory _$FolderViewModelCopyWith(_FolderViewModel value, $Res Function(_FolderViewModel) _then) = __$FolderViewModelCopyWithImpl;
@override @useResult
$Res call({
 String folderId, String name
});




}
/// @nodoc
class __$FolderViewModelCopyWithImpl<$Res>
    implements _$FolderViewModelCopyWith<$Res> {
  __$FolderViewModelCopyWithImpl(this._self, this._then);

  final _FolderViewModel _self;
  final $Res Function(_FolderViewModel) _then;

/// Create a copy of FolderViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderId = null,Object? name = null,}) {
  return _then(_FolderViewModel(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
