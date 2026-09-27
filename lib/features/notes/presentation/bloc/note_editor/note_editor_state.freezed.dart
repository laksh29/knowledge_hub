// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteEditorState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorState()';
}


}

/// @nodoc
class $NoteEditorStateCopyWith<$Res>  {
$NoteEditorStateCopyWith(NoteEditorState _, $Res Function(NoteEditorState) __);
}


/// Adds pattern-matching-related methods to [NoteEditorState].
extension NoteEditorStatePatterns on NoteEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoteEditorInitializing value)?  initializing,TResult Function( NoteEditorCreationFailed value)?  creationFailed,TResult Function( NoteEditorNotSaved value)?  notSaved,TResult Function( NoteEditorSaving value)?  saving,TResult Function( NoteEditorSaved value)?  saved,TResult Function( NoteEditorSaveFailed value)?  saveFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoteEditorInitializing() when initializing != null:
return initializing(_that);case NoteEditorCreationFailed() when creationFailed != null:
return creationFailed(_that);case NoteEditorNotSaved() when notSaved != null:
return notSaved(_that);case NoteEditorSaving() when saving != null:
return saving(_that);case NoteEditorSaved() when saved != null:
return saved(_that);case NoteEditorSaveFailed() when saveFailed != null:
return saveFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoteEditorInitializing value)  initializing,required TResult Function( NoteEditorCreationFailed value)  creationFailed,required TResult Function( NoteEditorNotSaved value)  notSaved,required TResult Function( NoteEditorSaving value)  saving,required TResult Function( NoteEditorSaved value)  saved,required TResult Function( NoteEditorSaveFailed value)  saveFailed,}){
final _that = this;
switch (_that) {
case NoteEditorInitializing():
return initializing(_that);case NoteEditorCreationFailed():
return creationFailed(_that);case NoteEditorNotSaved():
return notSaved(_that);case NoteEditorSaving():
return saving(_that);case NoteEditorSaved():
return saved(_that);case NoteEditorSaveFailed():
return saveFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoteEditorInitializing value)?  initializing,TResult? Function( NoteEditorCreationFailed value)?  creationFailed,TResult? Function( NoteEditorNotSaved value)?  notSaved,TResult? Function( NoteEditorSaving value)?  saving,TResult? Function( NoteEditorSaved value)?  saved,TResult? Function( NoteEditorSaveFailed value)?  saveFailed,}){
final _that = this;
switch (_that) {
case NoteEditorInitializing() when initializing != null:
return initializing(_that);case NoteEditorCreationFailed() when creationFailed != null:
return creationFailed(_that);case NoteEditorNotSaved() when notSaved != null:
return notSaved(_that);case NoteEditorSaving() when saving != null:
return saving(_that);case NoteEditorSaved() when saved != null:
return saved(_that);case NoteEditorSaveFailed() when saveFailed != null:
return saveFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initializing,TResult Function( String message)?  creationFailed,TResult Function( NoteEditorViewModel viewModel)?  notSaved,TResult Function( NoteEditorViewModel viewModel)?  saving,TResult Function( NoteEditorViewModel viewModel)?  saved,TResult Function( NoteEditorViewModel viewModel,  String errorMessage)?  saveFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoteEditorInitializing() when initializing != null:
return initializing();case NoteEditorCreationFailed() when creationFailed != null:
return creationFailed(_that.message);case NoteEditorNotSaved() when notSaved != null:
return notSaved(_that.viewModel);case NoteEditorSaving() when saving != null:
return saving(_that.viewModel);case NoteEditorSaved() when saved != null:
return saved(_that.viewModel);case NoteEditorSaveFailed() when saveFailed != null:
return saveFailed(_that.viewModel,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initializing,required TResult Function( String message)  creationFailed,required TResult Function( NoteEditorViewModel viewModel)  notSaved,required TResult Function( NoteEditorViewModel viewModel)  saving,required TResult Function( NoteEditorViewModel viewModel)  saved,required TResult Function( NoteEditorViewModel viewModel,  String errorMessage)  saveFailed,}) {final _that = this;
switch (_that) {
case NoteEditorInitializing():
return initializing();case NoteEditorCreationFailed():
return creationFailed(_that.message);case NoteEditorNotSaved():
return notSaved(_that.viewModel);case NoteEditorSaving():
return saving(_that.viewModel);case NoteEditorSaved():
return saved(_that.viewModel);case NoteEditorSaveFailed():
return saveFailed(_that.viewModel,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initializing,TResult? Function( String message)?  creationFailed,TResult? Function( NoteEditorViewModel viewModel)?  notSaved,TResult? Function( NoteEditorViewModel viewModel)?  saving,TResult? Function( NoteEditorViewModel viewModel)?  saved,TResult? Function( NoteEditorViewModel viewModel,  String errorMessage)?  saveFailed,}) {final _that = this;
switch (_that) {
case NoteEditorInitializing() when initializing != null:
return initializing();case NoteEditorCreationFailed() when creationFailed != null:
return creationFailed(_that.message);case NoteEditorNotSaved() when notSaved != null:
return notSaved(_that.viewModel);case NoteEditorSaving() when saving != null:
return saving(_that.viewModel);case NoteEditorSaved() when saved != null:
return saved(_that.viewModel);case NoteEditorSaveFailed() when saveFailed != null:
return saveFailed(_that.viewModel,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class NoteEditorInitializing extends NoteEditorState {
  const NoteEditorInitializing(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorInitializing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NoteEditorState.initializing()';
}


}




/// @nodoc


class NoteEditorCreationFailed extends NoteEditorState {
  const NoteEditorCreationFailed(this.message): super._();
  

 final  String message;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorCreationFailedCopyWith<NoteEditorCreationFailed> get copyWith => _$NoteEditorCreationFailedCopyWithImpl<NoteEditorCreationFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorCreationFailed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NoteEditorState.creationFailed(message: $message)';
}


}

/// @nodoc
abstract mixin class $NoteEditorCreationFailedCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory $NoteEditorCreationFailedCopyWith(NoteEditorCreationFailed value, $Res Function(NoteEditorCreationFailed) _then) = _$NoteEditorCreationFailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NoteEditorCreationFailedCopyWithImpl<$Res>
    implements $NoteEditorCreationFailedCopyWith<$Res> {
  _$NoteEditorCreationFailedCopyWithImpl(this._self, this._then);

  final NoteEditorCreationFailed _self;
  final $Res Function(NoteEditorCreationFailed) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NoteEditorCreationFailed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NoteEditorNotSaved extends NoteEditorState {
  const NoteEditorNotSaved(this.viewModel): super._();
  

 final  NoteEditorViewModel viewModel;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorNotSavedCopyWith<NoteEditorNotSaved> get copyWith => _$NoteEditorNotSavedCopyWithImpl<NoteEditorNotSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorNotSaved&&(identical(other.viewModel, viewModel) || other.viewModel == viewModel));
}


@override
int get hashCode => Object.hash(runtimeType,viewModel);

@override
String toString() {
  return 'NoteEditorState.notSaved(viewModel: $viewModel)';
}


}

/// @nodoc
abstract mixin class $NoteEditorNotSavedCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory $NoteEditorNotSavedCopyWith(NoteEditorNotSaved value, $Res Function(NoteEditorNotSaved) _then) = _$NoteEditorNotSavedCopyWithImpl;
@useResult
$Res call({
 NoteEditorViewModel viewModel
});


$NoteEditorViewModelCopyWith<$Res> get viewModel;

}
/// @nodoc
class _$NoteEditorNotSavedCopyWithImpl<$Res>
    implements $NoteEditorNotSavedCopyWith<$Res> {
  _$NoteEditorNotSavedCopyWithImpl(this._self, this._then);

  final NoteEditorNotSaved _self;
  final $Res Function(NoteEditorNotSaved) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? viewModel = null,}) {
  return _then(NoteEditorNotSaved(
null == viewModel ? _self.viewModel : viewModel // ignore: cast_nullable_to_non_nullable
as NoteEditorViewModel,
  ));
}

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteEditorViewModelCopyWith<$Res> get viewModel {
  
  return $NoteEditorViewModelCopyWith<$Res>(_self.viewModel, (value) {
    return _then(_self.copyWith(viewModel: value));
  });
}
}

