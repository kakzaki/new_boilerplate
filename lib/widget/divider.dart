import 'package:flutter/material.dart';
import '../provider/theme_provider.dart';

divider(
    {required BuildContext context,
    double indent = 0,
    double endIndent = 0,
    Color? color}) {
  return Divider(
    indent: indent,
    endIndent: endIndent,
    height: 1,
    thickness: 1,
    color: color ?? theme(context).colorFont,
  );
}
