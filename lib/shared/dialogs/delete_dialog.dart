import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Confirmar'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sim')),
        ],
      );
    },
  );
}
