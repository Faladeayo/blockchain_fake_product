import 'package:flutter/material.dart';
import 'package:substandard_products/common/extension/extension.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../styles/dimens.dart';

class FullWidthButton extends StatelessWidget {
  const FullWidthButton(
      {super.key,
      this.color,
      this.textColor,
      this.buttonHeight = 50.0,
      required this.buttonText,
      required this.press});
  final double buttonHeight;
  final String buttonText;
  final Color? color, textColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: context.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? context.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kSmall)),
          padding: const EdgeInsets.all(12),
        ),
        onPressed: press,
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 16,
              color: textColor ?? context.onPrimary,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
