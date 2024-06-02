import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ProgressHUDUtil {
  static void show(BuildContext context, String text) {
    final progress = ProgressHUD.of(context);
    progress?.showWithText(text);
  }

  static void dismiss(BuildContext context) {
    final progress = ProgressHUD.of(context);
    progress?.dismiss();
  }
}
