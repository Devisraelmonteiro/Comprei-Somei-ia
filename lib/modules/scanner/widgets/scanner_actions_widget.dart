import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/scanner_controller.dart';

class ScannerActionsWidget extends StatelessWidget {
  const ScannerActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ScannerController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: controller.cancel,
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: controller.confirm,
        ),
        IconButton(
          icon: const Icon(Icons.exposure_plus_1),
          onPressed: () => controller.multiply(2),
        ),
      ],
    );
  }
}
