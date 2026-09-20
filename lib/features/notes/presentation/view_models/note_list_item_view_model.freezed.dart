// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_list_item_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteListItemViewModel {

 String get noteId; String get title; String get bodyPreview; String? get folderId; List<String> get tagIds; DateTime get updatedAt;
/// Create a copy of NoteListItemViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteListItemViewModelCopyWith<NoteListItemViewModel> get copyWith => _$NoteListItemViewModelCopyWithImpl<NoteListItemViewModel>(this as NoteListItemViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteListItemViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.bodyPreview, bodyPreview) || other.bodyPreview == bodyPreview)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other.tagIds, tagIds)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,bodyPreview,folderId,const DeepCollectionEquality().hash(tagIds),updatedAt);

@override
String toString() {
  return 'NoteListItemViewModel(noteId: $noteId, title: $title, bodyPreview: $bodyPreview, folderId: $folderId, tagIds: $tagIds, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NoteListItemViewModelCopyWith<$Res>  {
  factory $NoteListItemViewModelCopyWith(NoteListItemViewModel value, $Res Function(NoteListItemViewModel) _then) = _$NoteListItemViewModelCopyWithImpl;
@useResult
$Res call({
 String noteId, String title, String bodyPreview, String? folderId, List<String> tagIds, DateTime updatedAt
});




}
/// @nodoc
class _$NoteListItemViewModelCopyWithImpl<$Res>
    implements $NoteListItemViewModelCopyWith<$Res> {
  _$NoteListItemViewModelCopyWithImpl(this._self, this._then);

  final NoteListItemViewModel _self;
  final $Res Function(NoteListItemViewModel) _then;

/// Create a copy of NoteListItemViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? title = null,Object? bodyPreview = null,Object? folderId = freezed,Object? tagIds = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,bodyPreview: null == bodyPreview ? _self.bodyPreview : bodyPreview // ignore: cast_nullable_to_non_nullable
as String,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteListItemViewModel].
extension NoteListItemViewModelPatterns on NoteListItemViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteListItemViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteListItemViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteListItemViewModel value)  $default,){
final _that = this;
switch (_that) {
case _NoteListItemViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteListItemViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _NoteListItemViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String noteId,  String title,  String bodyPreview,  String? folderId,  List<String> tagIds,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteListItemViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.bodyPreview,_that.folderId,_that.tagIds,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String noteId,  String title,  String bodyPreview,  String? folderId,  List<String> tagIds,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NoteListItemViewModel():
return $default(_that.noteId,_that.title,_that.bodyPreview,_that.folderId,_that.tagIds,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String noteId,  String title,  String bodyPreview,  String? folderId,  List<String> tagIds,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NoteListItemViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.bodyPreview,_that.folderId,_that.tagIds,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _NoteListItemViewModel implements NoteListItemViewModel {
  const _NoteListItemViewModel({required this.noteId, required this.title, required this.bodyPreview, this.folderId, final  List<String> tagIds = const <String>[], required this.updatedAt}): _tagIds = tagIds;
  

@override final  String noteId;
@override final  String title;
@override final  String bodyPreview;
@override final  String? folderId;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}

@override final  DateTime updatedAt;

/// Create a copy of NoteListItemViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteListItemViewModelCopyWith<_NoteListItemViewModel> get copyWith => __$NoteListItemViewModelCopyWithImpl<_NoteListItemViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteListItemViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.bodyPreview, bodyPreview) || other.bodyPreview == bodyPreview)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,bodyPreview,folderId,const DeepCollectionEquality().hash(_tagIds),updatedAt);

@override
String toString() {
  return 'NoteListItemViewModel(noteId: $noteId, title: $title, bodyPreview: $bodyPreview, folderId: $folderId, tagIds: $tagIds, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NoteListItemViewModelCopyWith<$Res> implements $NoteListItemViewModelCopyWith<$Res> {
  factory _$NoteListItemViewModelCopyWith(_NoteListItemViewModel value, $Res Function(_NoteListItemViewModel) _then) = __$NoteListItemViewModelCopyWithImpl;
@override @useResult
$Res call({
 String noteId, String title, String bodyPreview, String? folderId, List<String> tagIds, DateTime updatedAt
});




}
/// @nodoc
class __$NoteListItemViewModelCopyWithImpl<$Res>
    implements _$NoteListItemViewModelCopyWith<$Res> {
  __$NoteListItemViewModelCopyWithImpl(this._self, this._then);

  final _NoteListItemViewModel _self;
  final $Res Function(_NoteListItemViewModel) _then;

/// Create a copy of NoteListItemViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? title = null,Object? bodyPreview = null,Object? folderId = freezed,Object? tagIds = null,Object? updatedAt = null,}) {
  return _then(_NoteListItemViewModel(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,bodyPreview: null == bodyPreview ? _self.bodyPreview : bodyPreview // ignore: cast_nullable_to_non_nullable
as String,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
