// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trashed_note_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrashedNoteViewModel {

 String get noteId; String get title; DateTime get deletedAt;
/// Create a copy of TrashedNoteViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrashedNoteViewModelCopyWith<TrashedNoteViewModel> get copyWith => _$TrashedNoteViewModelCopyWithImpl<TrashedNoteViewModel>(this as TrashedNoteViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashedNoteViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,deletedAt);

@override
String toString() {
  return 'TrashedNoteViewModel(noteId: $noteId, title: $title, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $TrashedNoteViewModelCopyWith<$Res>  {
  factory $TrashedNoteViewModelCopyWith(TrashedNoteViewModel value, $Res Function(TrashedNoteViewModel) _then) = _$TrashedNoteViewModelCopyWithImpl;
@useResult
$Res call({
 String noteId, String title, DateTime deletedAt
});




}
/// @nodoc
class _$TrashedNoteViewModelCopyWithImpl<$Res>
    implements $TrashedNoteViewModelCopyWith<$Res> {
  _$TrashedNoteViewModelCopyWithImpl(this._self, this._then);

  final TrashedNoteViewModel _self;
  final $Res Function(TrashedNoteViewModel) _then;

/// Create a copy of TrashedNoteViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? title = null,Object? deletedAt = null,}) {
  return _then(_self.copyWith(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TrashedNoteViewModel].
extension TrashedNoteViewModelPatterns on TrashedNoteViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrashedNoteViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrashedNoteViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrashedNoteViewModel value)  $default,){
final _that = this;
switch (_that) {
case _TrashedNoteViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrashedNoteViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrashedNoteViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String noteId,  String title,  DateTime deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrashedNoteViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String noteId,  String title,  DateTime deletedAt)  $default,) {final _that = this;
switch (_that) {
case _TrashedNoteViewModel():
return $default(_that.noteId,_that.title,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String noteId,  String title,  DateTime deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _TrashedNoteViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TrashedNoteViewModel extends TrashedNoteViewModel {
  const _TrashedNoteViewModel({required this.noteId, required this.title, required this.deletedAt}): super._();
  

@override final  String noteId;
@override final  String title;
@override final  DateTime deletedAt;

/// Create a copy of TrashedNoteViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrashedNoteViewModelCopyWith<_TrashedNoteViewModel> get copyWith => __$TrashedNoteViewModelCopyWithImpl<_TrashedNoteViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrashedNoteViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,deletedAt);

@override
String toString() {
  return 'TrashedNoteViewModel(noteId: $noteId, title: $title, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$TrashedNoteViewModelCopyWith<$Res> implements $TrashedNoteViewModelCopyWith<$Res> {
  factory _$TrashedNoteViewModelCopyWith(_TrashedNoteViewModel value, $Res Function(_TrashedNoteViewModel) _then) = __$TrashedNoteViewModelCopyWithImpl;
@override @useResult
$Res call({
 String noteId, String title, DateTime deletedAt
});




}
/// @nodoc
class __$TrashedNoteViewModelCopyWithImpl<$Res>
    implements _$TrashedNoteViewModelCopyWith<$Res> {
  __$TrashedNoteViewModelCopyWithImpl(this._self, this._then);

  final _TrashedNoteViewModel _self;
  final $Res Function(_TrashedNoteViewModel) _then;

/// Create a copy of TrashedNoteViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? title = null,Object? deletedAt = null,}) {
  return _then(_TrashedNoteViewModel(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,deletedAt: null == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
