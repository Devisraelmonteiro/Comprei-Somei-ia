import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:flutter/material.dart'; // Para Rect, Size, Offset
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrResult {
  final double value;
  final String contextText;
  final Rect? valueBox;
  final Rect? contextBox;
  OcrResult({
    required this.value,
    required this.contextText,
    this.valueBox,
    this.contextBox,
  });
}

class PriceOcrService {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  static final Set<String> _stopTokens = {
    'oferta','promo','promoção','promocao','desconto','super','mega','especial',
    'imperdível','imperdivel','clube','app','cupom','cupons','preco','preço',
    'cada','apenas','só','so','somente','de','por','agora','antes','válido',
    'valido','até','ate','enquanto','durar','estoque','limitado','a partir',
    'un','und','unid','unidade','unidades','kg','kilo','quilo','g','gr','gramas',
    'l','lt','lts','litro','litros','ml','m','cm','mm','m2','r\$','rs','real',
    'reais','cent','centavo','centavos','pct','pacote','cx','caixa','fd','fardo',
    'rolo','rolos','lata','garrafa','pet','sache','sachê','pack','kit','leve',
    'pague','grátis','gratis','economize','unitário','unitario','por kg','por l',
    'por lt','por litro','por 100g','varejo','atacado'
  };

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

  static final RegExp _priceFlexible = RegExp(
    r'(?:R\s*\$|RS|PS)?\s*([0-9]{1,3}(?:[\. ]?[0-9]{3})*(?:[,.][0-9]{1,2})?|[0-9]+(?:[,.][0-9]{2}))',
    caseSensitive: false,
  );

  static final RegExp _priceSpaceDecimal = RegExp(r'\b(\d{1,3})\s+(\d{2})\b');
  static final RegExp _priceTimesUnit = RegExp(
      r'\b\d+\s*[xX]\s*([0-9]{1,3}(?:[\. ]?[0-9]{3})*(?:[,.][0-9]{2})?)');

  static final Set<String> _currencyMarkers = {'r\$', 'rs', 'real', 'reais', 'cent', 'centavo', 'centavos'};

  static final Set<String> _productiveTokens = {
    'produto','alimento','bebida','limpeza','higiene','perfumaria','padaria',
    'açougue','acougue','hortifruti','frios','laticínios','laticinios','mercearia',
    'congelado','resfriado','fresco','organico','orgânico','diet','light','zero',
    'integral','sem','gluten','lactose','semgluten','semlactose','cafe','cafÉ',
    'arroz','leite','sabao','sabão','refrigerante','amaciante'
  };

