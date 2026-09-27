// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_editor_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteEditorViewModel {

 String get noteId; String get title; String get body; String? get folderId; List<String> get tagIds;
/// Create a copy of NoteEditorViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorViewModelCopyWith<NoteEditorViewModel> get copyWith => _$NoteEditorViewModelCopyWithImpl<NoteEditorViewModel>(this as NoteEditorViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other.tagIds, tagIds));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,body,folderId,const DeepCollectionEquality().hash(tagIds));

@override
String toString() {
  return 'NoteEditorViewModel(noteId: $noteId, title: $title, body: $body, folderId: $folderId, tagIds: $tagIds)';
}


}

/// @nodoc
abstract mixin class $NoteEditorViewModelCopyWith<$Res>  {
  factory $NoteEditorViewModelCopyWith(NoteEditorViewModel value, $Res Function(NoteEditorViewModel) _then) = _$NoteEditorViewModelCopyWithImpl;
@useResult
$Res call({
 String noteId, String title, String body, String? folderId, List<String> tagIds
});




}
/// @nodoc
class _$NoteEditorViewModelCopyWithImpl<$Res>
    implements $NoteEditorViewModelCopyWith<$Res> {
  _$NoteEditorViewModelCopyWithImpl(this._self, this._then);

  final NoteEditorViewModel _self;
  final $Res Function(NoteEditorViewModel) _then;

/// Create a copy of NoteEditorViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? title = null,Object? body = null,Object? folderId = freezed,Object? tagIds = null,}) {
  return _then(_self.copyWith(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteEditorViewModel].
extension NoteEditorViewModelPatterns on NoteEditorViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteEditorViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteEditorViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteEditorViewModel value)  $default,){
final _that = this;
switch (_that) {
case _NoteEditorViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteEditorViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _NoteEditorViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String noteId,  String title,  String body,  String? folderId,  List<String> tagIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteEditorViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.body,_that.folderId,_that.tagIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String noteId,  String title,  String body,  String? folderId,  List<String> tagIds)  $default,) {final _that = this;
switch (_that) {
case _NoteEditorViewModel():
return $default(_that.noteId,_that.title,_that.body,_that.folderId,_that.tagIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String noteId,  String title,  String body,  String? folderId,  List<String> tagIds)?  $default,) {final _that = this;
switch (_that) {
case _NoteEditorViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.body,_that.folderId,_that.tagIds);case _:
  return null;

}
}

}

/// @nodoc


class _NoteEditorViewModel implements NoteEditorViewModel {
  const _NoteEditorViewModel({required this.noteId, required this.title, required this.body, this.folderId, final  List<String> tagIds = const <String>[]}): _tagIds = tagIds;
  

@override final  String noteId;
@override final  String title;
@override final  String body;
@override final  String? folderId;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}


/// Create a copy of NoteEditorViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteEditorViewModelCopyWith<_NoteEditorViewModel> get copyWith => __$NoteEditorViewModelCopyWithImpl<_NoteEditorViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteEditorViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,body,folderId,const DeepCollectionEquality().hash(_tagIds));

@override
String toString() {
  return 'NoteEditorViewModel(noteId: $noteId, title: $title, body: $body, folderId: $folderId, tagIds: $tagIds)';
}


}

/// @nodoc
abstract mixin class _$NoteEditorViewModelCopyWith<$Res> implements $NoteEditorViewModelCopyWith<$Res> {
  factory _$NoteEditorViewModelCopyWith(_NoteEditorViewModel value, $Res Function(_NoteEditorViewModel) _then) = __$NoteEditorViewModelCopyWithImpl;
@override @useResult
$Res call({
 String noteId, String title, String body, String? folderId, List<String> tagIds
});




}
/// @nodoc
class __$NoteEditorViewModelCopyWithImpl<$Res>
    implements _$NoteEditorViewModelCopyWith<$Res> {
  __$NoteEditorViewModelCopyWithImpl(this._self, this._then);

  final _NoteEditorViewModel _self;
  final $Res Function(_NoteEditorViewModel) _then;

/// Create a copy of NoteEditorViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? title = null,Object? body = null,Object? folderId = freezed,Object? tagIds = null,}) {
  return _then(_NoteEditorViewModel(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
