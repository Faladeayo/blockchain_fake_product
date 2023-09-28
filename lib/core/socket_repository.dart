import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:substandard_products/common/extension/pop_ups.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';
import 'package:substandard_products/core/route/go_router_provider.dart';
import 'package:substandard_products/features/controller/files_controller.dart';
import 'remote/socket_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  void joinRoom(String userId) {
    _socketClient.emit('join', userId);
    //_socketClient.emit('join', documentId);
  }

  void changeListener(WidgetRef ref) {
    _socketClient.on('notifications', (data) {
      ref.read(notificationsProvider.future);
      rootNavigator.currentContext!.showSnackBar(
          "You have a counterfeit notification",
          color: rootNavigator.currentContext!.errorColor);
    });
  }
}
