import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/file.dart';

part 'file_state.freezed.dart';

@freezed
class FileState with _$FileState {
  factory FileState({
    @Default(<MyFile>[]) List<MyFile> files,
    @Default('') String errorMsg,
    @Default(false) bool isLoading,
  }) = _FileState;
}
