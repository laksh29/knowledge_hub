// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteListState()';
}


}

/// @nodoc
class $NoteListStateCopyWith<$Res>  {
$NoteListStateCopyWith(NoteListState _, $Res Function(NoteListState) __);
}


/// Adds pattern-matching-related methods to [NoteListState].
extension NoteListStatePatterns on NoteListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoteListLoading value)?  loading,TResult Function( NoteListLoaded value)?  loaded,TResult Function( NoteListLoadFailed value)?  loadFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoteListLoading() when loading != null:
return loading(_that);case NoteListLoaded() when loaded != null:
return loaded(_that);case NoteListLoadFailed() when loadFailed != null:
return loadFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoteListLoading value)  loading,required TResult Function( NoteListLoaded value)  loaded,required TResult Function( NoteListLoadFailed value)  loadFailed,}){
final _that = this;
switch (_that) {
case NoteListLoading():
return loading(_that);case NoteListLoaded():
return loaded(_that);case NoteListLoadFailed():
return loadFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoteListLoading value)?  loading,TResult? Function( NoteListLoaded value)?  loaded,TResult? Function( NoteListLoadFailed value)?  loadFailed,}){
final _that = this;
switch (_that) {
case NoteListLoading() when loading != null:
return loading(_that);case NoteListLoaded() when loaded != null:
return loaded(_that);case NoteListLoadFailed() when loadFailed != null:
return loadFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<NoteListItemViewModel> notes,  NoteListFilterParams activeFilter)?  loaded,TResult Function( String errorMessage)?  loadFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoteListLoading() when loading != null:
return loading();case NoteListLoaded() when loaded != null:
return loaded(_that.notes,_that.activeFilter);case NoteListLoadFailed() when loadFailed != null:
return loadFailed(_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<NoteListItemViewModel> notes,  NoteListFilterParams activeFilter)  loaded,required TResult Function( String errorMessage)  loadFailed,}) {final _that = this;
switch (_that) {
case NoteListLoading():
return loading();case NoteListLoaded():
return loaded(_that.notes,_that.activeFilter);case NoteListLoadFailed():
return loadFailed(_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<NoteListItemViewModel> notes,  NoteListFilterParams activeFilter)?  loaded,TResult? Function( String errorMessage)?  loadFailed,}) {final _that = this;
switch (_that) {
case NoteListLoading() when loading != null:
return loading();case NoteListLoaded() when loaded != null:
return loaded(_that.notes,_that.activeFilter);case NoteListLoadFailed() when loadFailed != null:
return loadFailed(_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class NoteListLoading implements NoteListState {
  const NoteListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteListState.loading()';
}


}




/// @nodoc


class NoteListLoaded implements NoteListState {
  const NoteListLoaded(final  List<NoteListItemViewModel> notes, this.activeFilter): _notes = notes;
  

 final  List<NoteListItemViewModel> _notes;
 List<NoteListItemViewModel> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

 final  NoteListFilterParams activeFilter;

/// Create a copy of NoteListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteListLoadedCopyWith<NoteListLoaded> get copyWith => _$NoteListLoadedCopyWithImpl<NoteListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteListLoaded&&const DeepCollectionEquality().equals(other._notes, _notes)&&(identical(other.activeFilter, activeFilter) || other.activeFilter == activeFilter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_notes),activeFilter);

@override
String toString() {
  return 'NoteListState.loaded(notes: $notes, activeFilter: $activeFilter)';
}


}

/// @nodoc
abstract mixin class $NoteListLoadedCopyWith<$Res> implements $NoteListStateCopyWith<$Res> {
  factory $NoteListLoadedCopyWith(NoteListLoaded value, $Res Function(NoteListLoaded) _then) = _$NoteListLoadedCopyWithImpl;
@useResult
$Res call({
 List<NoteListItemViewModel> notes, NoteListFilterParams activeFilter
});


$NoteListFilterParamsCopyWith<$Res> get activeFilter;

}
/// @nodoc
class _$NoteListLoadedCopyWithImpl<$Res>
    implements $NoteListLoadedCopyWith<$Res> {
  _$NoteListLoadedCopyWithImpl(this._self, this._then);

  final NoteListLoaded _self;
  final $Res Function(NoteListLoaded) _then;

/// Create a copy of NoteListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? notes = null,Object? activeFilter = null,}) {
  return _then(NoteListLoaded(
null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<NoteListItemViewModel>,null == activeFilter ? _self.activeFilter : activeFilter // ignore: cast_nullable_to_non_nullable
as NoteListFilterParams,
  ));
}

/// Create a copy of NoteListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteListFilterParamsCopyWith<$Res> get activeFilter {
  
  return $NoteListFilterParamsCopyWith<$Res>(_self.activeFilter, (value) {
    return _then(_self.copyWith(activeFilter: value));
  });
}
}

/// @nodoc


class NoteListLoadFailed implements NoteListState {
  const NoteListLoadFailed(this.errorMessage);
  

 final  String errorMessage;

/// Create a copy of NoteListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteListLoadFailedCopyWith<NoteListLoadFailed> get copyWith => _$NoteListLoadFailedCopyWithImpl<NoteListLoadFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteListLoadFailed&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage);

@override
String toString() {
  return 'NoteListState.loadFailed(errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $NoteListLoadFailedCopyWith<$Res> implements $NoteListStateCopyWith<$Res> {
  factory $NoteListLoadFailedCopyWith(NoteListLoadFailed value, $Res Function(NoteListLoadFailed) _then) = _$NoteListLoadFailedCopyWithImpl;
@useResult
$Res call({
 String errorMessage
});




}
/// @nodoc
class _$NoteListLoadFailedCopyWithImpl<$Res>
    implements $NoteListLoadFailedCopyWith<$Res> {
  _$NoteListLoadFailedCopyWithImpl(this._self, this._then);

  final NoteListLoadFailed _self;
  final $Res Function(NoteListLoadFailed) _then;

/// Create a copy of NoteListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,}) {
  return _then(NoteListLoadFailed(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
