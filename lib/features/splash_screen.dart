// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:substandard_products/common/extension/extension.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../common/assets_constants.dart';
import '../common/styles/dimens.dart';
import '../core/route/go_router_provider.dart';
import '../core/services/auth_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  int _progress = 20;
  Timer? _timer;
  @override
  @override
  void initState() {
    super.initState();

    // initialize Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _progress += 20;
      });

      if (_progress == 100) {
        _timer?.cancel();
      }
    });

    /// Animation Controller
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldColor,
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kXLarge),
                child: ScaleTransition(
                  scale: animation,
                  child: Image(
                      image: const AssetImage(AssetContants.appLogo),
                      height: context.height * 0.25),
                ),
              ),
            ),
            Positioned(
                bottom: kXXXXLarge,
                right: 0,
                left: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kLeadingWidth),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(kMedium),
                        child: LinearProgressIndicator(
                          minHeight: kXSmall,
                          backgroundColor: context.primaryColorLight,
                          value: _progress / 100.0,
                        ),
                      ),
                      const SizedBox(
                        height: kSmall,
                      ),
                      Text(
                        '$_progress%',
                        style: context.bodySmall,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _checkUser() async {
    bool found = await AuthService.instance.load();

    if (!found) {
      Future.delayed(const Duration(seconds: 6), () async {
        context.goNamed(AppRoute.login.name);
      });
    } else {
      Future.delayed(
        const Duration(seconds: 6),
        () async {
          context.goNamed(AppRoute.home.name);
        },
      );
    }
  }
}
