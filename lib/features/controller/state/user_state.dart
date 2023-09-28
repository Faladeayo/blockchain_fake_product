import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/file.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  factory UserState({
    @Default(<User>[]) List<User> users,
    @Default('') String errorMsg,
    @Default(false) bool isLoading,
  }) = _UserState;
}
