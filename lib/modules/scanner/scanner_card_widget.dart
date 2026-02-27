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

  /// Nome/label detectado pelo OCR (null se nenhum)
  final String? detectedLabel;

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
    this.detectedLabel,
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
            if (detectedLabel != null &&
                detectedLabel!.trim().isNotEmpty)
              _buildTopLabel(),
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
          // 📏 LARGURA do retângulo central (scanner)
          // Valores menores = retângulo mais estreito
          // Valores maiores = retângulo mais largo
          // Exemplos: 250, 280, 300, 320
          rectWidth: 280,
          
          // 📏 ALTURA do retângulo central (scanner)
          // Valores menores = retângulo mais baixo
          // Valores maiores = retângulo mais alto
          // Exemplos: 120, 150, 180, 200
          rectHeight: 70,
          
          // 🎨 COR dos cantos em L
          // Muda para verde quando detecta preço
          // Opções: Colors.white, Colors.green, Colors.blue, etc
          cornerColor: detectedPrice != null ? Colors.green : Colors.white,
          
          // 📐 ESPESSURA das linhas dos cantos em L
          // Valores menores = linhas mais finas (ex: 2)
          // Valores maiores = linhas mais grossas (ex: 4, 5)
          cornerThickness: 1,
          
          // 📏 COMPRIMENTO das linhas dos cantos em L
          // Valores menores = cantos mais curtos (ex: 16, 20)
          // Valores maiores = cantos mais longos (ex: 28, 32)
          cornerLength: 24,
          
          // ⭕ RAIO de arredondamento dos cantos
          // Valores menores = cantos mais quadrados (ex: 8, 12)
          // Valores maiores = cantos mais arredondados (ex: 20, 24)
          // 0 = cantos totalmente quadrados
          cornerRadius: 6,
          
          // 🌑 OPACIDADE da vinheta escura (área fora do retângulo)
          // Valores menores = área mais clara/transparente (ex: 0.4, 0.5)
          // Valores maiores = área mais escura (ex: 0.7, 0.8)
          // 0.0 = completamente transparente
          // 1.0 = completamente opaco
          vignetteOpacity: 0.65,
          
          // 📊 FATOR de escurecimento da parte INFERIOR
          // Valores menores = inferior mais claro (ex: 1.0, 1.5)
          // Valores maiores = inferior mais escuro (ex: 2.0, 2.5)
          // 1.0 = sem diferença entre topo e fundo
          bottomEdgeFactor: 1.8,
          
          // 📍 OFFSET VERTICAL do L de CIMA
          // Valores NEGATIVOS = L sobe (ex: -10, -20, -30)
          // Valores POSITIVOS = L desce (ex: 10, 20, 30)
          // 0 = L fica no canto do retângulo
          // ← EDITE AQUI para subir/descer o L de cima
          topOffset: -30,
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,          // 👈 transição suave
            Color(0x88000000),            // 👈 fumê médio
            Color(0xCC000000),            // 👈 mais escuro embaixo
          ],
        ),
      ),
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

  Widget _buildTopLabel() {
    return Positioned(
      top: 2,
      left: 2,
      right: 2,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            detectedLabel!.trim(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
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
        .scale(
          duration: 150.ms,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          curve: Curves.easeOut,
        )
        .scale(
          duration: 250.ms,
          end: const Offset(2.5, 4.0),
          curve: Curves.easeOutBack,
        )
        .moveY(
          begin: 0,
          end: -100,
          curve: Curves.easeOut,
        )
        .then(delay: 300.ms)
        .scale(
          duration: 300.ms,
          end: const Offset(0.6, 0.5),
          curve: Curves.easeOutBack,
        )
        .moveY(
          end: 0,
          curve: Curves.easeIn,
        );
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 GUIA RÁPIDO - AJUSTAR POSIÇÃO DO L DE CIMA
// ═══════════════════════════════════════════════════════════════
//
// topOffset: -30  ← MUDE ESTE VALOR!
//
// Valores sugeridos:
// - topOffset: -10  → L sobe pouquinho
// - topOffset: -20  → L sobe médio
// - topOffset: -30  → L sobe bastante (padrão)
// - topOffset: -40  → L sobe muito
// - topOffset: -50  → L sobe extremo
// - topOffset: 0    → L fica no canto
// - topOffset: 20   → L desce (dentro do retângulo)
//
// ═══════════════════════════════════════════════════════════════
