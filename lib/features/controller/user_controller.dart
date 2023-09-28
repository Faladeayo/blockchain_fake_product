import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../api/auth_api_service.dart';
import '../../core/provider/is_internet_connected_provider.dart';

import 'state/user_state.dart';

final userControllerProvider =
    StateNotifierProvider<UserController, UserState>((ref) {
  final connectivity = ref.watch(isInternetConnectedProvider);
  final chatAPI = ref.watch(authAPIProvider);
  return UserController(chatAPI: chatAPI, connectivity: connectivity, ref: ref);
});

class UserController extends StateNotifier<UserState> {
  UserController({
    required AuthAPI chatAPI,
    required Ref ref,
    required InternetConnectionObserver connectivity,
  })  : _chatAPI = chatAPI,
        _connectivity = connectivity,
        super(UserState());
  final AuthAPI _chatAPI;

  final InternetConnectionObserver _connectivity;

  void users({
    required BuildContext context,
  }) async {
    final connection = await _connectivity.isNetConnected();
    if (connection) {
      state = state.copyWith(isLoading: true);
      final res = await _chatAPI.users();
      state = state.copyWith(isLoading: false);

      res.fold(
        (l) {
          state = state.copyWith(errorMsg: l.message);
          context.showSnackBar(l.message, color: context.errorColor);
        },
        (r) {
          state = state.copyWith(users: r);
        },
      );
    } else {
      context.showSnackBar("You dont have an active internet connection ",
          color: context.errorColor);
    }
  }
}
