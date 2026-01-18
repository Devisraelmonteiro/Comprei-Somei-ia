import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:comprei_some_ia/shared/painters/scanner_overlay_painter.dart';

/// 📸 Widget do card de scanner com preview da câmera e OCR
///
/// Exibe:
/// - Preview da câmera em tempo real
/// - Overlay com cantos em L e vinheta
/// - Valor capturado com animação
/// - Estados de erro e loading
class ScannerCardWidget extends StatelessWidget {
  /// Controller da câmera
  final CameraController? cameraController;

  /// Se a câmera está inicializada
  final bool isCameraInitialized;

  /// Mensagem de erro (null se não houver erro)
  final String? cameraError;

  /// Preço detectado pelo OCR (null se nenhum)
  final double? detectedPrice;

  /// Valor capturado atual
  final double capturedValue;

  /// Callback para tentar novamente em caso de erro
  final VoidCallback onRetry;

  /// Callback para abrir configurações do sistema
  final VoidCallback onOpenSettings;

  const ScannerCardWidget({
    super.key,
    required this.cameraController,
    required this.isCameraInitialized,
    required this.cameraError,
    required this.detectedPrice,
    required this.capturedValue,
    required this.onRetry,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.only(top: 16, left: 30, right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: detectedPrice != null
              ? Colors.green.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: detectedPrice != null
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            _buildCameraPreview(),
            if (isCameraInitialized) _buildScannerOverlay(),
            if (isCameraInitialized) _buildCapturedValue(),
          ],
        ),
      ),
    );
  }

  /// 📹 Preview da câmera ou estados de erro/loading
  Widget _buildCameraPreview() {
    if (isCameraInitialized &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      return Positioned.fill(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: cameraController!.value.previewSize!.height,
            height: cameraController!.value.previewSize!.width,
            child: CameraPreview(cameraController!),
          ),
        ),
      );
    }

    if (cameraError != null) {
      return _buildErrorState();
    }

    return _buildLoadingState();
  }

  /// ❌ Estado de erro
  Widget _buildErrorState() {
    final isPermissionError = cameraError!.contains('permanentemente');

    return Container(
      color: Colors.red.shade100,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(
                cameraError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 11),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: isPermissionError ? onOpenSettings : onRetry,
                icon: Icon(
                  isPermissionError ? Icons.settings : Icons.refresh,
                  size: 16,
                ),
                label: Text(
                  isPermissionError
                      ? 'Abrir Configurações'
                      : 'Tentar Novamente',
                  style: const TextStyle(fontSize: 11),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ⏳ Estado de loading
  Widget _buildLoadingState() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text(
              'Inicializando câmera...',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 Overlay com cantos em L e vinheta
  Widget _buildScannerOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ScannerOverlayPainter(
          rectWidth: 280,
          rectHeight: 150,
          cornerColor: detectedPrice != null ? Colors.green : Colors.white,
          cornerThickness: 3,
          cornerLength: 24,
          cornerRadius: 16,
          vignetteOpacity: 0.65,
          bottomEdgeFactor: 1.8,
        ),
      ),
    );
  }

  /// 💰 Valor capturado
  Widget _buildCapturedValue() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: const BoxDecoration(color: Color(0xB3000000)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Capturado",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            _buildAnimatedValue(),
          ],
        ),
      ),
    );
  }

  /// ✨ Valor com animação
  Widget _buildAnimatedValue() {
    final valueText = Text(
      "R\$ ${capturedValue.toStringAsFixed(2).replaceAll('.', ',')}",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF36607),
      ),
    );

    if (capturedValue == 0) {
      return valueText;
    }

    return valueText
        .animate(key: ValueKey(capturedValue))

        // 1️⃣ Pop inicial
        .scale(
          duration: 150.ms,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeOut,
        )

        // 2️⃣ EXPLOSÃO (x4)
        .scale(
          duration: 250.ms,
          end: const Offset(4.0, 4.0), // 🔥 multiplica o tamanho
          curve: Curves.easeOutBack,
        )

        // 3️⃣ Sobe enquanto cresce
        .moveY(
          begin: 0,
          end: -90,
          curve: Curves.easeOut,
        )

        // 4️⃣ Pausa visual
        .then(delay: 600.ms)

        // 5️⃣ Encolhe elegante (macOS style)
        .scale(
          duration: 600.ms,
          end: const Offset(0.7, 0.6),
          curve: Curves.easeOutBack,
        )

        // 6️⃣ Volta para base
        .moveY(
          end: 0,
          curve: Curves.easeIn,
        );
  }
}
