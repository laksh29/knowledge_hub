// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trash_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrashState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrashState()';
}


}

/// @nodoc
class $TrashStateCopyWith<$Res>  {
$TrashStateCopyWith(TrashState _, $Res Function(TrashState) __);
}


/// Adds pattern-matching-related methods to [TrashState].
extension TrashStatePatterns on TrashState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TrashLoading value)?  loading,TResult Function( TrashLoaded value)?  loaded,TResult Function( TrashActionFailed value)?  actionFailed,TResult Function( TrashListLoadFailed value)?  loadFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TrashLoading() when loading != null:
return loading(_that);case TrashLoaded() when loaded != null:
return loaded(_that);case TrashActionFailed() when actionFailed != null:
return actionFailed(_that);case TrashListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TrashLoading value)  loading,required TResult Function( TrashLoaded value)  loaded,required TResult Function( TrashActionFailed value)  actionFailed,required TResult Function( TrashListLoadFailed value)  loadFailed,}){
final _that = this;
switch (_that) {
case TrashLoading():
return loading(_that);case TrashLoaded():
return loaded(_that);case TrashActionFailed():
return actionFailed(_that);case TrashListLoadFailed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TrashLoading value)?  loading,TResult? Function( TrashLoaded value)?  loaded,TResult? Function( TrashActionFailed value)?  actionFailed,TResult? Function( TrashListLoadFailed value)?  loadFailed,}){
final _that = this;
switch (_that) {
case TrashLoading() when loading != null:
return loading(_that);case TrashLoaded() when loaded != null:
return loaded(_that);case TrashActionFailed() when actionFailed != null:
return actionFailed(_that);case TrashListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<TrashedNoteViewModel> items)?  loaded,TResult Function( List<TrashedNoteViewModel> currentItems,  String errorMessage)?  actionFailed,TResult Function( String errorMessage)?  loadFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TrashLoading() when loading != null:
return loading();case TrashLoaded() when loaded != null:
return loaded(_that.items);case TrashActionFailed() when actionFailed != null:
return actionFailed(_that.currentItems,_that.errorMessage);case TrashListLoadFailed() when loadFailed != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<TrashedNoteViewModel> items)  loaded,required TResult Function( List<TrashedNoteViewModel> currentItems,  String errorMessage)  actionFailed,required TResult Function( String errorMessage)  loadFailed,}) {final _that = this;
switch (_that) {
case TrashLoading():
return loading();case TrashLoaded():
return loaded(_that.items);case TrashActionFailed():
return actionFailed(_that.currentItems,_that.errorMessage);case TrashListLoadFailed():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<TrashedNoteViewModel> items)?  loaded,TResult? Function( List<TrashedNoteViewModel> currentItems,  String errorMessage)?  actionFailed,TResult? Function( String errorMessage)?  loadFailed,}) {final _that = this;
switch (_that) {
case TrashLoading() when loading != null:
return loading();case TrashLoaded() when loaded != null:
return loaded(_that.items);case TrashActionFailed() when actionFailed != null:
return actionFailed(_that.currentItems,_that.errorMessage);case TrashListLoadFailed() when loadFailed != null:
return loadFailed(_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class TrashLoading extends TrashState {
  const TrashLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrashState.loading()';
}


}




/// @nodoc


class TrashLoaded extends TrashState {
  const TrashLoaded(final  List<TrashedNoteViewModel> items): _items = items,super._();
  

 final  List<TrashedNoteViewModel> _items;
 List<TrashedNoteViewModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TrashState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrashLoadedCopyWith<TrashLoaded> get copyWith => _$TrashLoadedCopyWithImpl<TrashLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TrashState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class $TrashLoadedCopyWith<$Res> implements $TrashStateCopyWith<$Res> {
  factory $TrashLoadedCopyWith(TrashLoaded value, $Res Function(TrashLoaded) _then) = _$TrashLoadedCopyWithImpl;
@useResult
$Res call({
 List<TrashedNoteViewModel> items
});




}
/// @nodoc
class _$TrashLoadedCopyWithImpl<$Res>
    implements $TrashLoadedCopyWith<$Res> {
  _$TrashLoadedCopyWithImpl(this._self, this._then);

  final TrashLoaded _self;
  final $Res Function(TrashLoaded) _then;

/// Create a copy of TrashState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(TrashLoaded(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TrashedNoteViewModel>,
  ));
}


}

/// @nodoc


class TrashActionFailed extends TrashState {
  const TrashActionFailed(final  List<TrashedNoteViewModel> currentItems, this.errorMessage): _currentItems = currentItems,super._();
  

 final  List<TrashedNoteViewModel> _currentItems;
 List<TrashedNoteViewModel> get currentItems {
  if (_currentItems is EqualUnmodifiableListView) return _currentItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentItems);
}

 final  String errorMessage;

/// Create a copy of TrashState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrashActionFailedCopyWith<TrashActionFailed> get copyWith => _$TrashActionFailedCopyWithImpl<TrashActionFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashActionFailed&&const DeepCollectionEquality().equals(other._currentItems, _currentItems)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_currentItems),errorMessage);

@override
String toString() {
  return 'TrashState.actionFailed(currentItems: $currentItems, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TrashActionFailedCopyWith<$Res> implements $TrashStateCopyWith<$Res> {
  factory $TrashActionFailedCopyWith(TrashActionFailed value, $Res Function(TrashActionFailed) _then) = _$TrashActionFailedCopyWithImpl;
@useResult
$Res call({
 List<TrashedNoteViewModel> currentItems, String errorMessage
});




}
/// @nodoc
class _$TrashActionFailedCopyWithImpl<$Res>
    implements $TrashActionFailedCopyWith<$Res> {
  _$TrashActionFailedCopyWithImpl(this._self, this._then);

  final TrashActionFailed _self;
  final $Res Function(TrashActionFailed) _then;

/// Create a copy of TrashState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentItems = null,Object? errorMessage = null,}) {
  return _then(TrashActionFailed(
null == currentItems ? _self._currentItems : currentItems // ignore: cast_nullable_to_non_nullable
as List<TrashedNoteViewModel>,null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TrashListLoadFailed extends TrashState {
  const TrashListLoadFailed(this.errorMessage): super._();
  

 final  String errorMessage;

/// Create a copy of TrashState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrashListLoadFailedCopyWith<TrashListLoadFailed> get copyWith => _$TrashListLoadFailedCopyWithImpl<TrashListLoadFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrashListLoadFailed&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage);

@override
String toString() {
  return 'TrashState.loadFailed(errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TrashListLoadFailedCopyWith<$Res> implements $TrashStateCopyWith<$Res> {
  factory $TrashListLoadFailedCopyWith(TrashListLoadFailed value, $Res Function(TrashListLoadFailed) _then) = _$TrashListLoadFailedCopyWithImpl;
@useResult
$Res call({
 String errorMessage
});




}
/// @nodoc
class _$TrashListLoadFailedCopyWithImpl<$Res>
    implements $TrashListLoadFailedCopyWith<$Res> {
  _$TrashListLoadFailedCopyWithImpl(this._self, this._then);

  final TrashListLoadFailed _self;
  final $Res Function(TrashListLoadFailed) _then;

/// Create a copy of TrashState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,}) {
  return _then(TrashListLoadFailed(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
