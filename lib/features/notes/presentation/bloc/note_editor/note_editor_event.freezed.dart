// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_editor_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteEditorEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorEvent()';
}


}

/// @nodoc
class $NoteEditorEventCopyWith<$Res>  {
$NoteEditorEventCopyWith(NoteEditorEvent _, $Res Function(NoteEditorEvent) __);
}


/// Adds pattern-matching-related methods to [NoteEditorEvent].
extension NoteEditorEventPatterns on NoteEditorEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoteEditorStarted value)?  started,TResult Function( NoteEditorTitleChanged value)?  titleChanged,TResult Function( NoteEditorBodyChanged value)?  bodyChanged,TResult Function( NoteEditorManualSaveRequested value)?  manualSaveRequested,TResult Function( NoteEditorAppLifecycleChanged value)?  appLifecycleChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoteEditorStarted() when started != null:
return started(_that);case NoteEditorTitleChanged() when titleChanged != null:
return titleChanged(_that);case NoteEditorBodyChanged() when bodyChanged != null:
return bodyChanged(_that);case NoteEditorManualSaveRequested() when manualSaveRequested != null:
return manualSaveRequested(_that);case NoteEditorAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoteEditorStarted value)  started,required TResult Function( NoteEditorTitleChanged value)  titleChanged,required TResult Function( NoteEditorBodyChanged value)  bodyChanged,required TResult Function( NoteEditorManualSaveRequested value)  manualSaveRequested,required TResult Function( NoteEditorAppLifecycleChanged value)  appLifecycleChanged,}){
final _that = this;
switch (_that) {
case NoteEditorStarted():
return started(_that);case NoteEditorTitleChanged():
return titleChanged(_that);case NoteEditorBodyChanged():
return bodyChanged(_that);case NoteEditorManualSaveRequested():
return manualSaveRequested(_that);case NoteEditorAppLifecycleChanged():
return appLifecycleChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoteEditorStarted value)?  started,TResult? Function( NoteEditorTitleChanged value)?  titleChanged,TResult? Function( NoteEditorBodyChanged value)?  bodyChanged,TResult? Function( NoteEditorManualSaveRequested value)?  manualSaveRequested,TResult? Function( NoteEditorAppLifecycleChanged value)?  appLifecycleChanged,}){
final _that = this;
switch (_that) {
case NoteEditorStarted() when started != null:
return started(_that);case NoteEditorTitleChanged() when titleChanged != null:
return titleChanged(_that);case NoteEditorBodyChanged() when bodyChanged != null:
return bodyChanged(_that);case NoteEditorManualSaveRequested() when manualSaveRequested != null:
return manualSaveRequested(_that);case NoteEditorAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String title)?  titleChanged,TResult Function( String body)?  bodyChanged,TResult Function()?  manualSaveRequested,TResult Function( AppLifecycleState lifecycleState)?  appLifecycleChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoteEditorStarted() when started != null:
return started();case NoteEditorTitleChanged() when titleChanged != null:
return titleChanged(_that.title);case NoteEditorBodyChanged() when bodyChanged != null:
return bodyChanged(_that.body);case NoteEditorManualSaveRequested() when manualSaveRequested != null:
return manualSaveRequested();case NoteEditorAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that.lifecycleState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String title)  titleChanged,required TResult Function( String body)  bodyChanged,required TResult Function()  manualSaveRequested,required TResult Function( AppLifecycleState lifecycleState)  appLifecycleChanged,}) {final _that = this;
switch (_that) {
case NoteEditorStarted():
return started();case NoteEditorTitleChanged():
return titleChanged(_that.title);case NoteEditorBodyChanged():
return bodyChanged(_that.body);case NoteEditorManualSaveRequested():
return manualSaveRequested();case NoteEditorAppLifecycleChanged():
return appLifecycleChanged(_that.lifecycleState);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String title)?  titleChanged,TResult? Function( String body)?  bodyChanged,TResult? Function()?  manualSaveRequested,TResult? Function( AppLifecycleState lifecycleState)?  appLifecycleChanged,}) {final _that = this;
switch (_that) {
case NoteEditorStarted() when started != null:
return started();case NoteEditorTitleChanged() when titleChanged != null:
return titleChanged(_that.title);case NoteEditorBodyChanged() when bodyChanged != null:
return bodyChanged(_that.body);case NoteEditorManualSaveRequested() when manualSaveRequested != null:
return manualSaveRequested();case NoteEditorAppLifecycleChanged() when appLifecycleChanged != null:
return appLifecycleChanged(_that.lifecycleState);case _:
  return null;

}
}

}

/// @nodoc


class NoteEditorStarted implements NoteEditorEvent {
  const NoteEditorStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorEvent.started()';
}


}




/// @nodoc


