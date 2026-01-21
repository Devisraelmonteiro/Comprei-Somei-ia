import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎨 Painter personalizado para overlay do scanner com efeito de vinheta
/// 
/// Desenha:
/// - Degradê escuro nas 4 bordas (topo, baixo, esquerda, direita)
/// - Cantos em L arredondados no retângulo central
/// - Centro transparente para visualização da câmera
class ScannerOverlayPainter extends CustomPainter {
  final double rectWidth;
  final double rectHeight;
  final Color cornerColor;
  final double cornerThickness;
  final double cornerLength;
  final double cornerRadius;
  final double vignetteOpacity;
  final double bottomEdgeFactor;
  final double topOffset;

  const ScannerOverlayPainter({
    required this.rectWidth,
    required this.rectHeight,
    required this.cornerColor,
    required this.cornerThickness,
    required this.cornerLength,
    required this.cornerRadius,
    required this.vignetteOpacity,
    this.bottomEdgeFactor = 1.0,
    required this.topOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calcular centro e posição do retângulo
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: rectWidth,
      height: rectHeight,
    );

    // ═══════════════════════════════════════════════════════════
    // PASSO 1: DESENHAR DEGRADÊS NAS 4 BORDAS
    // ═══════════════════════════════════════════════════════════
    
    // Criar máscara para não desenhar dentro do retângulo
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()
      ..addRect(rect);
    final overlay = Path.combine(
      PathOperation.difference,
      fullPath,
      holePath,
    );

    canvas.save();
    canvas.clipPath(overlay, doAntiAlias: false);

    // Configurar cor do degradê
    final double edgeThickness = size.shortestSide * 0.24;
    final int edgeAlpha = (vignetteOpacity.clamp(0.0, 1.0) * 255).round();
    final Color edgeColor = Color.fromARGB(edgeAlpha, 0, 0, 0);

    // === DEGRADÊ SUPERIOR ===
    final double topGradientEnd = rect.top + topOffset;
    final topRect = Rect.fromLTWH(0, 0, size.width, topGradientEnd);
    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [edgeColor, const Color(0x00000000)],
      ).createShader(topRect);
    canvas.drawRect(topRect, topPaint);

    // === DEGRADÊ INFERIOR ===
    final double bottomThickness = edgeThickness * bottomEdgeFactor;
    final bottomRect = Rect.fromLTWH(
      0,
      size.height - bottomThickness,
      size.width,
      bottomThickness,
    );
    final bottomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [edgeColor, const Color(0x00000000)],
      ).createShader(bottomRect);
    canvas.drawRect(bottomRect, bottomPaint);

    // === DEGRADÊ ESQUERDO ===
    final leftRect = Rect.fromLTWH(0, 0, rect.left, size.height);
    final leftPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [edgeColor, const Color(0x00000000)],
      ).createShader(leftRect);
    canvas.drawRect(leftRect, leftPaint);

    // === DEGRADÊ DIREITO ===
    final rightRect = Rect.fromLTWH(
      rect.right,
      0,
      size.width - rect.right,
      size.height,
    );
    final rightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [edgeColor, const Color(0x00000000)],
      ).createShader(rightRect);
    canvas.drawRect(rightRect, rightPaint);

    canvas.restore();

    // ═══════════════════════════════════════════════════════════
    // PASSO 2: DESENHAR CANTOS EM L COM ARREDONDAMENTO
    // ═══════════════════════════════════════════════════════════
    
    final tl = rect.topLeft;
    final tr = rect.topRight;
    final bl = rect.bottomLeft;
    final br = rect.bottomRight;

    final cornerPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = cornerThickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // === CANTO SUPERIOR ESQUERDO (COM OFFSET E ARREDONDADO) ===
    final tlAdjusted = tl + Offset(0, topOffset);
    
    // Linha horizontal
    canvas.drawLine(
      tlAdjusted + Offset(cornerRadius, 0),
      tlAdjusted + Offset(cornerLength, 0),
      cornerPaint,
    );
    
    // Linha vertical
    canvas.drawLine(
      tlAdjusted + Offset(0, cornerRadius),
      tlAdjusted + Offset(0, cornerLength),
      cornerPaint,
    );
    
    // Arco arredondado
    if (cornerRadius > 0) {
      canvas.drawArc(
        Rect.fromLTWH(
          tlAdjusted.dx,
          tlAdjusted.dy,
          cornerRadius * 2,
          cornerRadius * 2,
        ),
        math.pi,      // 180°
        math.pi / 2,  // 90°
        false,
        cornerPaint,
      );
    }

    // === CANTO SUPERIOR DIREITO (COM OFFSET E ARREDONDADO) ===
    final trAdjusted = tr + Offset(0, topOffset);
    
    // Linha horizontal
    canvas.drawLine(
      trAdjusted + Offset(-cornerLength, 0),
      trAdjusted + Offset(-cornerRadius, 0),
      cornerPaint,
    );
    
    // Linha vertical
    canvas.drawLine(
      trAdjusted + Offset(0, cornerRadius),
      trAdjusted + Offset(0, cornerLength),
      cornerPaint,
    );
    
    // Arco arredondado
    if (cornerRadius > 0) {
      canvas.drawArc(
        Rect.fromLTWH(
          trAdjusted.dx - cornerRadius * 2,
          trAdjusted.dy,
          cornerRadius * 2,
          cornerRadius * 2,
        ),
        -math.pi / 2, // -90°
        math.pi / 2,  // 90°
        false,
        cornerPaint,
      );
    }

    // === CANTO INFERIOR ESQUERDO (FIXO E ARREDONDADO) ===
    
    // Linha horizontal
    canvas.drawLine(
      bl + Offset(cornerRadius, 0),
      bl + Offset(cornerLength, 0),
      cornerPaint,
    );
    
    // Linha vertical
    canvas.drawLine(
      bl + Offset(0, -cornerRadius),
      bl + Offset(0, -cornerLength),
      cornerPaint,
    );
    
    // Arco arredondado
    if (cornerRadius > 0) {
      canvas.drawArc(
        Rect.fromLTWH(
          bl.dx,
          bl.dy - cornerRadius * 2,
          cornerRadius * 2,
          cornerRadius * 2,
        ),
        math.pi / 2,  // 90°
        math.pi / 2,  // 90°
        false,
        cornerPaint,
      );
    }

    // === CANTO INFERIOR DIREITO (FIXO E ARREDONDADO) ===
    
    // Linha horizontal
    canvas.drawLine(
      br + Offset(-cornerLength, 0),
      br + Offset(-cornerRadius, 0),
      cornerPaint,
    );
    
    // Linha vertical
    canvas.drawLine(
      br + Offset(0, -cornerRadius),
      br + Offset(0, -cornerLength),
      cornerPaint,
    );
    
    // Arco arredondado
    if (cornerRadius > 0) {
      canvas.drawArc(
        Rect.fromLTWH(
          br.dx - cornerRadius * 2,
          br.dy - cornerRadius * 2,
          cornerRadius * 2,
          cornerRadius * 2,
        ),
        0,            // 0°
        math.pi / 2,  // 90°
        false,
        cornerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.cornerColor != cornerColor ||
        oldDelegate.vignetteOpacity != vignetteOpacity ||
        oldDelegate.rectWidth != rectWidth ||
        oldDelegate.rectHeight != rectHeight ||
        oldDelegate.cornerThickness != cornerThickness ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.bottomEdgeFactor != bottomEdgeFactor ||
        oldDelegate.topOffset != topOffset;
  }
}