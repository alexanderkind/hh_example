import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

T useThemeExtension<T>() {
  final theme = Theme.of(useContext());

  return theme.extension<T>() as T;
}
