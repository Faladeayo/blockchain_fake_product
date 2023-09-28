import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:substandard_products/common/urls.dart';
import 'package:substandard_products/models/notifications.dart';

import '../core/failure/failure.dart';
import '../core/remote/network_service.dart';
import '../core/services/auth_service.dart';
import '../core/type_def.dart';

import '../models/auth_user.dart';
import '../models/file.dart';

final authAPIProvider = Provider((ref) {
  final dio = ref.read(networkServiceProvider);
  return AuthAPI(dio: dio);
});

abstract class IAuthAPI {
  FutureEither<AuthUser> login({
    required String email,
    required String password,
  });
  Future<List<Nitifications>> notifications();

  FutureEither<AuthUser> register({
    required String name,
    required String email,
    required String password,
  });
  FutureEither<bool> share({
    required String uploadId,
    required String userId,
  });
  FutureEither<List<MyFile>> files();
  FutureEither<List<User>> users();
  FutureEither<bool> upload({
    required File file,
    required String description,
    required String price,
    required bool blocked,
  });
}

class AuthAPI implements IAuthAPI {
  final Dio _dio;
  AuthAPI({required Dio dio}) : _dio = dio;

  @override
  FutureEither<AuthUser> login(
      {required String email, required String password}) async {
    try {
      final res = await _dio.post(Urls.login, data: {
        "email": email,
        "password": password,
      });

      AuthService.instance.login(res.data);
      return right(AuthUser.fromJson(res.data));
    } on DioError catch (e, s) {
      // final errorMessage = DioExceptions.fromDioError(e);
      // return left(Failure(message: errorMessage.message, stackTrace: s));
      if (e.type == DioErrorType.badResponse) {
        if (e.response!.statusCode == 400) {
          return left(Failure(message: e.response!.data['msg'], stackTrace: s));
        } else if (e.response!.statusCode == 422) {
          String? emailError = e.response!.data['email'];
          String? error = e.response!.data['message'];
          return left(Failure(
              message: error ?? emailError ?? e.response!.data, stackTrace: s));
        }
      } else if (e.type == DioErrorType.connectionError) {
        return left(
            Failure(message: e.message ?? "Connection Error", stackTrace: s));
      } else if (e.type == DioErrorType.connectionTimeout) {
        return left(
            Failure(message: e.message ?? "Connection Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.receiveTimeout) {
        return left(
            Failure(message: e.message ?? "Receive Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.sendTimeout) {
        return left(
            Failure(message: e.message ?? "Send Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.cancel) {
        return left(Failure(
            message: e.message ?? "Connection Canceled", stackTrace: s));
      }
      return left(
          Failure(message: e.message ?? "Something went wrong", stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  FutureEither<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(Urls.register, data: {
        "name": name,
        "email": email,
        "password": password,
      });

      return right(AuthUser.fromJson(res.data));
    } on DioError catch (e, s) {
      if (e.type == DioErrorType.badResponse) {
        if (e.response!.statusCode == 400) {
          return left(Failure(message: e.response!.data['msg'], stackTrace: s));
        } else if (e.response!.statusCode == 422) {
          return left(
              Failure(message: e.response!.data["message"], stackTrace: s));
        }
      } else if (e.type == DioErrorType.connectionError) {
        return left(
            Failure(message: e.message ?? "Connection Error", stackTrace: s));
      } else if (e.type == DioErrorType.connectionTimeout) {
        return left(
            Failure(message: e.message ?? "Connection Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.receiveTimeout) {
        return left(
            Failure(message: e.message ?? "Receive Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.sendTimeout) {
        return left(
            Failure(message: e.message ?? "Send Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.cancel) {
        return left(Failure(
            message: e.message ?? "Connection Canceled", stackTrace: s));
      }
      return left(
          Failure(message: e.message ?? "Something went wrong", stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  FutureEither<List<MyFile>> files() async {
    try {
      final res = await _dio.get(
        Urls.files,
      );

      return right(myfilesFromJson(res.data));
    } on DioError catch (e, s) {
      if (e.type == DioErrorType.badResponse) {
        if (e.response!.statusCode == 400) {
          return left(Failure(message: e.response!.data['msg'], stackTrace: s));
        } else if (e.response!.statusCode == 401) {
          return left(Failure(message: e.response!.data["msg"], stackTrace: s));
        }
      } else if (e.type == DioErrorType.connectionError) {
        return left(
            Failure(message: e.message ?? "Connection Error", stackTrace: s));
      } else if (e.type == DioErrorType.connectionTimeout) {
        return left(
            Failure(message: e.message ?? "Connection Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.receiveTimeout) {
        return left(
            Failure(message: e.message ?? "Receive Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.sendTimeout) {
        return left(
            Failure(message: e.message ?? "Send Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.cancel) {
        return left(Failure(
            message: e.message ?? "Connection Canceled", stackTrace: s));
      }
      return left(
          Failure(message: e.message ?? "Something went wrong", stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  FutureEither<List<User>> users() async {
    try {
      final res = await _dio.get(
        Urls.users,
      );

      return right(usersFromJson(res.data));
    } on DioError catch (e, s) {
      if (e.type == DioErrorType.badResponse) {
        if (e.response!.statusCode == 400) {
          return left(Failure(message: e.response!.data['msg'], stackTrace: s));
        } else if (e.response!.statusCode == 422) {
          return left(
              Failure(message: e.response!.data["message"], stackTrace: s));
        }
      } else if (e.type == DioErrorType.connectionError) {
        return left(
            Failure(message: e.message ?? "Connection Error", stackTrace: s));
      } else if (e.type == DioErrorType.connectionTimeout) {
        return left(
            Failure(message: e.message ?? "Connection Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.receiveTimeout) {
        return left(
            Failure(message: e.message ?? "Receive Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.sendTimeout) {
        return left(
            Failure(message: e.message ?? "Send Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.cancel) {
        return left(Failure(
            message: e.message ?? "Connection Canceled", stackTrace: s));
      }
      return left(
          Failure(message: e.message ?? "Something went wrong", stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  FutureEither<bool> share(
      {required String uploadId, required String userId}) async {
    try {
      final res = await _dio
          .post(Urls.share, data: {"uploadId": uploadId, "userId": userId});

      return right(true);
    } on DioError catch (e, s) {
      if (e.type == DioErrorType.badResponse) {
        if (e.response!.statusCode == 403) {
          return left(
              Failure(message: e.response!.data['error'], stackTrace: s));
        } else if (e.response!.statusCode == 422) {
          return left(
              Failure(message: e.response!.data["message"], stackTrace: s));
        }
      } else if (e.type == DioErrorType.connectionError) {
        return left(
            Failure(message: e.message ?? "Connection Error", stackTrace: s));
      } else if (e.type == DioErrorType.connectionTimeout) {
        return left(
            Failure(message: e.message ?? "Connection Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.receiveTimeout) {
        return left(
            Failure(message: e.message ?? "Receive Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.sendTimeout) {
        return left(
            Failure(message: e.message ?? "Send Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.cancel) {
        return left(Failure(
            message: e.message ?? "Connection Canceled", stackTrace: s));
      }
      return left(
          Failure(message: e.message ?? "Something went wrong", stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  FutureEither<bool> upload({
    required File file,
    required String description,
    required String price,
    required bool blocked,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "name": await MultipartFile.fromFile(file.path, filename: fileName),
        "description": description,
        "price": price,
        "blocked": blocked,
      });
      final res = await _dio.post(Urls.upload, data: formData);

      return right(true);
    } on DioError catch (e, s) {
      if (e.type == DioErrorType.badResponse) {
        if (e.response!.statusCode == 403) {
          return left(
              Failure(message: e.response!.data['error'], stackTrace: s));
        } else if (e.response!.statusCode == 500) {
          return left(
              Failure(message: e.response!.data["error"], stackTrace: s));
        }
      } else if (e.type == DioErrorType.connectionError) {
        return left(
            Failure(message: e.message ?? "Connection Error", stackTrace: s));
      } else if (e.type == DioErrorType.connectionTimeout) {
        return left(
            Failure(message: e.message ?? "Connection Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.receiveTimeout) {
        return left(
            Failure(message: e.message ?? "Receive Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.sendTimeout) {
        return left(
            Failure(message: e.message ?? "Send Timeout", stackTrace: s));
      } else if (e.type == DioErrorType.cancel) {
        return left(Failure(
            message: e.message ?? "Connection Canceled", stackTrace: s));
      }
      return left(
          Failure(message: e.message ?? "Something went wrong", stackTrace: s));
    } catch (e, s) {
      return left(Failure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  Future<List<Nitifications>> notifications() async {
    try {
      final res = await _dio.get(Urls.notifications);

      return mynotificationsFromJson(res.data);
    } on DioError catch (e, s) {
      throw e.message ?? "Something went wrong";
    } catch (e, s) {
      rethrow;
    }
  }
}
