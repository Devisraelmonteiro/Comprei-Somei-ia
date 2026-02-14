import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:flutter/material.dart'; // Para Rect, Size, Offset
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PriceOcrService {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  // Regex Robusto para Preços (BRL)
  // Focado em etiquetas de supermercado brasileiras
  // Aceita:
  // - R$ 10,00
  // - 10,99
  // - 1.250,00
  // - RS 10,00 (erro comum de OCR)
  // - PS 10,00 (erro comum de OCR)
  static final RegExp _priceRegex = RegExp(
    // (?:R\$|RS|PS)? -> Prefixo opcional (R$, RS, PS)
    // \s* -> Espaços opcionais
    // (\d{1,3}(?:\.\d{3})*,\d{2}) -> Grupo de captura:
    //    \d{1,3} -> 1 a 3 dígitos iniciais
    //    (?:\.\d{3})* -> Opcional: grupos de milhar separados por ponto
    //    ,\d{2} -> Obrigatório: vírgula seguida de 2 dígitos (centavos)
    r'(?:R\$|RS|PS)?\s*(\d{1,3}(?:\.\d{3})*,\d{2})', 
    caseSensitive: false,
  );

  /// 🧠 Detecta preço na imagem da câmera
  Future<double?> detectPriceFromImage({
    required CameraImage image,
    required CameraDescription camera,
  }) async {
    try {
      final inputImage = _convertCameraImage(image, camera);
      if (inputImage == null) return null;

      final recognizedText = await _textRecognizer.processImage(inputImage);

      // 🎯 ROI (Region of Interest) - Foca no centro da imagem
      // O scanner visual é retangular (mais largo que alto), então ajustamos a ROI.
      // Assumindo orientação portrait, a imagem da câmera vem rotacionada.
      // Largura da imagem = Altura da tela (no portrait)
      // Altura da imagem = Largura da tela
      final imgWidth = image.width.toDouble();
      final imgHeight = image.height.toDouble();
      
      // ROI ajustada para pegar apenas a faixa central onde está o "laser"
      // O scanner visual tem ~280x70 pixels em um card de ~180px de altura.
      // Isso significa que a altura útil é pequena (~20% da imagem total visível).
      final roiRect = Rect.fromCenter(
        center: Offset(imgWidth / 2, imgHeight / 2),
        width: imgWidth * 0.8,  // 80% da largura (bem largo)
        height: imgHeight * 0.2, // 20% da altura (bem estreito, só o centro)
      );

      // Lista de candidatos a preço
      final List<double> candidates = [];

      for (final block in recognizedText.blocks) {
        // 1. Filtro Geométrico: Ignora blocos totalmente fora da ROI
        if (!roiRect.overlaps(block.boundingBox)) continue;

        for (final line in block.lines) {
          // 2. Filtro de Texto: Limpa e normaliza
          final text = line.text.replaceAll(' ', '').toUpperCase();
          
          // Ignora linhas muito curtas ou sem números
          if (text.length < 3 || !text.contains(RegExp(r'\d'))) continue;

          // 3. Regex Match
          final match = _priceRegex.firstMatch(line.text); // Usa texto original para regex
          if (match != null) {
            final rawValue = match.group(1); // Pega apenas o grupo numérico
            if (rawValue != null) {
              final value = _parseCurrency(rawValue);
              if (value != null && _isValidPrice(value)) {
                candidates.add(value);
              }
            }
          }
        }
      }

      // 4. Heurística de Decisão:
      // Se tiver mais de um candidato, qual escolher?
      // Por enquanto, retorna o primeiro válido que estiver mais ao centro (pela ordem de leitura do OCR)
      if (candidates.isNotEmpty) {
        return candidates.first;
      }

    } catch (e) {
      debugPrint('OCR Error: $e');
    }

    return null;
  }

  /// 🔢 Converte string monetária (1.200,50 ou 10,90) para double
  double? _parseCurrency(String text) {
    try {
      // Limpeza agressiva: mantém apenas números e vírgulas
      // Remove pontos de milhar para não atrapalhar o parse
      String clean = text.replaceAll('.', '').replaceAll(RegExp(r'[^0-9,]'), '');
      
      // Troca vírgula por ponto para o formato double do Dart (10,50 -> 10.50)
      clean = clean.replaceAll(',', '.');
      
      return double.tryParse(clean);
    } catch (_) {
      return null;
    }
  }

  /// ✅ Valida se o preço faz sentido (Regra de Negócio Básica)
  bool _isValidPrice(double value) {
    // Ignora valores zero, negativos ou absurdamente altos (ex: ano 2024, telefones)
    // Ajuste conforme a realidade do app. R$ 10.000,00 parece um teto razoável para supermercado.
    return value > 0.05 && value < 10000.00;
  }

  /// 🔄 Helper para converter CameraImage em InputImage
  InputImage? _convertCameraImage(CameraImage image, CameraDescription camera) {
    final rotation = _rotationFromCamera(camera);
    
    // O ML Kit precisa dos bytes corretos.
    // No iOS é bgra8888, no Android yuv420.
    // O plugin google_mlkit_commons cuida disso se passarmos os metadados certos.
    
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // Concatena planos (necessário para alguns formatos)
    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  InputImageRotation _rotationFromCamera(CameraDescription camera) {
    switch (camera.sensorOrientation) {
      case 90: return InputImageRotation.rotation90deg;
      case 180: return InputImageRotation.rotation180deg;
      case 270: return InputImageRotation.rotation270deg;
      default: return InputImageRotation.rotation0deg;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
