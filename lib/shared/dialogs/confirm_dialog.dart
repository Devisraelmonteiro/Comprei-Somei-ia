import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String title, String message) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Não')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sim')),
        ],
      );
    },
  );
}
