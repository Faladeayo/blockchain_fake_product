import 'package:flutter/material.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../styles/dimens.dart';

class NoInternetBanner extends StatelessWidget {
  const NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      transform: Matrix4.skewX(-0.2), // Applying a slant effect
      decoration: BoxDecoration(
        color: context.errorColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kSmall),
          bottomLeft: Radius.circular(kSmall),
          bottomRight: Radius.circular(kSmall),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, color: context.onPrimary, size: kMedium),
          const SizedBox(width: kSmall),
          Text('Offline',
              style: context.labelLarge!.copyWith(
                  color: context.onPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
