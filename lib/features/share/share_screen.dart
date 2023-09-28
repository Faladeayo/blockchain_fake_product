import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../common/loader/custom_loader.dart';

import '../../common/styles/dimens.dart';
import '../../core/socket_repository.dart';
import '../controller/files_controller.dart';

class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    final notiState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text("Nofitication"),
      ),
      body: notiState.when(
        data: (noti) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(notificationsProvider.future),
            child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    vertical: kMedium, horizontal: kMedium),
                itemCount: noti.length,
                itemBuilder: (context, index) {
                  final item = noti[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: ListTile(
                      tileColor: context.secondary,
                      title: Text(item.name!),
                      subtitle: Text(item.description!),
                    ),
                  );
                }),
          );
        },
        error: (error, s) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () => const Center(
          child: CustomLoader(),
        ),
      ),
    );
  }
}
