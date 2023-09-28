import 'package:flutter/material.dart';
import 'package:substandard_products/common/extension/extension.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../styles/dimens.dart';

class BorderButton extends StatelessWidget {
  const BorderButton(
      {super.key,
      this.buttonHeight = 50,
      required this.buttonText,
      required this.press});
  final int buttonHeight;
  final String buttonText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: context.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.onPrimary,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: context.primaryColor, width: 0.8),
              borderRadius: BorderRadius.circular(kSmall)),
          padding: const EdgeInsets.all(12),
        ),
        onPressed: press,
        child: Text(
          buttonText,
          style: context.labelLarge,
        ),
      ),
    );
  }
}