/// @nodoc


class NoteEditorSaving extends NoteEditorState {
  const NoteEditorSaving(this.viewModel): super._();
  

 final  NoteEditorViewModel viewModel;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorSavingCopyWith<NoteEditorSaving> get copyWith => _$NoteEditorSavingCopyWithImpl<NoteEditorSaving>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorSaving&&(identical(other.viewModel, viewModel) || other.viewModel == viewModel));
}


@override
int get hashCode => Object.hash(runtimeType,viewModel);

@override
String toString() {
  return 'NoteEditorState.saving(viewModel: $viewModel)';
}


}

/// @nodoc
abstract mixin class $NoteEditorSavingCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory $NoteEditorSavingCopyWith(NoteEditorSaving value, $Res Function(NoteEditorSaving) _then) = _$NoteEditorSavingCopyWithImpl;
@useResult
$Res call({
 NoteEditorViewModel viewModel
});


$NoteEditorViewModelCopyWith<$Res> get viewModel;

}
/// @nodoc
class _$NoteEditorSavingCopyWithImpl<$Res>
    implements $NoteEditorSavingCopyWith<$Res> {
  _$NoteEditorSavingCopyWithImpl(this._self, this._then);

  final NoteEditorSaving _self;
  final $Res Function(NoteEditorSaving) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? viewModel = null,}) {
  return _then(NoteEditorSaving(
null == viewModel ? _self.viewModel : viewModel // ignore: cast_nullable_to_non_nullable
as NoteEditorViewModel,
  ));
}

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteEditorViewModelCopyWith<$Res> get viewModel {
  
  return $NoteEditorViewModelCopyWith<$Res>(_self.viewModel, (value) {
    return _then(_self.copyWith(viewModel: value));
  });
}
}

