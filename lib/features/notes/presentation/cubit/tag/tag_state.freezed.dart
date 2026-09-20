// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TagState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TagState()';
}


}

/// @nodoc
class $TagStateCopyWith<$Res>  {
$TagStateCopyWith(TagState _, $Res Function(TagState) __);
}


/// Adds pattern-matching-related methods to [TagState].
extension TagStatePatterns on TagState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TagListLoading value)?  loading,TResult Function( TagListLoaded value)?  loaded,TResult Function( TagCreationFailed value)?  creationFailed,TResult Function( TagListLoadFailed value)?  loadFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TagListLoading() when loading != null:
return loading(_that);case TagListLoaded() when loaded != null:
return loaded(_that);case TagCreationFailed() when creationFailed != null:
return creationFailed(_that);case TagListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TagListLoading value)  loading,required TResult Function( TagListLoaded value)  loaded,required TResult Function( TagCreationFailed value)  creationFailed,required TResult Function( TagListLoadFailed value)  loadFailed,}){
final _that = this;
switch (_that) {
case TagListLoading():
return loading(_that);case TagListLoaded():
return loaded(_that);case TagCreationFailed():
return creationFailed(_that);case TagListLoadFailed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TagListLoading value)?  loading,TResult? Function( TagListLoaded value)?  loaded,TResult? Function( TagCreationFailed value)?  creationFailed,TResult? Function( TagListLoadFailed value)?  loadFailed,}){
final _that = this;
switch (_that) {
case TagListLoading() when loading != null:
return loading(_that);case TagListLoaded() when loaded != null:
return loaded(_that);case TagCreationFailed() when creationFailed != null:
return creationFailed(_that);case TagListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<TagViewModel> tags)?  loaded,TResult Function( List<TagViewModel> currentTags,  String errorMessage)?  creationFailed,TResult Function( String errorMessage)?  loadFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TagListLoading() when loading != null:
return loading();case TagListLoaded() when loaded != null:
return loaded(_that.tags);case TagCreationFailed() when creationFailed != null:
return creationFailed(_that.currentTags,_that.errorMessage);case TagListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<TagViewModel> tags)  loaded,required TResult Function( List<TagViewModel> currentTags,  String errorMessage)  creationFailed,required TResult Function( String errorMessage)  loadFailed,}) {final _that = this;
switch (_that) {
case TagListLoading():
return loading();case TagListLoaded():
return loaded(_that.tags);case TagCreationFailed():
return creationFailed(_that.currentTags,_that.errorMessage);case TagListLoadFailed():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<TagViewModel> tags)?  loaded,TResult? Function( List<TagViewModel> currentTags,  String errorMessage)?  creationFailed,TResult? Function( String errorMessage)?  loadFailed,}) {final _that = this;
switch (_that) {
case TagListLoading() when loading != null:
return loading();case TagListLoaded() when loaded != null:
return loaded(_that.tags);case TagCreationFailed() when creationFailed != null:
return creationFailed(_that.currentTags,_that.errorMessage);case TagListLoadFailed() when loadFailed != null:
return loadFailed(_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class TagListLoading extends TagState {
  const TagListLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TagState.loading()';
}


}




/// @nodoc


class TagListLoaded extends TagState {
  const TagListLoaded(final  List<TagViewModel> tags): _tags = tags,super._();
  

 final  List<TagViewModel> _tags;
 List<TagViewModel> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of TagState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagListLoadedCopyWith<TagListLoaded> get copyWith => _$TagListLoadedCopyWithImpl<TagListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagListLoaded&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'TagState.loaded(tags: $tags)';
}


}

/// @nodoc
abstract mixin class $TagListLoadedCopyWith<$Res> implements $TagStateCopyWith<$Res> {
  factory $TagListLoadedCopyWith(TagListLoaded value, $Res Function(TagListLoaded) _then) = _$TagListLoadedCopyWithImpl;
@useResult
$Res call({
 List<TagViewModel> tags
});




}
/// @nodoc
class _$TagListLoadedCopyWithImpl<$Res>
    implements $TagListLoadedCopyWith<$Res> {
  _$TagListLoadedCopyWithImpl(this._self, this._then);

  final TagListLoaded _self;
  final $Res Function(TagListLoaded) _then;

/// Create a copy of TagState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tags = null,}) {
  return _then(TagListLoaded(
null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagViewModel>,
  ));
}


}

/// @nodoc


class TagCreationFailed extends TagState {
  const TagCreationFailed(final  List<TagViewModel> currentTags, this.errorMessage): _currentTags = currentTags,super._();
  

 final  List<TagViewModel> _currentTags;
 List<TagViewModel> get currentTags {
  if (_currentTags is EqualUnmodifiableListView) return _currentTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentTags);
}

 final  String errorMessage;

/// Create a copy of TagState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagCreationFailedCopyWith<TagCreationFailed> get copyWith => _$TagCreationFailedCopyWithImpl<TagCreationFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagCreationFailed&&const DeepCollectionEquality().equals(other._currentTags, _currentTags)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_currentTags),errorMessage);

@override
String toString() {
  return 'TagState.creationFailed(currentTags: $currentTags, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TagCreationFailedCopyWith<$Res> implements $TagStateCopyWith<$Res> {
  factory $TagCreationFailedCopyWith(TagCreationFailed value, $Res Function(TagCreationFailed) _then) = _$TagCreationFailedCopyWithImpl;
@useResult
$Res call({
 List<TagViewModel> currentTags, String errorMessage
});




}
/// @nodoc
class _$TagCreationFailedCopyWithImpl<$Res>
    implements $TagCreationFailedCopyWith<$Res> {
  _$TagCreationFailedCopyWithImpl(this._self, this._then);

  final TagCreationFailed _self;
  final $Res Function(TagCreationFailed) _then;

/// Create a copy of TagState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentTags = null,Object? errorMessage = null,}) {
  return _then(TagCreationFailed(
null == currentTags ? _self._currentTags : currentTags // ignore: cast_nullable_to_non_nullable
as List<TagViewModel>,null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TagListLoadFailed extends TagState {
  const TagListLoadFailed(this.errorMessage): super._();
  

 final  String errorMessage;

/// Create a copy of TagState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagListLoadFailedCopyWith<TagListLoadFailed> get copyWith => _$TagListLoadFailedCopyWithImpl<TagListLoadFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagListLoadFailed&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage);

@override
String toString() {
  return 'TagState.loadFailed(errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TagListLoadFailedCopyWith<$Res> implements $TagStateCopyWith<$Res> {
  factory $TagListLoadFailedCopyWith(TagListLoadFailed value, $Res Function(TagListLoadFailed) _then) = _$TagListLoadFailedCopyWithImpl;
@useResult
$Res call({
 String errorMessage
});




}
/// @nodoc
class _$TagListLoadFailedCopyWithImpl<$Res>
    implements $TagListLoadFailedCopyWith<$Res> {
  _$TagListLoadFailedCopyWithImpl(this._self, this._then);

  final TagListLoadFailed _self;
  final $Res Function(TagListLoadFailed) _then;

/// Create a copy of TagState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,}) {
  return _then(TagListLoadFailed(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
