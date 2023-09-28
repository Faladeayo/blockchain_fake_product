import 'package:flutter_riverpod/flutter_riverpod.dart';

/// dashboardControllerProvider provides the current bottom navigation page index
final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, int>((ref) {
  return DashboardController(0);
});

class DashboardController extends StateNotifier<int> {
  DashboardController(super.state);

  void setPosition(int value) {
    state = value;
  }
}
