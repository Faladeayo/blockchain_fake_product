import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';
import 'package:substandard_products/core/services/auth_service.dart';

import '../../common/styles/dimens.dart';
import '../../common/widgets/buttons/full_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //ref.read(userControllerProvider.notifier).getUser(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.background,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {},
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.only(top: kSmall),
                          margin:
                              const EdgeInsets.symmetric(horizontal: kMedium),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Profile",
                                style: context.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kXLarge,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: context.primaryColorLight,
                                        width: 0.8)),
                                child: CircleAvatar(
                                  radius: kXXXXLarge,
                                  //backgroundColor: context.primaryColorLight,
                                  child: Text(
                                      AuthService.instance.authUser!.name![0],
                                      style: context.titleLarge!
                                          .copyWith(color: context.onPrimary)),
                                )),
                            const SizedBox(
                              height: kMedium,
                            ),
                            Text("${AuthService.instance.authUser!.name}",
                                style: context.headlineMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black45)),
                            Text(
                              "${AuthService.instance.authUser!.email}",
                              style: context.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: kXXXLarge,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: kMedium),
                        child: FullWidthButton(
                            buttonText: "Logout",
                            press: () async {
                              AuthService.instance.logout();
                            }),
                      ),
                      const SizedBox(
                        height: kLarge,
                      ),
                    ]),
              ),
            ),
          ],
        ));
  }
}
