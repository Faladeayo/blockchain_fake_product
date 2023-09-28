// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FileState {
  List<MyFile> get files => throw _privateConstructorUsedError;
  String get errorMsg => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FileStateCopyWith<FileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileStateCopyWith<$Res> {
  factory $FileStateCopyWith(FileState value, $Res Function(FileState) then) =
      _$FileStateCopyWithImpl<$Res, FileState>;
  @useResult
  $Res call({List<MyFile> files, String errorMsg, bool isLoading});
}

/// @nodoc
class _$FileStateCopyWithImpl<$Res, $Val extends FileState>
    implements $FileStateCopyWith<$Res> {
  _$FileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? errorMsg = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<MyFile>,
      errorMsg: null == errorMsg
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FileStateCopyWith<$Res> implements $FileStateCopyWith<$Res> {
  factory _$$_FileStateCopyWith(
          _$_FileState value, $Res Function(_$_FileState) then) =
      __$$_FileStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MyFile> files, String errorMsg, bool isLoading});
}

/// @nodoc
class __$$_FileStateCopyWithImpl<$Res>
    extends _$FileStateCopyWithImpl<$Res, _$_FileState>
    implements _$$_FileStateCopyWith<$Res> {
  __$$_FileStateCopyWithImpl(
      _$_FileState _value, $Res Function(_$_FileState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? errorMsg = null,
    Object? isLoading = null,
  }) {
    return _then(_$_FileState(
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<MyFile>,
      errorMsg: null == errorMsg
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_FileState implements _FileState {
  _$_FileState(
      {final List<MyFile> files = const <MyFile>[],
      this.errorMsg = '',
      this.isLoading = false})
      : _files = files;

  final List<MyFile> _files;
  @override
  @JsonKey()
  List<MyFile> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  @JsonKey()
  final String errorMsg;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'FileState(files: $files, errorMsg: $errorMsg, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FileState &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.errorMsg, errorMsg) ||
                other.errorMsg == errorMsg) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_files), errorMsg, isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FileStateCopyWith<_$_FileState> get copyWith =>
      __$$_FileStateCopyWithImpl<_$_FileState>(this, _$identity);
}

abstract class _FileState implements FileState {
  factory _FileState(
      {final List<MyFile> files,
      final String errorMsg,
      final bool isLoading}) = _$_FileState;

  @override
  List<MyFile> get files;
  @override
  String get errorMsg;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$_FileStateCopyWith<_$_FileState> get copyWith =>
      throw _privateConstructorUsedError;
}
