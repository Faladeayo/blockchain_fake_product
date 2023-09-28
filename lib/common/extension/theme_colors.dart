import 'package:flutter/material.dart';

extension BuildContextEntension<T> on BuildContext {
  // colors
  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  Color get primaryColorContainer =>
      Theme.of(this).colorScheme.primaryContainer;

  Color get primary => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get scaffoldColor => Theme.of(this).scaffoldBackgroundColor;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  Color get tertially => Theme.of(this).colorScheme.tertiary;

  Color get cardColor => Theme.of(this).cardColor;

  Color get errorColor => Theme.of(this).colorScheme.error;

  Color get background => Theme.of(this).colorScheme.background;
}
