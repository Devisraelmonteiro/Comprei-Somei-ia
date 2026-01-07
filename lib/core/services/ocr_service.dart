import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PriceOcrService {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<double?> detectPriceFromImage({
    required CameraImage image,
    required CameraDescription camera,
  }) async {
    try {
      final rotation = _rotationFromCamera(camera);

      final inputImage = InputImage.fromBytes(
        bytes: image.planes.first.bytes,
        metadata: InputImageMetadata(
          size: Size(
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          rotation: rotation,
          format: InputImageFormat.yuv420,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final recognizedText =
          await _textRecognizer.processImage(inputImage);

      final priceRegex = RegExp(r'(\d{1,4}[.,]\d{2})');
      
      // Define a área central de interesse (ROI) - 40% do centro
      final imgWidth = image.width.toDouble();
      final imgHeight = image.height.toDouble();
      final roiRect = Rect.fromCenter(
        center: Offset(imgWidth / 2, imgHeight / 2),
        width: imgWidth * 0.4, // 40% da largura
        height: imgHeight * 0.4, // 40% da altura
      );

      for (final block in recognizedText.blocks) {
        // Ignora blocos fora do centro
        if (!roiRect.overlaps(block.boundingBox)) continue;

        for (final line in block.lines) {
          // Ignora linhas fora do centro
          if (!roiRect.overlaps(line.boundingBox)) continue;

          final match = priceRegex.firstMatch(line.text);
          if (match != null) {
            return double.tryParse(
              match.group(0)!.replaceAll(',', '.'),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('OCR erro: $e');
    }

    return null;
  }

  /// 🔄 Conversão correta de rotação (iOS + Android)
  InputImageRotation _rotationFromCamera(CameraDescription camera) {
    switch (camera.sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      case 0:
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
