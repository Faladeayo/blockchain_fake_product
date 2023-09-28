import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:substandard_products/common/extension/extension.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../styles/dimens.dart';

class CustomLoader extends ConsumerWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: context.height,
      width: context.width,
      color: Colors.black12,
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: context.primaryColor,
          size: kLeadingWidth * 0.4,
        ),
      ),
    );
  }
}
