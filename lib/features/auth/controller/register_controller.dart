import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../../api/auth_api_service.dart';
import '../../../core/provider/is_internet_connected_provider.dart';
import '../../../core/route/go_router_provider.dart';

final registerGlobalKey =
    Provider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());
final passwordController = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final accepTermsNotifier = StateProvider<bool>((ref) => false);

final registerControllerProvider =
    StateNotifierProvider<RegisterController, bool>((ref) {
  final connectivity = ref.watch(isInternetConnectedProvider);
  final authAPI = ref.watch(authAPIProvider);
  return RegisterController(
      authAPI: authAPI, connectivity: connectivity, ref: ref);
});

class RegisterController extends StateNotifier<bool> {
  RegisterController(
      {required AuthAPI authAPI,
      required Ref ref,
      required InternetConnectionObserver connectivity})
      : _authAPI = authAPI,
        _ref = ref,
        _connectivity = connectivity,
        super(false);
  final AuthAPI _authAPI;
  final Ref _ref;
  final InternetConnectionObserver _connectivity;

  void register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final connection = await _connectivity.isNetConnected();
    if (connection) {
      state = true;
      final res =
          await _authAPI.register(name: name, email: email, password: password);
      state = false;

      res.fold((l) {
        context.showSnackBar(l.message, color: context.errorColor);
      }, (r) {
        context.goNamed(
          AppRoute.login.name,
        );
      });
    } else {
      context.showSnackBar("No Internet!!!!", color: context.errorColor);
    }
  }

  bool validateSave() {
    final form = _ref.read(registerGlobalKey).currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
