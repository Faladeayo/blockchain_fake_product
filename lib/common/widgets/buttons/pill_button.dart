import 'package:flutter/material.dart';
import 'package:substandard_products/common/extension/text_styles.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../../styles/dimens.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.backGroundColor,
    required this.textColor,
    required this.text,
    required this.child,
    required this.ontap,
  });
  final Color backGroundColor;
  final Color textColor;
  final String text;
  final Widget child;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: backGroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kSmall))),
        onPressed: () {
          ontap();
        },
        icon: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.onPrimary,
          ),
          child: child,
        ),
        label: Text(
          text,
          style: context.bodySmall!.copyWith(color: textColor),
        ));
  }
}
