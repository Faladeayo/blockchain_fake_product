import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../assets_constants.dart';
import '../../styles/dimens.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // final googleLoading = ref.watch(googleSigninController);
        // final registerLoading = ref.watch(registerControllerProvider);
        return GestureDetector(
          onTap: () {
            // ref
            //     .read(googleSigninController.notifier)
            //     .signingWithGoogle(context: context);
          },
          child: Container(
            height: 60.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kSmall),
                border:
                    Border.all(color: context.primaryColorDark, width: 0.6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(AssetContants.googleImage, height: 20),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Sign In with Google",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
