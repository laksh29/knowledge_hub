// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState()';
}


}

/// @nodoc
class $SearchStateCopyWith<$Res>  {
$SearchStateCopyWith(SearchState _, $Res Function(SearchState) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchInitial value)?  initial,TResult Function( SearchSearching value)?  searching,TResult Function( SearchResultsLoaded value)?  results,TResult Function( SearchNoResults value)?  noResults,TResult Function( SearchFailed value)?  searchFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchSearching() when searching != null:
return searching(_that);case SearchResultsLoaded() when results != null:
return results(_that);case SearchNoResults() when noResults != null:
return noResults(_that);case SearchFailed() when searchFailed != null:
return searchFailed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchInitial value)  initial,required TResult Function( SearchSearching value)  searching,required TResult Function( SearchResultsLoaded value)  results,required TResult Function( SearchNoResults value)  noResults,required TResult Function( SearchFailed value)  searchFailed,}){
final _that = this;
switch (_that) {
case SearchInitial():
return initial(_that);case SearchSearching():
return searching(_that);case SearchResultsLoaded():
return results(_that);case SearchNoResults():
return noResults(_that);case SearchFailed():
return searchFailed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchInitial value)?  initial,TResult? Function( SearchSearching value)?  searching,TResult? Function( SearchResultsLoaded value)?  results,TResult? Function( SearchNoResults value)?  noResults,TResult? Function( SearchFailed value)?  searchFailed,}){
final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial(_that);case SearchSearching() when searching != null:
return searching(_that);case SearchResultsLoaded() when results != null:
return results(_that);case SearchNoResults() when noResults != null:
return noResults(_that);case SearchFailed() when searchFailed != null:
return searchFailed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  searching,TResult Function( List<NoteSearchResultViewModel> viewModels)?  results,TResult Function()?  noResults,TResult Function( String errorMessage)?  searchFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial();case SearchSearching() when searching != null:
return searching();case SearchResultsLoaded() when results != null:
return results(_that.viewModels);case SearchNoResults() when noResults != null:
return noResults();case SearchFailed() when searchFailed != null:
return searchFailed(_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  searching,required TResult Function( List<NoteSearchResultViewModel> viewModels)  results,required TResult Function()  noResults,required TResult Function( String errorMessage)  searchFailed,}) {final _that = this;
switch (_that) {
case SearchInitial():
return initial();case SearchSearching():
return searching();case SearchResultsLoaded():
return results(_that.viewModels);case SearchNoResults():
return noResults();case SearchFailed():
return searchFailed(_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  searching,TResult? Function( List<NoteSearchResultViewModel> viewModels)?  results,TResult? Function()?  noResults,TResult? Function( String errorMessage)?  searchFailed,}) {final _that = this;
switch (_that) {
case SearchInitial() when initial != null:
return initial();case SearchSearching() when searching != null:
return searching();case SearchResultsLoaded() when results != null:
return results(_that.viewModels);case SearchNoResults() when noResults != null:
return noResults();case SearchFailed() when searchFailed != null:
return searchFailed(_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class SearchInitial implements SearchState {
  const SearchInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.initial()';
}


}




/// @nodoc


class SearchSearching implements SearchState {
  const SearchSearching();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSearching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.searching()';
}


}




/// @nodoc


class SearchResultsLoaded implements SearchState {
  const SearchResultsLoaded(final  List<NoteSearchResultViewModel> viewModels): _viewModels = viewModels;
  

 final  List<NoteSearchResultViewModel> _viewModels;
 List<NoteSearchResultViewModel> get viewModels {
  if (_viewModels is EqualUnmodifiableListView) return _viewModels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_viewModels);
}


/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultsLoadedCopyWith<SearchResultsLoaded> get copyWith => _$SearchResultsLoadedCopyWithImpl<SearchResultsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultsLoaded&&const DeepCollectionEquality().equals(other._viewModels, _viewModels));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_viewModels));

@override
String toString() {
  return 'SearchState.results(viewModels: $viewModels)';
}


}

/// @nodoc
abstract mixin class $SearchResultsLoadedCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchResultsLoadedCopyWith(SearchResultsLoaded value, $Res Function(SearchResultsLoaded) _then) = _$SearchResultsLoadedCopyWithImpl;
@useResult
$Res call({
 List<NoteSearchResultViewModel> viewModels
});




}
/// @nodoc
class _$SearchResultsLoadedCopyWithImpl<$Res>
    implements $SearchResultsLoadedCopyWith<$Res> {
  _$SearchResultsLoadedCopyWithImpl(this._self, this._then);

  final SearchResultsLoaded _self;
  final $Res Function(SearchResultsLoaded) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? viewModels = null,}) {
  return _then(SearchResultsLoaded(
null == viewModels ? _self._viewModels : viewModels // ignore: cast_nullable_to_non_nullable
as List<NoteSearchResultViewModel>,
  ));
}


}

/// @nodoc


class SearchNoResults implements SearchState {
  const SearchNoResults();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchNoResults);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.noResults()';
}


}




/// @nodoc


class SearchFailed implements SearchState {
  const SearchFailed(this.errorMessage);
  

 final  String errorMessage;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFailedCopyWith<SearchFailed> get copyWith => _$SearchFailedCopyWithImpl<SearchFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFailed&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,errorMessage);

@override
String toString() {
  return 'SearchState.searchFailed(errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SearchFailedCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchFailedCopyWith(SearchFailed value, $Res Function(SearchFailed) _then) = _$SearchFailedCopyWithImpl;
@useResult
$Res call({
 String errorMessage
});




}
/// @nodoc
class _$SearchFailedCopyWithImpl<$Res>
    implements $SearchFailedCopyWith<$Res> {
  _$SearchFailedCopyWithImpl(this._self, this._then);

  final SearchFailed _self;
  final $Res Function(SearchFailed) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMessage = null,}) {
  return _then(SearchFailed(
null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
