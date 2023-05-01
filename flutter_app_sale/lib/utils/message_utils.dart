import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

class MessageUtils {
  static void showMessage([
    BuildContext? context,
    String? title,
    String? message,
    List<SingleChildWidget>? actionsAlert
  ]) {
    if (context == null) return;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (title == null || title.isEmpty) ? null : Text(title),
          content: (message == null || message.isEmpty) ? null : Text(message),
          actions: actionsAlert,
        );
      },
    );
  }
}
