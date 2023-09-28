import 'package:flutter/material.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../styles/dimens.dart';

mixin ConfirmDialog {
  Future<void> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String msg,
    required String btnYesText,
    required String btnNoText,
    bool barrierDismissible = true,
    required VoidCallback onYesTap,
    required VoidCallback onNoTap,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kSmall),
            ),
            content: Container(
              padding: const EdgeInsets.only(
                top: kXLarge,
                bottom: kMedium,
                left: kMedium,
                right: kMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/image 1.png",
                    height: kLeadingWidth,
                  ),
                  const SizedBox(height: kMedium),
                  Text(title, style: context.labelLarge),
                  const SizedBox(height: kMedium),
                  Text(
                    msg,
                    style: context.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kLarge),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.errorColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kSmall)),
                        ),
                        onPressed: onNoTap,
                        icon: Icon(Icons.close, color: context.onPrimary),
                        label: Text(
                          btnNoText,
                          style: context.titleMedium!
                              .copyWith(color: context.onPrimary),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kSmall)),
                        ),
                        onPressed: onYesTap,
                        icon: Icon(Icons.check, color: context.onPrimary),
                        label: Text(
                          btnYesText,
                          style: context.titleMedium!
                              .copyWith(color: context.onPrimary),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
