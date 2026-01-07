import 'package:flutter/material.dart';

/// 🎨 Painter personalizado para overlay do scanner com efeito de vinheta
/// 
/// Desenha:
/// - Degradê escuro nas 4 bordas (vinheta)
/// - Cantos em L no retângulo central (alvo)
/// - Centro transparente para visualização da câmera
class ScannerOverlayPainter extends CustomPainter {
  /// Largura do retângulo central (alvo)
  final double rectWidth;
  
  /// Altura do retângulo central (alvo)
  final double rectHeight;
  
  /// Cor dos cantos em L
  final Color cornerColor;
  
  /// Espessura das linhas dos cantos
  final double cornerThickness;
  
  /// Comprimento dos cantos em L
  final double cornerLength;
  
  /// Raio de arredondamento do retângulo central
  final double cornerRadius;
  
  /// Opacidade do efeito de vinheta (0.0 a 1.0)
  final double vignetteOpacity;
  
  /// Fator multiplicador para o degradê inferior
  /// Valores maiores deixam o fundo mais escuro
  final double bottomEdgeFactor;

  const ScannerOverlayPainter({
    required this.rectWidth,
    required this.rectHeight,
    required this.cornerColor,
    required this.cornerThickness,
    required this.cornerLength,
    required this.cornerRadius,
    required this.vignetteOpacity,
    this.bottomEdgeFactor = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calcular centro e criar retângulo central
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: rectWidth,
      height: rectHeight,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(cornerRadius),
    );

    // Criar máscara: área total menos o retângulo central
    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRRect(rrect);
    final overlay = Path.combine(
      PathOperation.difference,
      fullPath,
      holePath,
    );

    // Aplicar clipping para não desenhar dentro do retângulo central
    canvas.save();
    canvas.clipPath(overlay, doAntiAlias: false);

    // Configurar cor e opacidade do degradê
    final double edgeThickness = size.shortestSide * 0.24;
    final int edgeAlpha = (vignetteOpacity.clamp(0.0, 1.0) * 255).round();
    final Color edgeColor = Color.fromARGB(edgeAlpha, 0, 0, 0);

    // === DEGRADÊ SUPERIOR ===
    final topRect = Rect.fromLTWH(0, 0, size.width, edgeThickness);
    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [edgeColor, const Color(0x00000000)],
      ).createShader(topRect);
    canvas.drawRect(topRect, topPaint);

    // === DEGRADÊ INFERIOR ===
    // bottomEdgeFactor permite deixar o fundo mais escuro
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
    final leftRect = Rect.fromLTWH(0, 0, edgeThickness, size.height);
    final leftPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [edgeColor, const Color(0x00000000)],
      ).createShader(leftRect);
    canvas.drawRect(leftRect, leftPaint);

    // === DEGRADÊ DIREITO ===
    final rightRect = Rect.fromLTWH(
      size.width - edgeThickness,
      0,
      edgeThickness,
      size.height,
    );
    final rightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [edgeColor, const Color(0x00000000)],
      ).createShader(rightRect);
    canvas.drawRect(rightRect, rightPaint);

    // === DEGRADÊ RADIAL NOS CANTOS ===
    // Suaviza a transição nos 4 cantos da tela
    final double cornerRadiusFade = edgeThickness * 1.15;
    
    final rectTL = Rect.fromCircle(
      center: const Offset(0, 0),
      radius: cornerRadiusFade,
    );
    final rectTR = Rect.fromCircle(
      center: Offset(size.width, 0),
      radius: cornerRadiusFade,
    );
    final rectBL = Rect.fromCircle(
      center: Offset(0, size.height),
      radius: cornerRadiusFade,
    );
    final rectBR = Rect.fromCircle(
      center: Offset(size.width, size.height),
      radius: cornerRadiusFade,
    );

    final radialGradient = RadialGradient(
      colors: [edgeColor, const Color(0x00000000)],
    );

    canvas.drawRect(
      rectTL,
      Paint()..shader = radialGradient.createShader(rectTL),
    );
    canvas.drawRect(
      rectTR,
      Paint()..shader = radialGradient.createShader(rectTR),
    );
    canvas.drawRect(
      rectBL,
      Paint()..shader = radialGradient.createShader(rectBL),
    );
    canvas.drawRect(
      rectBR,
      Paint()..shader = radialGradient.createShader(rectBR),
    );

    // Restaurar canvas (remover clipping)
    canvas.restore();

    // === DESENHAR CANTOS EM L ===
    final tl = rect.topLeft;
    final tr = rect.topRight;
    final bl = rect.bottomLeft;
    final br = rect.bottomRight;

    final cornerPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = cornerThickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Canto superior esquerdo
    canvas.drawLine(tl, tl + Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(tl, tl + Offset(0, cornerLength), cornerPaint);

    // Canto superior direito
    canvas.drawLine(tr, tr + Offset(-cornerLength, 0), cornerPaint);
    canvas.drawLine(tr, tr + Offset(0, cornerLength), cornerPaint);

    // Canto inferior esquerdo
    canvas.drawLine(bl, bl + Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(bl, bl + Offset(0, -cornerLength), cornerPaint);

    // Canto inferior direito
    canvas.drawLine(br, br + Offset(-cornerLength, 0), cornerPaint);
    canvas.drawLine(br, br + Offset(0, -cornerLength), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.cornerColor != cornerColor ||
        oldDelegate.vignetteOpacity != vignetteOpacity ||
        oldDelegate.rectWidth != rectWidth ||
        oldDelegate.rectHeight != rectHeight ||
        oldDelegate.cornerThickness != cornerThickness ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.bottomEdgeFactor != bottomEdgeFactor;
  }
}