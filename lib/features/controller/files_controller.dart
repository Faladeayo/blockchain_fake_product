import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';
import 'package:substandard_products/models/notifications.dart';

import '../../api/auth_api_service.dart';
import '../../core/provider/is_internet_connected_provider.dart';
import 'state/file_state.dart';

final notificationsProvider = FutureProvider<List<Nitifications>>((ref) async {
  final api = ref.watch(authAPIProvider);
  return api.notifications();
});
final fileControllerProvider =
    StateNotifierProvider<FileController, FileState>((ref) {
  final connectivity = ref.watch(isInternetConnectedProvider);
  final chatAPI = ref.watch(authAPIProvider);
  return FileController(chatAPI: chatAPI, connectivity: connectivity, ref: ref);
});

class FileController extends StateNotifier<FileState> {
  FileController({
    required AuthAPI chatAPI,
    required Ref ref,
    required InternetConnectionObserver connectivity,
  })  : _chatAPI = chatAPI,
        _connectivity = connectivity,
        super(FileState());
  final AuthAPI _chatAPI;

  final InternetConnectionObserver _connectivity;

  void files({
    required BuildContext context,
  }) async {
    final connection = await _connectivity.isNetConnected();
    if (connection) {
      state = state.copyWith(isLoading: true);
      final res = await _chatAPI.files();
      state = state.copyWith(isLoading: false);

      res.fold(
        (l) {
          state = state.copyWith(errorMsg: l.message);
          context.showSnackBar(l.message, color: context.errorColor);
        },
        (r) {
          state = state.copyWith(files: r);
        },
      );
    } else {
      context.showSnackBar("You dont have an active internet connection ",
          color: context.errorColor);
    }
  }
}
