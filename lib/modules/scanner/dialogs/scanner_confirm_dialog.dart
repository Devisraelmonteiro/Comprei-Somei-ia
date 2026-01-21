import 'package:flutter/material.dart';

class ScannerConfirmDialog extends StatelessWidget {
  final double value;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ScannerConfirmDialog({
    super.key,
    required this.value,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar valor'),
      content: Text(
        'Valor detectado:\n\nR\$ ${value.toStringAsFixed(2)}',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
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