/// @nodoc


class NoteEditorSaved extends NoteEditorState {
  const NoteEditorSaved(this.viewModel): super._();
  

 final  NoteEditorViewModel viewModel;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorSavedCopyWith<NoteEditorSaved> get copyWith => _$NoteEditorSavedCopyWithImpl<NoteEditorSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorSaved&&(identical(other.viewModel, viewModel) || other.viewModel == viewModel));
}


@override
int get hashCode => Object.hash(runtimeType,viewModel);

@override
String toString() {
  return 'NoteEditorState.saved(viewModel: $viewModel)';
}


}

/// @nodoc
abstract mixin class $NoteEditorSavedCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory $NoteEditorSavedCopyWith(NoteEditorSaved value, $Res Function(NoteEditorSaved) _then) = _$NoteEditorSavedCopyWithImpl;
@useResult
$Res call({
 NoteEditorViewModel viewModel
});


$NoteEditorViewModelCopyWith<$Res> get viewModel;

}
/// @nodoc
class _$NoteEditorSavedCopyWithImpl<$Res>
    implements $NoteEditorSavedCopyWith<$Res> {
  _$NoteEditorSavedCopyWithImpl(this._self, this._then);

  final NoteEditorSaved _self;
  final $Res Function(NoteEditorSaved) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? viewModel = null,}) {
  return _then(NoteEditorSaved(
null == viewModel ? _self.viewModel : viewModel // ignore: cast_nullable_to_non_nullable
as NoteEditorViewModel,
  ));
}

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteEditorViewModelCopyWith<$Res> get viewModel {
  
  return $NoteEditorViewModelCopyWith<$Res>(_self.viewModel, (value) {
    return _then(_self.copyWith(viewModel: value));
  });
}
}

/// @nodoc


class NoteEditorSaveFailed extends NoteEditorState {
  const NoteEditorSaveFailed(this.viewModel, this.errorMessage): super._();
  

 final  NoteEditorViewModel viewModel;
 final  String errorMessage;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEditorSaveFailedCopyWith<NoteEditorSaveFailed> get copyWith => _$NoteEditorSaveFailedCopyWithImpl<NoteEditorSaveFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEditorSaveFailed&&(identical(other.viewModel, viewModel) || other.viewModel == viewModel)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,viewModel,errorMessage);

@override
String toString() {
  return 'NoteEditorState.saveFailed(viewModel: $viewModel, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $NoteEditorSaveFailedCopyWith<$Res> implements $NoteEditorStateCopyWith<$Res> {
  factory $NoteEditorSaveFailedCopyWith(NoteEditorSaveFailed value, $Res Function(NoteEditorSaveFailed) _then) = _$NoteEditorSaveFailedCopyWithImpl;
@useResult
$Res call({
 NoteEditorViewModel viewModel, String errorMessage
});


$NoteEditorViewModelCopyWith<$Res> get viewModel;

}
/// @nodoc
class _$NoteEditorSaveFailedCopyWithImpl<$Res>
    implements $NoteEditorSaveFailedCopyWith<$Res> {
  _$NoteEditorSaveFailedCopyWithImpl(this._self, this._then);

  final NoteEditorSaveFailed _self;
  final $Res Function(NoteEditorSaveFailed) _then;

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? viewModel = null,Object? errorMessage = null,}) {
  return _then(NoteEditorSaveFailed(
null == viewModel ? _self.viewModel : viewModel // ignore: cast_nullable_to_non_nullable
as NoteEditorViewModel,null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of NoteEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteEditorViewModelCopyWith<$Res> get viewModel {
  
  return $NoteEditorViewModelCopyWith<$Res>(_self.viewModel, (value) {
    return _then(_self.copyWith(viewModel: value));
  });
}
}

// dart format on
