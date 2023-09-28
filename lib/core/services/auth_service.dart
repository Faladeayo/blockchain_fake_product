import 'dart:convert';

import 'package:go_router/go_router.dart';

import '../../models/auth_user.dart';
import '../route/go_router_provider.dart';
import 'shared_service.dart';

class AuthService {
  AuthUser? authUser;
  bool? viewed;

  static AuthService instance = AuthService();

  login(Map<String, dynamic> userMap) async {
    authUser = AuthUser.fromJson(userMap);

    await setPreference('authUser', jsonEncode(authUser));
  }

  view(bool seen) async {
    viewed = seen;

    await storeBool('view', seen);
  }

  Future isViewed() async {
    bool? seen = await getBool("view");
    if (seen == null) {
      return false;
    }
    viewed = seen;
    return true;
  }

  Future load() async {
    String? userString = await getPreference('authUser');
    if (userString == null) {
      return false;
    }
    authUser = AuthUser.fromJson(jsonDecode(userString));

    return true;
  }

  Future logout() async {
    authUser = null;
    viewed = null;
    await removePreference("view");
    await removePreference('authUser');

    rootNavigator.currentContext!.goNamed(AppRoute.splash.name);
  }
}
