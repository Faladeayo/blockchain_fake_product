import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../../../controller/files_controller.dart';
import '../../controller/dashboard_controller.dart';

class BottomNavigationWidget extends ConsumerStatefulWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomNavigationWidget> createState() =>
      _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState
    extends ConsumerState<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    final position = ref.watch(dashboardControllerProvider);

    return BottomNavigationBar(
      backgroundColor: context.primaryColorLight,
      currentIndex: position,
      onTap: (value) => _onTap(value),
      // selectedItemColor: Colors.white,
      // unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      // selectedLabelStyle: const TextStyle(
      //   color: Colors.white,
      //   fontSize: 14,
      //   fontWeight: FontWeight.w700,
      // ),
      // unselectedLabelStyle: const TextStyle(
      //   color: Colors.grey,
      //   fontSize: 12,
      //   fontWeight: FontWeight.w500,
      // ),
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(CupertinoIcons.house_fill),
          icon: Icon(CupertinoIcons.house),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(CupertinoIcons.bell),
          icon: Icon(CupertinoIcons.bell_fill),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(CupertinoIcons.person_fill),
          icon: Icon(CupertinoIcons.person),
          label: 'Account',
        ),
      ],
    );
  }

  void _onTap(int index) {
    ref.read(dashboardControllerProvider.notifier).setPosition(index);

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        ref.refresh(notificationsProvider.future);
        context.go('/share');
        break;
      case 2:
        context.go('/account');
        break;
      default:
    }
  }
}