class NoteEditorTitleChanged implements NoteEditorEvent {
  const NoteEditorTitleChanged(this.title);
  

 final  String title;

/// Create a copy of NoteEditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorTitleChangedCopyWith<NoteEditorTitleChanged> get copyWith => _$NoteEditorTitleChangedCopyWithImpl<NoteEditorTitleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorTitleChanged&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,title);

@override
String toString() {
  return 'NoteEditorEvent.titleChanged(title: $title)';
}


}

/// @nodoc
abstract mixin class $NoteEditorTitleChangedCopyWith<$Res> implements $NoteEditorEventCopyWith<$Res> {
  factory $NoteEditorTitleChangedCopyWith(NoteEditorTitleChanged value, $Res Function(NoteEditorTitleChanged) _then) = _$NoteEditorTitleChangedCopyWithImpl;
@useResult
$Res call({
 String title
});




}
/// @nodoc
class _$NoteEditorTitleChangedCopyWithImpl<$Res>
    implements $NoteEditorTitleChangedCopyWith<$Res> {
  _$NoteEditorTitleChangedCopyWithImpl(this._self, this._then);

  final NoteEditorTitleChanged _self;
  final $Res Function(NoteEditorTitleChanged) _then;

/// Create a copy of NoteEditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,}) {
  return _then(NoteEditorTitleChanged(
null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NoteEditorBodyChanged implements NoteEditorEvent {
  const NoteEditorBodyChanged(this.body);
  

 final  String body;

/// Create a copy of NoteEditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorBodyChangedCopyWith<NoteEditorBodyChanged> get copyWith => _$NoteEditorBodyChangedCopyWithImpl<NoteEditorBodyChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorBodyChanged&&(identical(other.body, body) || other.body == body));
}


@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'NoteEditorEvent.bodyChanged(body: $body)';
}


}

/// @nodoc
abstract mixin class $NoteEditorBodyChangedCopyWith<$Res> implements $NoteEditorEventCopyWith<$Res> {
  factory $NoteEditorBodyChangedCopyWith(NoteEditorBodyChanged value, $Res Function(NoteEditorBodyChanged) _then) = _$NoteEditorBodyChangedCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$NoteEditorBodyChangedCopyWithImpl<$Res>
    implements $NoteEditorBodyChangedCopyWith<$Res> {
  _$NoteEditorBodyChangedCopyWithImpl(this._self, this._then);

  final NoteEditorBodyChanged _self;
  final $Res Function(NoteEditorBodyChanged) _then;

/// Create a copy of NoteEditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(NoteEditorBodyChanged(
null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NoteEditorManualSaveRequested implements NoteEditorEvent {
  const NoteEditorManualSaveRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorManualSaveRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorEvent.manualSaveRequested()';
}


}




/// @nodoc


class NoteEditorAppLifecycleChanged implements NoteEditorEvent {
  const NoteEditorAppLifecycleChanged(this.lifecycleState);
  

 final  AppLifecycleState lifecycleState;

/// Create a copy of NoteEditorEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorAppLifecycleChangedCopyWith<NoteEditorAppLifecycleChanged> get copyWith => _$NoteEditorAppLifecycleChangedCopyWithImpl<NoteEditorAppLifecycleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorAppLifecycleChanged&&(identical(other.lifecycleState, lifecycleState) || other.lifecycleState == lifecycleState));
}


@override
int get hashCode => Object.hash(runtimeType,lifecycleState);

@override
String toString() {
  return 'NoteEditorEvent.appLifecycleChanged(lifecycleState: $lifecycleState)';
}


}

/// @nodoc
abstract mixin class $NoteEditorAppLifecycleChangedCopyWith<$Res> implements $NoteEditorEventCopyWith<$Res> {
  factory $NoteEditorAppLifecycleChangedCopyWith(NoteEditorAppLifecycleChanged value, $Res Function(NoteEditorAppLifecycleChanged) _then) = _$NoteEditorAppLifecycleChangedCopyWithImpl;
@useResult
$Res call({
 AppLifecycleState lifecycleState
});




}
/// @nodoc
class _$NoteEditorAppLifecycleChangedCopyWithImpl<$Res>
    implements $NoteEditorAppLifecycleChangedCopyWith<$Res> {
  _$NoteEditorAppLifecycleChangedCopyWithImpl(this._self, this._then);

  final NoteEditorAppLifecycleChanged _self;
  final $Res Function(NoteEditorAppLifecycleChanged) _then;

/// Create a copy of NoteEditorEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lifecycleState = null,}) {
  return _then(NoteEditorAppLifecycleChanged(
null == lifecycleState ? _self.lifecycleState : lifecycleState // ignore: cast_nullable_to_non_nullable
as AppLifecycleState,
  ));
}


}

// dart format on
