import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:substandard_products/common/extension/extension.dart';
import 'package:substandard_products/common/extension/theme_colors.dart';

import '../styles/dimens.dart';

extension BuildContextEntension<T> on BuildContext {
  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) => Wrap(children: [child]),
    );
  }

// //Define my own custom snackbar using the default material widgets
//   ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
//       String message,
//       {Color? color}) {
//     return ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           textAlign: TextAlign.center,
//         ),
//         backgroundColor: color,
//         showCloseIcon: true,
//         closeIconColor: Colors.white,
//         duration: const Duration(seconds: 5),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   showSnackBar(
//     String message, {
//     String? title,
//     Color? color,
//   }) {
// // It's a plugin to show toast and we can with extension
//     return Flushbar(
//       title: title,
//       message: message,
//       maxWidth: width * 0.8,
//       backgroundColor: color ?? primaryColor,
//       flushbarPosition: FlushbarPosition.TOP,
//       isDismissible: true,
//       margin: const EdgeInsets.only(top: kSmall),
//       // backgroundGradient:
//       //     LinearGradient(colors: [this.secondary, this.primaryColorLight]),
//       duration: const Duration(seconds: 5),
//       borderRadius: BorderRadius.circular(kSmall),
//       flushbarStyle: FlushbarStyle.FLOATING,
//       forwardAnimationCurve: Curves.decelerate,
//       reverseAnimationCurve: Curves.easeOut,
//       icon: Icon(
//         Icons.info_outline,
//         size: 28.0,
//         color: onPrimary,
//       ),
//       leftBarIndicatorColor: primaryColorLight,
//     )..show(this);
//   }

  Future<bool?> showSnackBar(
    String message, {
    Color? color,
  }) {
// It's a plugin to show toast and we can with extension
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color ?? primary,
      textColor: onPrimary,
    );
  }
}
