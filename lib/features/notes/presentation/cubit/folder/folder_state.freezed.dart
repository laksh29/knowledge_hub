// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FolderState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FolderState()';
}


}

/// @nodoc
class $FolderStateCopyWith<$Res>  {
$FolderStateCopyWith(FolderState _, $Res Function(FolderState) __);
}


/// Adds pattern-matching-related methods to [FolderState].
extension FolderStatePatterns on FolderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FolderListLoading value)?  loading,TResult Function( FolderListLoaded value)?  loaded,TResult Function( FolderCreationFailed value)?  creationFailed,TResult Function( FolderListLoadFailed value)?  loadFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FolderListLoading() when loading != null:
return loading(_that);case FolderListLoaded() when loaded != null:
return loaded(_that);case FolderCreationFailed() when creationFailed != null:
return creationFailed(_that);case FolderListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FolderListLoading value)  loading,required TResult Function( FolderListLoaded value)  loaded,required TResult Function( FolderCreationFailed value)  creationFailed,required TResult Function( FolderListLoadFailed value)  loadFailed,}){
final _that = this;
switch (_that) {
case FolderListLoading():
return loading(_that);case FolderListLoaded():
return loaded(_that);case FolderCreationFailed():
return creationFailed(_that);case FolderListLoadFailed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FolderListLoading value)?  loading,TResult? Function( FolderListLoaded value)?  loaded,TResult? Function( FolderCreationFailed value)?  creationFailed,TResult? Function( FolderListLoadFailed value)?  loadFailed,}){
final _that = this;
switch (_that) {
case FolderListLoading() when loading != null:
return loading(_that);case FolderListLoaded() when loaded != null:
return loaded(_that);case FolderCreationFailed() when creationFailed != null:
return creationFailed(_that);case FolderListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<FolderViewModel> folders)?  loaded,TResult Function( List<FolderViewModel> currentFolders,  String errorMessage)?  creationFailed,TResult Function( String errorMessage)?  loadFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FolderListLoading() when loading != null:
return loading();case FolderListLoaded() when loaded != null:
return loaded(_that.folders);case FolderCreationFailed() when creationFailed != null:
return creationFailed(_that.currentFolders,_that.errorMessage);case FolderListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<FolderViewModel> folders)  loaded,required TResult Function( List<FolderViewModel> currentFolders,  String errorMessage)  creationFailed,required TResult Function( String errorMessage)  loadFailed,}) {final _that = this;
switch (_that) {
case FolderListLoading():
return loading();case FolderListLoaded():
return loaded(_that.folders);case FolderCreationFailed():
return creationFailed(_that.currentFolders,_that.errorMessage);case FolderListLoadFailed():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<FolderViewModel> folders)?  loaded,TResult? Function( List<FolderViewModel> currentFolders,  String errorMessage)?  creationFailed,TResult? Function( String errorMessage)?  loadFailed,}) {final _that = this;
switch (_that) {
case FolderListLoading() when loading != null:
return loading();case FolderListLoaded() when loaded != null:
return loaded(_that.folders);case FolderCreationFailed() when creationFailed != null:
return creationFailed(_that.currentFolders,_that.errorMessage);case FolderListLoadFailed() when loadFailed != null:
return loadFailed(_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class FolderListLoading implements FolderState {
  const FolderListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FolderState.loading()';
}


}




/// @nodoc


class FolderListLoaded implements FolderState {
  const FolderListLoaded(final  List<FolderViewModel> folders): _folders = folders;
  

 final  List<FolderViewModel> _folders;
 List<FolderViewModel> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}


/// Create a copy of FolderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderListLoadedCopyWith<FolderListLoaded> get copyWith => _$FolderListLoadedCopyWithImpl<FolderListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderListLoaded&&const DeepCollectionEquality().equals(other._folders, _folders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_folders));

@override
String toString() {
  return 'FolderState.loaded(folders: $folders)';
}


}

/// @nodoc
abstract mixin class $FolderListLoadedCopyWith<$Res> implements $FolderStateCopyWith<$Res> {
  factory $FolderListLoadedCopyWith(FolderListLoaded value, $Res Function(FolderListLoaded) _then) = _$FolderListLoadedCopyWithImpl;
@useResult
$Res call({
 List<FolderViewModel> folders
});




}
/// @nodoc
class _$FolderListLoadedCopyWithImpl<$Res>
    implements $FolderListLoadedCopyWith<$Res> {
  _$FolderListLoadedCopyWithImpl(this._self, this._then);

  final FolderListLoaded _self;
  final $Res Function(FolderListLoaded) _then;

/// Create a copy of FolderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folders = null,}) {
  return _then(FolderListLoaded(
null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<FolderViewModel>,
  ));
}


}

/// @nodoc


class FolderCreationFailed implements FolderState {
  const FolderCreationFailed(final  List<FolderViewModel> currentFolders, this.errorMessage): _currentFolders = currentFolders;
  

 final  List<FolderViewModel> _currentFolders;
 List<FolderViewModel> get currentFolders {
  if (_currentFolders is EqualUnmodifiableListView) return _currentFolders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentFolders);
}

 final  String errorMessage;

/// Create a copy of FolderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderCreationFailedCopyWith<FolderCreationFailed> get copyWith => _$FolderCreationFailedCopyWithImpl<FolderCreationFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderCreationFailed&&const DeepCollectionEquality().equals(other._currentFolders, _currentFolders)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_currentFolders),errorMessage);

@override
String toString() {
  return 'FolderState.creationFailed(currentFolders: $currentFolders, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FolderCreationFailedCopyWith<$Res> implements $FolderStateCopyWith<$Res> {
  factory $FolderCreationFailedCopyWith(FolderCreationFailed value, $Res Function(FolderCreationFailed) _then) = _$FolderCreationFailedCopyWithImpl;
@useResult
$Res call({
 List<FolderViewModel> currentFolders, String errorMessage
});




}
/// @nodoc
class _$FolderCreationFailedCopyWithImpl<$Res>
    implements $FolderCreationFailedCopyWith<$Res> {
  _$FolderCreationFailedCopyWithImpl(this._self, this._then);

  final FolderCreationFailed _self;
  final $Res Function(FolderCreationFailed) _then;

/// Create a copy of FolderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentFolders = null,Object? errorMessage = null,}) {
  return _then(FolderCreationFailed(
null == currentFolders ? _self._currentFolders : currentFolders // ignore: cast_nullable_to_non_nullable
as List<FolderViewModel>,null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FolderListLoadFailed implements FolderState {
  const FolderListLoadFailed(this.errorMessage);
  

 final  String errorMessage;

/// Create a copy of FolderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderListLoadFailedCopyWith<FolderListLoadFailed> get copyWith => _$FolderListLoadFailedCopyWithImpl<FolderListLoadFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderListLoadFailed&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage);

@override
String toString() {
  return 'FolderState.loadFailed(errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FolderListLoadFailedCopyWith<$Res> implements $FolderStateCopyWith<$Res> {
  factory $FolderListLoadFailedCopyWith(FolderListLoadFailed value, $Res Function(FolderListLoadFailed) _then) = _$FolderListLoadFailedCopyWithImpl;
@useResult
$Res call({
 String errorMessage
});




}
/// @nodoc
class _$FolderListLoadFailedCopyWithImpl<$Res>
    implements $FolderListLoadFailedCopyWith<$Res> {
  _$FolderListLoadFailedCopyWithImpl(this._self, this._then);

  final FolderListLoadFailed _self;
  final $Res Function(FolderListLoadFailed) _then;

/// Create a copy of FolderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,}) {
  return _then(FolderListLoadFailed(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
