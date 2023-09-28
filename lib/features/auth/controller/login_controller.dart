// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../../api/auth_api_service.dart';
import '../../../core/provider/is_internet_connected_provider.dart';
import '../../../core/route/go_router_provider.dart';
import '../../controller/files_controller.dart';

final rememberMeNotifier = StateProvider<bool>((ref) => false);

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final connectivity = ref.watch(isInternetConnectedProvider);
  final authAPI = ref.watch(authAPIProvider);
  return AuthController(authAPI: authAPI, connectivity: connectivity, ref: ref);
});

class AuthController extends StateNotifier<bool> {
  AuthController({
    required AuthAPI authAPI,
    required Ref ref,
    required InternetConnectionObserver connectivity,
  })  : _authAPI = authAPI,
        _connectivity = connectivity,
        _ref = ref,
        super(false);
  final AuthAPI _authAPI;
  final Ref _ref;
  final InternetConnectionObserver _connectivity;

  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final connection = await _connectivity.isNetConnected();
    if (connection) {
      state = true;
      final res = await _authAPI.login(email: email, password: password);
      state = false;

      res.fold(
        (l) {
          context.showSnackBar(l.message, color: context.errorColor);
        },
        (r) {
          //context.showToast("Welcome back ${r.name}");
          context.showSnackBar("Welcome back ${r.name}");
          context.goNamed(AppRoute.home.name);
        },
      );
    } else {
      context.showSnackBar("No Internet!!!!", color: context.errorColor);
    }
  }

  void share({
    required BuildContext context,
    required String uploadId,
    required String userId,
  }) async {
    final connection = await _connectivity.isNetConnected();
    if (connection) {
      state = true;
      final res = await _authAPI.share(uploadId: uploadId, userId: userId);
      state = false;

      res.fold(
        (l) {
          context.showSnackBar(l.message, color: context.errorColor);
        },
        (r) {
          context.showSnackBar("File shared Successfully", color: Colors.green);
        },
      );
    } else {
      context.showSnackBar("No Internet!!!!", color: context.errorColor);
    }
  }

  void upload({
    required BuildContext context,
    required String description,
    required File file,
    required String price,
    required bool blocked,
  }) async {
    final connection = await _connectivity.isNetConnected();
    if (connection) {
      state = true;
      final res = await _authAPI.upload(
          file: file, description: description, price: price, blocked: blocked);
      state = false;

      res.fold(
        (l) {
          context.showSnackBar(l.message, color: context.errorColor);
        },
        (r) {
          _ref.read(fileControllerProvider.notifier).files(context: context);
          context.showSnackBar("Product uploaded Successfully",
              color: Colors.green);
          context.pop();
        },
      );
    } else {
      context.showSnackBar("No Internet!!!!", color: context.errorColor);
    }
  }
}
