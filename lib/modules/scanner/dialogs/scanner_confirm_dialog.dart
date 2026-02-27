import 'package:flutter/material.dart';

class ScannerConfirmDialog extends StatelessWidget {
  final double value;
  final String? label;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ScannerConfirmDialog({
    super.key,
    required this.value,
    this.label,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar captura'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((label ?? '').trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                (label ?? '').trim(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, color: Color(0xFFF36607), fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel();
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
