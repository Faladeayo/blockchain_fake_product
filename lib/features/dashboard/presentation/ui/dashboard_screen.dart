import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/socket_repository.dart';
import 'widget/bottom_navigation_widget.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final Widget child;
  const DashboardScreen({required this.child, Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final socketRepo = SocketRepository();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      socketRepo.joinRoom("myRoom");
      socketRepo.changeListener(ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}
