import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/scanner_controller.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScannerController(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 🔴 AQUI entra a câmera depois
            // CameraPreview(...),

            // 🔴 Overlay (já está em shared/painters)
            // CustomPaint(painter: ScannerOverlayPainter()),

            // 🔴 Card com valor + ações
            const Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(), // ScannerCardWidget removido temporariamente pois requer controller
            ),
          ],
        ),
      ),
    );
  }
}
