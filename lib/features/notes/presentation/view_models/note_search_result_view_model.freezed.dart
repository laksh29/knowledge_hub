// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_search_result_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteSearchResultViewModel {

 String get noteId; String get title; String get highlightedTitleSnippet; String get highlightedBodySnippet; String? get folderId; List<String> get tagIds;
/// Create a copy of NoteSearchResultViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteSearchResultViewModelCopyWith<NoteSearchResultViewModel> get copyWith => _$NoteSearchResultViewModelCopyWithImpl<NoteSearchResultViewModel>(this as NoteSearchResultViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteSearchResultViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.highlightedTitleSnippet, highlightedTitleSnippet) || other.highlightedTitleSnippet == highlightedTitleSnippet)&&(identical(other.highlightedBodySnippet, highlightedBodySnippet) || other.highlightedBodySnippet == highlightedBodySnippet)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other.tagIds, tagIds));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,highlightedTitleSnippet,highlightedBodySnippet,folderId,const DeepCollectionEquality().hash(tagIds));

@override
String toString() {
  return 'NoteSearchResultViewModel(noteId: $noteId, title: $title, highlightedTitleSnippet: $highlightedTitleSnippet, highlightedBodySnippet: $highlightedBodySnippet, folderId: $folderId, tagIds: $tagIds)';
}


}

/// @nodoc
abstract mixin class $NoteSearchResultViewModelCopyWith<$Res>  {
  factory $NoteSearchResultViewModelCopyWith(NoteSearchResultViewModel value, $Res Function(NoteSearchResultViewModel) _then) = _$NoteSearchResultViewModelCopyWithImpl;
@useResult
$Res call({
 String noteId, String title, String highlightedTitleSnippet, String highlightedBodySnippet, String? folderId, List<String> tagIds
});




}
/// @nodoc
class _$NoteSearchResultViewModelCopyWithImpl<$Res>
    implements $NoteSearchResultViewModelCopyWith<$Res> {
  _$NoteSearchResultViewModelCopyWithImpl(this._self, this._then);

  final NoteSearchResultViewModel _self;
  final $Res Function(NoteSearchResultViewModel) _then;

/// Create a copy of NoteSearchResultViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? title = null,Object? highlightedTitleSnippet = null,Object? highlightedBodySnippet = null,Object? folderId = freezed,Object? tagIds = null,}) {
  return _then(_self.copyWith(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,highlightedTitleSnippet: null == highlightedTitleSnippet ? _self.highlightedTitleSnippet : highlightedTitleSnippet // ignore: cast_nullable_to_non_nullable
as String,highlightedBodySnippet: null == highlightedBodySnippet ? _self.highlightedBodySnippet : highlightedBodySnippet // ignore: cast_nullable_to_non_nullable
as String,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteSearchResultViewModel].
extension NoteSearchResultViewModelPatterns on NoteSearchResultViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteSearchResultViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteSearchResultViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteSearchResultViewModel value)  $default,){
final _that = this;
switch (_that) {
case _NoteSearchResultViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteSearchResultViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _NoteSearchResultViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String noteId,  String title,  String highlightedTitleSnippet,  String highlightedBodySnippet,  String? folderId,  List<String> tagIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteSearchResultViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.highlightedTitleSnippet,_that.highlightedBodySnippet,_that.folderId,_that.tagIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String noteId,  String title,  String highlightedTitleSnippet,  String highlightedBodySnippet,  String? folderId,  List<String> tagIds)  $default,) {final _that = this;
switch (_that) {
case _NoteSearchResultViewModel():
return $default(_that.noteId,_that.title,_that.highlightedTitleSnippet,_that.highlightedBodySnippet,_that.folderId,_that.tagIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String noteId,  String title,  String highlightedTitleSnippet,  String highlightedBodySnippet,  String? folderId,  List<String> tagIds)?  $default,) {final _that = this;
switch (_that) {
case _NoteSearchResultViewModel() when $default != null:
return $default(_that.noteId,_that.title,_that.highlightedTitleSnippet,_that.highlightedBodySnippet,_that.folderId,_that.tagIds);case _:
  return null;

}
}

}

/// @nodoc


class _NoteSearchResultViewModel implements NoteSearchResultViewModel {
  const _NoteSearchResultViewModel({required this.noteId, required this.title, required this.highlightedTitleSnippet, required this.highlightedBodySnippet, this.folderId, final  List<String> tagIds = const <String>[]}): _tagIds = tagIds;
  

@override final  String noteId;
@override final  String title;
@override final  String highlightedTitleSnippet;
@override final  String highlightedBodySnippet;
@override final  String? folderId;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}


/// Create a copy of NoteSearchResultViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteSearchResultViewModelCopyWith<_NoteSearchResultViewModel> get copyWith => __$NoteSearchResultViewModelCopyWithImpl<_NoteSearchResultViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteSearchResultViewModel&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.title, title) || other.title == title)&&(identical(other.highlightedTitleSnippet, highlightedTitleSnippet) || other.highlightedTitleSnippet == highlightedTitleSnippet)&&(identical(other.highlightedBodySnippet, highlightedBodySnippet) || other.highlightedBodySnippet == highlightedBodySnippet)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds));
}


@override
int get hashCode => Object.hash(runtimeType,noteId,title,highlightedTitleSnippet,highlightedBodySnippet,folderId,const DeepCollectionEquality().hash(_tagIds));

@override
String toString() {
  return 'NoteSearchResultViewModel(noteId: $noteId, title: $title, highlightedTitleSnippet: $highlightedTitleSnippet, highlightedBodySnippet: $highlightedBodySnippet, folderId: $folderId, tagIds: $tagIds)';
}


}

/// @nodoc
abstract mixin class _$NoteSearchResultViewModelCopyWith<$Res> implements $NoteSearchResultViewModelCopyWith<$Res> {
  factory _$NoteSearchResultViewModelCopyWith(_NoteSearchResultViewModel value, $Res Function(_NoteSearchResultViewModel) _then) = __$NoteSearchResultViewModelCopyWithImpl;
@override @useResult
$Res call({
 String noteId, String title, String highlightedTitleSnippet, String highlightedBodySnippet, String? folderId, List<String> tagIds
});




}
/// @nodoc
class __$NoteSearchResultViewModelCopyWithImpl<$Res>
    implements _$NoteSearchResultViewModelCopyWith<$Res> {
  __$NoteSearchResultViewModelCopyWithImpl(this._self, this._then);

  final _NoteSearchResultViewModel _self;
  final $Res Function(_NoteSearchResultViewModel) _then;

/// Create a copy of NoteSearchResultViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? title = null,Object? highlightedTitleSnippet = null,Object? highlightedBodySnippet = null,Object? folderId = freezed,Object? tagIds = null,}) {
  return _then(_NoteSearchResultViewModel(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,highlightedTitleSnippet: null == highlightedTitleSnippet ? _self.highlightedTitleSnippet : highlightedTitleSnippet // ignore: cast_nullable_to_non_nullable
as String,highlightedBodySnippet: null == highlightedBodySnippet ? _self.highlightedBodySnippet : highlightedBodySnippet // ignore: cast_nullable_to_non_nullable
as String,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