  static const double _roiMainWidth = 0.72;
  static const double _roiMainHeight = 0.24;
  static const double _roiMainCenterYAndroid = 0.86;
  static const double _roiFallbackWidth = 0.90;
  static const double _roiFallbackHeight = 0.40;
  static const double _roiFallbackCenterY = 0.60;
  static const double _minDigitCurrencyMain = 0.028;
  static const double _minDigitNoCurrencyMain = 0.065;
  static const double _minDigitCurrencyFallback = 0.024;
  static const double _minDigitNoCurrencyFallback = 0.045;
  /// 🧠 Detecta preço na imagem da câmera
  Future<double?> detectPriceFromImage({
    required CameraImage image,
    required CameraDescription camera,
  }) async {
    try {
      final inputImage = _convertCameraImage(image, camera);
      if (inputImage == null) return null;

      final recognizedText = await _textRecognizer.processImage(inputImage);

      final imgWidth = image.width.toDouble();
      final imgHeight = image.height.toDouble();

      double centerY;
      if (Platform.isAndroid) {
        centerY = imgHeight * _roiMainCenterYAndroid;
      } else {
        centerY = imgHeight / 2;
      }

      final roiRect = Rect.fromCenter(
        center: Offset(imgWidth / 2, centerY),
        width: imgWidth * 0.6,
        height: imgHeight * 0.12,
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

  Future<OcrResult?> detectPriceWithContextFromImage({
    required CameraImage image,
    required CameraDescription camera,
  }) async {
    try {
      final inputImage = _convertCameraImage(image, camera);
      if (inputImage == null) return null;

      final recognizedText = await _textRecognizer.processImage(inputImage);

      final imgWidth = image.width.toDouble();
      final imgHeight = image.height.toDouble();

      double centerY;
      if (Platform.isAndroid) {
        centerY = imgHeight * 0.85;
      } else {
        centerY = imgHeight / 2;
      }

      final roiRect = Rect.fromCenter(
        center: Offset(imgWidth / 2, centerY),
        width: imgWidth * _roiMainWidth,
        height: imgHeight * _roiMainHeight,
      );

      final List<TextLine> allLines = [];
      for (final block in recognizedText.blocks) {
        for (final l in block.lines) {
          if (roiRect.contains(l.boundingBox.center)) {
            allLines.add(l);
          }
        }
      }

      // 1) Preço completo na mesma linha (estrito) com seleção por pontuação
      final cand1 = <Map<String, dynamic>>[];
      for (final line in allLines) {
        final raw = line.text.trim();
        if (raw.isEmpty) continue;
        final rawLower = raw.toLowerCase();
        if (_containsPricePerUnit(rawLower)) continue;
        final m = _priceRegex.firstMatch(raw) ?? _priceFlexible.firstMatch(raw);
        double? v;
        if (m != null) {
          final g = m.group(1);
          if (g != null) v = _parseCurrency(g);
        } else {
          final ms = _priceSpaceDecimal.firstMatch(raw);
          if (ms != null) {
            final composed = '${ms.group(1)},${ms.group(2)}';
            v = _parseCurrency(composed);
          } else {
            final mt = _priceTimesUnit.firstMatch(raw);
            if (mt != null) {
              v = _parseCurrency(mt.group(1) ?? '');
            }
          }
        }
        final hasCurrency = RegExp(r'r\$|r\s*\$|\brs\b', caseSensitive: false)
                .hasMatch(rawLower) ||
            _currencyMarkers.any((t) => rawLower.contains(t));
        final hasDec = RegExp(r'[,.]\s*\d{2}').hasMatch(raw);
        if (v != null && hasCurrency && !hasDec) {
          final digits = raw.replaceAll(RegExp(r'\D'), '');
          if (digits.length >= 3 && digits.length <= 4) {
            final whole = digits.substring(0, digits.length - 2);
            final cents = digits.substring(digits.length - 2);
            v = _parseCurrency('$whole.$cents');
          }
        }
        if (v == null || !_isValidPrice(v)) continue;
        final hNorm = line.boundingBox.height / imgHeight;
        final minH = hasCurrency ? _minDigitCurrencyMain : _minDigitNoCurrencyMain;
        if (hNorm < minH * 0.8) continue;
        if (!hasDec && !hasCurrency) continue;
        final centerScore = 1.0 -
            (line.boundingBox.center.dx - imgWidth / 2).abs() / (imgWidth / 2);
        final heightScore = hNorm * 5.0;
        final decScore = hasDec ? 0.6 : 0.0;
        final curScore = hasCurrency ? 0.6 : 0.0;
        final roiBonus = roiRect.contains(line.boundingBox.center) ? 0.8 : 0.0;
        final score = heightScore + centerScore + decScore + curScore + roiBonus;
        cand1.add({'v': v, 'line': line, 'score': score});
      }
      if (cand1.isNotEmpty) {
        cand1.sort((a, b) =>
            (b['score'] as double).compareTo(a['score'] as double));
        final best = cand1.first;
        final line = best['line'] as dynamic;
        final v = best['v'] as double;

        String ctxText = '';
        Rect? ctxBox;
        final box = line.boundingBox as Rect;
        double bestDist = double.infinity;
        final ctxCenter = Offset(box.center.dx, box.top - box.height * 0.8);
        final ctxRect = Rect.fromCenter(
          center: ctxCenter,
          width: box.width * 1.8,
          height: box.height * 1.2,
        );
        for (final l in allLines) {
          if (identical(l, line)) continue;
          final dx = (l.boundingBox.center.dx - box.center.dx).abs();
          final dy = (box.center.dy - l.boundingBox.center.dy).abs();
          if (dx <= box.width * 2.0 && dy <= box.height * 3.2) {
            final t = l.text.trim();
            final cleaned = t.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ0-9\s\-]'), '').trim();
            if (_isValidContext(cleaned)) {
              final above = l.boundingBox.center.dy < box.center.dy - 2;
              final below = l.boundingBox.center.dy > box.center.dy + 2;
              final bias = ctxRect.overlaps(l.boundingBox) ? -0.2 : 0.0;
              final dist = dx + dy + (above ? -0.1 : 0.0) + (below ? 0.0 : 0.0) + bias;
              if (dist < bestDist) {
                bestDist = dist;
                ctxText = cleaned;
                ctxBox = l.boundingBox;
              }
            }
          }
        }
        if (ctxText.isNotEmpty) {
          return OcrResult(
            value: v,
            contextText: ctxText,
            valueBox: line.boundingBox,
            contextBox: ctxBox,
          );
        }
      }

      // 2) Inteiro em uma linha + vírgula+centavos em vizinha (conservador)
      for (final line in allLines) {
        final raw = line.text.trim();
        if (!RegExp(r'^\d{1,3}(?:\.\d{3})*$').hasMatch(raw)) continue;
        final intPart = raw.replaceAll('.', '');
        final box = line.boundingBox;
        for (final l in allLines) {
          if (identical(l, line)) continue;
          final dx = (l.boundingBox.center.dx - box.center.dx).abs();
          final dy = (l.boundingBox.center.dy - box.center.dy).abs();
          if (dx <= box.width * 1.3 && dy <= box.height * 1.8) {
            final t = l.text.trim();
            if (!RegExp(r'^[,\.]\s*\d{2}$').hasMatch(t)) continue;
            final cents = t.replaceAll(RegExp(r'[^0-9]'), '');
            if (cents.length != 2) continue;
            final sep = t.contains('.') ? '.' : ',';
            final composed = '$intPart$sep$cents';
            final v = _parseCurrency(composed);
            if (v == null || !_isValidPrice(v)) continue;

            final hasCurrencyNear = RegExp(r'r\$|r\s*\$|\brs\b', caseSensitive: false)
                .hasMatch(raw.toLowerCase()) ||
                RegExp(r'r\$|r\s*\$|\brs\b', caseSensitive: false)
                    .hasMatch(l.text.toLowerCase());
            final hNorm = line.boundingBox.height / imgHeight;
            if (hNorm < (hasCurrencyNear ? 0.028 : 0.055)) continue;

            String ctxText = '';
            Rect? ctxBox;
            double bestDist = double.infinity;
            final ctxCenter = Offset(box.center.dx, box.top - box.height * 0.8);
            final ctxRect = Rect.fromCenter(
              center: ctxCenter,
              width: box.width * 1.8,
              height: box.height * 1.2,
            );
            for (final nl in allLines) {
              if (identical(nl, line)) continue;
              final ndx = (nl.boundingBox.center.dx - box.center.dx).abs();
              final ndy = (box.center.dy - nl.boundingBox.center.dy).abs();
              if (ndx <= box.width * 2.0 && ndy <= box.height * 3.2) {
                final t2 = nl.text.trim();
                final cleaned2 = t2.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ0-9\s\-]'), '').trim();
                if (_isValidContext(cleaned2)) {
                  final above2 = nl.boundingBox.center.dy < box.center.dy - 2;
                  final below2 = nl.boundingBox.center.dy > box.center.dy + 2;
                  final bias2 = ctxRect.overlaps(nl.boundingBox) ? -0.2 : 0.0;
                  final dist2 = ndx + ndy + (above2 ? -0.1 : 0.0) + (below2 ? 0.0 : 0.0) + bias2;
                  if (dist2 < bestDist) {
                    bestDist = dist2;
                    ctxText = cleaned2;
                    ctxBox = nl.boundingBox;
                  }
                }
              }
            }
            if (ctxText.isEmpty) continue;
            return OcrResult(
              value: v,
              contextText: ctxText,
              valueBox: line.boundingBox,
              contextBox: ctxBox,
            );
          }
        }
      }

      final imgWidth2 = imgWidth;
      final imgHeight2 = imgHeight;
      double centerY2;
      if (Platform.isAndroid) {
        centerY2 = imgHeight2 * _roiFallbackCenterY;
      } else {
        centerY2 = imgHeight2 / 2;
      }
      final roiRect2 = Rect.fromCenter(
        center: Offset(imgWidth2 / 2, centerY2),
        width: imgWidth2 * _roiFallbackWidth,
        height: imgHeight2 * _roiFallbackHeight,
      );
      final List<TextLine> allLines2 = [];
      for (final block in recognizedText.blocks) {
        for (final l in block.lines) {
          if (roiRect2.contains(l.boundingBox.center)) {
            allLines2.add(l);
          }
        }
      }
      for (final line in allLines2) {
        final raw = line.text.trim();
        if (raw.isEmpty) continue;
        final m = _priceRegex.firstMatch(raw) ?? _priceFlexible.firstMatch(raw);
        double? v;
        if (m != null) {
          final g = m.group(1);
          if (g != null) v = _parseCurrency(g);
        } else {
          final ms = _priceSpaceDecimal.firstMatch(raw);
          if (ms != null) {
            final composed = '${ms.group(1)},${ms.group(2)}';
            v = _parseCurrency(composed);
          }
        }
        if (v == null || !_isValidPrice(v)) continue;
        final rawLower = raw.toLowerCase();
        final hasCurrency = RegExp(r'r\$|r\s*\$|\brs\b', caseSensitive: false)
                .hasMatch(rawLower) ||
            _currencyMarkers.any((t) => rawLower.contains(t));
        final hasDec = RegExp(r'[,.]\s*\d{2}').hasMatch(raw);
        final hNorm = line.boundingBox.height / imgHeight2;
        final minH2 = hasCurrency ? _minDigitCurrencyFallback : _minDigitNoCurrencyFallback;
        if (hNorm < minH2 * 0.8) continue;
        if (!hasDec && !hasCurrency) continue;
        String ctxText = '';
        Rect? ctxBox;
        final box = line.boundingBox;
        double bestDist = double.infinity;
        final ctxCenter2 = Offset(box.center.dx, box.top - box.height * 0.8);
        final ctxRect2 = Rect.fromCenter(
          center: ctxCenter2,
          width: box.width * 2.2,
          height: box.height * 1.6,
        );
        for (final l in allLines2) {
          if (identical(l, line)) continue;
          final dx = (l.boundingBox.center.dx - box.center.dx).abs();
          final dy = (box.center.dy - l.boundingBox.center.dy).abs();
          if (dx <= box.width * 3.6 && dy <= box.height * 5.8) {
            final t = l.text.trim();
            final cleaned = t.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ0-9\s\-]'), '').trim();
            if (_isValidContext(cleaned)) {
              final above = l.boundingBox.center.dy < box.center.dy - 2;
              final below = l.boundingBox.center.dy > box.center.dy + 2;
              final bias = ctxRect2.overlaps(l.boundingBox) ? -0.2 : 0.0;
              final dist = dx + dy + (above ? -0.1 : 0.0) + (below ? 0.0 : 0.0) + bias;
              if (dist < bestDist) {
                bestDist = dist;
                ctxText = cleaned;
                ctxBox = l.boundingBox;
              }
            }
          }
        }
        if (ctxText.isEmpty) continue;
        return OcrResult(
          value: v,
          contextText: ctxText,
          valueBox: line.boundingBox,
          contextBox: ctxBox,
        );
      }
      for (final line in allLines2) {
        final raw = line.text.trim();
        if (!RegExp(r'^\d{1,3}(?:\.\d{3})*$').hasMatch(raw)) continue;
        final intPart = raw.replaceAll('.', '');
        final box = line.boundingBox;
        for (final l in allLines2) {
          if (identical(l, line)) continue;
          final dx = (l.boundingBox.center.dx - box.center.dx).abs();
          final dy = (l.boundingBox.center.dy - box.center.dy).abs();
          if (dx <= box.width * 1.8 && dy <= box.height * 2.6) {
            final t = l.text.trim();
            if (!RegExp(r'^[,\.]\s*\d{2}$').hasMatch(t)) continue;
            final cents = t.replaceAll(RegExp(r'[^0-9]'), '');
            if (cents.length != 2) continue;
            final sep = t.contains('.') ? '.' : ',';
            final composed = '$intPart$sep$cents';
            final v = _parseCurrency(composed);
            if (v == null || !_isValidPrice(v)) continue;
            String ctxText = '';
            Rect? ctxBox;
            double bestDist = double.infinity;
            final ctxCenter3 = Offset(box.center.dx, box.top - box.height * 0.8);
            final ctxRect3 = Rect.fromCenter(
              center: ctxCenter3,
              width: box.width * 2.2,
              height: box.height * 1.6,
            );
            for (final nl in allLines2) {
              if (identical(nl, line)) continue;
              final ndx = (nl.boundingBox.center.dx - box.center.dx).abs();
              final ndy = (box.center.dy - nl.boundingBox.center.dy).abs();
              if (ndx <= box.width * 3.6 && ndy <= box.height * 5.8) {
                final t2 = nl.text.trim();
                final cleaned2 = t2.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ0-9\s\-]'), '').trim();
                if (_isValidContext(cleaned2)) {
                  final above2 = nl.boundingBox.center.dy < box.center.dy - 2;
                  final below2 = nl.boundingBox.center.dy > box.center.dy + 2;
                  final bias3 = ctxRect3.overlaps(nl.boundingBox) ? -0.2 : 0.0;
                  final dist2 = ndx + ndy + (above2 ? -0.1 : 0.0) + (below2 ? 0.0 : 0.0) + bias3;
                  if (dist2 < bestDist) {
                    bestDist = dist2;
                    ctxText = cleaned2;
                    ctxBox = nl.boundingBox;
                  }
                }
              }
            }
            if (ctxText.isEmpty) continue;
            return OcrResult(
              value: v,
              contextText: ctxText,
              valueBox: line.boundingBox,
              contextBox: ctxBox,
            );
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('OCR Error (context): $e');
      return null;
    }
  }

  /// 🔢 Converte string monetária (1.200,50 ou 10,90) para double
  double? _parseCurrency(String text) {
    try {
      String s = text.trim();
      s = s.replaceAll(RegExp(r'[^0-9,\.]'), '');
      s = s.replaceAll(RegExp(r'\s+'), '');

      if (s.isEmpty) return null;

      final hasComma = s.contains(',');
      final hasDot = s.contains('.');

      String normalized;
      if (hasComma && hasDot) {
        final lastComma = s.lastIndexOf(',');
        final lastDot = s.lastIndexOf('.');
        if (lastComma > lastDot) {
          normalized = s.replaceAll('.', '').replaceAll(',', '.');
        } else {
          normalized = s.replaceAll(',', '');
        }
      } else if (hasComma) {
        normalized = s.replaceAll('.', '');
        normalized = normalized.replaceAll(',', '.');
      } else if (hasDot) {
        normalized = s;
      } else {
        normalized = s;
      }

      final m = RegExp(r'^(\d+)\.(\d+)$').firstMatch(normalized);
      if (m != null && m.group(2) != null && m.group(2)!.length == 1) {
        normalized = '${m.group(1)}.${m.group(2)}0';
      }
      return double.tryParse(normalized);
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

  // (removido método tolerante de extração para evitar falsos positivos)

  InputImage? _convertCameraImage(CameraImage image, CameraDescription camera) {
    final rotation = _rotationFromCamera(camera);

    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

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

bool _isValidContext(String text) {
  final cleaned = text.trim();
  if (cleaned.length < 3) return false;
  if (!RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(cleaned)) return false;
  final lower = cleaned.toLowerCase();
  for (final p in PriceOcrService._productiveTokens) {
    if (lower.contains(p)) return true;
  }
  final tokens = lower.split(RegExp(r'[^a-zà-ÿ0-9]+')).where((w) => w.isNotEmpty);
  bool hasProductive = false;
  for (final w in tokens) {
    if (!PriceOcrService._stopTokens.contains(w) && RegExp(r'[a-zà-ÿ]').hasMatch(w) && w.length >= 3) {
      hasProductive = true;
      break;
    }
  }
  return hasProductive;
}

bool _containsPricePerUnit(String lower) {
  if (lower.contains('preco por') || lower.contains('preço por')) return true;
  if (lower.contains('preco unitario') || lower.contains('preço unitário')) return true;
  if (lower.contains('por kg') || lower.contains('por litro') || lower.contains('por l') || lower.contains('por lt')) return true;
  if (lower.contains('por 100g') || lower.contains('por 100 g')) return true;
  if (RegExp(r'r\$\s*/\s*kg').hasMatch(lower) || RegExp(r'r\$\s*/\s*l').hasMatch(lower) || RegExp(r'r\$\s*/\s*lt').hasMatch(lower)) return true;
  if (lower.contains('/kg') || lower.contains('/l') || lower.contains('/lt') || lower.contains('/ml') || lower.contains('/g')) return true;
  return false;
}

// (removido: não utilizado)
