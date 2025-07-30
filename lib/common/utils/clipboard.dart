import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyToClipboard(BuildContext context, String value) {
  Clipboard.setData(ClipboardData(text: value));
}
