import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:comprei_some_ia/core/services/ocr_service.dart';

/// 📸 Controller responsável pela lógica da Câmera e OCR
/// 
/// Implementa o padrão "Controller" para separar a lógica de hardware da UI.
/// Gerencia:
/// - Inicialização/Disposal da Câmera
/// - Permissões
/// - Processamento de Imagem (OCR)
/// - Estado de Bloqueio (Lock) após detecção
class ScannerController extends ChangeNotifier {
  final PriceOcrService _ocrService = PriceOcrService();
  
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String? _cameraError;
  bool _isProcessing = false;
  
  // Estado do valor detectado
  double? _detectedPrice;
  String? _detectedLabel;
  bool _isPaused = false;
  
  // Janela deslizante para consenso multi-frame
  final List<_OCRSample> _recentSamples = <_OCRSample>[];
  static const int _maxSamples = 5;      // armazena até 5 leituras recentes
  static const int _minConsensus = 3;    // exige pelo menos 3 iguais para confirmar
  
  // Getters
  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  String? get cameraError => _cameraError;
  double? get detectedPrice => _detectedPrice;
  String? get detectedLabel => _detectedLabel;
  bool get isProcessing => _isProcessing;
  bool get isPaused => _isPaused;

  /// ⏸️ Pausa temporariamente a detecção (ex: quando abre um modal)
  void pauseScanning() {
    _isPaused = true;
    notifyListeners();
  }

  /// ▶️ Retoma a detecção
  void resumeScanning() {
    _isPaused = false;
    // Se quiser limpar o valor anterior ao retomar:
    _detectedPrice = null; 
    notifyListeners();
  }

  /// 🚀 Inicializa a câmera e o stream de imagens
  Future<void> initializeCamera() async {
    // Se já tiver controller, descarta antes de criar novo (evita leaks)
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        _cameraError = "Permissão de câmera negada";
        notifyListeners();
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _cameraError = "Nenhuma câmera encontrada";
        notifyListeners();
        return;
      }

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final preset = Platform.isAndroid ? ResolutionPreset.high : ResolutionPreset.medium;

      final imageFormatGroup = Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888;

      _cameraController = CameraController(
        camera,
        preset,
        enableAudio: false,
        imageFormatGroup: imageFormatGroup,
      );

      await _cameraController!.initialize();
      
      // Inicia o stream de imagens para o OCR
      _startImageStream();
      
      _isCameraInitialized = true;
      _cameraError = null;
      notifyListeners();
      
    } catch (e) {
      _cameraError = "Erro ao iniciar câmera: $e";
      _isCameraInitialized = false;
      notifyListeners();
    }
  }

  /// 🔄 Inicia o processamento de frames
  void _startImageStream() {
    if (_cameraController == null) return;

    _cameraController!.startImageStream((image) async {
      // 🔒 TRAVA DE SEGURANÇA (SENIOR LEVEL):
      // 1. Se já está processando um frame, ignora o atual (evita gargalo)
      // 2. Se JÁ TEM um preço detectado, ignora novos frames (evita "metralhadora" de detecções)
      // 3. Se está PAUSADO explicitamente (ex: modal aberto), ignora
      if (_isProcessing || _detectedPrice != null || _isPaused) return;
      
      _isProcessing = true;
      // Não notificamos listeners aqui para evitar rebuilds excessivos (60fps)

      try {
        final result = await _ocrService.detectPriceWithContextFromImage(
          image: image,
          camera: _cameraController!.description,
        );

        if (result != null) {
          final val = double.parse(result.value.toStringAsFixed(2));
          final label = _normalizeLabel(result.contextText);
          
          // Adiciona leitura na janela
          _recentSamples.add(_OCRSample(val, label));
          while (_recentSamples.length > _maxSamples) {
            _recentSamples.removeAt(0);
          }

          // Agrupa por valor (string com 2 casas) e conta frequências
          final Map<String, List<_OCRSample>> byPrice = {};
          for (final s in _recentSamples) {
            final k = s.price.toStringAsFixed(2);
            byPrice.putIfAbsent(k, () => <_OCRSample>[]).add(s);
          }
          // Encontra o grupo com maior suporte
          String? bestKey;
          int bestCount = 0;
          byPrice.forEach((k, list) {
            if (list.length > bestCount) {
              bestKey = k;
              bestCount = list.length;
            }
          });

          if (bestKey != null && bestCount >= _minConsensus) {
            // Dentro do grupo vencedor, pega o label mais frequente
            final samples = byPrice[bestKey]!;
            final Map<String, int> labelFreq = {};
            for (final s in samples) {
              labelFreq[s.label] = (labelFreq[s.label] ?? 0) + 1;
            }
            String bestLabel = samples.first.label;
            int bestLabelCount = 0;
            labelFreq.forEach((l, c) {
              if (c > bestLabelCount) {
                bestLabel = l;
                bestLabelCount = c;
              }
            });

            _detectedPrice = double.parse(bestKey!);
            _detectedLabel = bestLabel;
            _recentSamples.clear();
            notifyListeners(); // Notifica a UI
            
            // 📳 Feedback háptico
            if ((await Vibration.hasVibrator()) == true) {
              Vibration.vibrate(duration: 200);
            }
          }

        }
      } catch (e) {
        debugPrint("Erro no OCR: $e");
      } finally {
        _isProcessing = false;
      }
    });
  }

  /// 🛑 Para a câmera explicitamente (ex: app em background)
  Future<void> stopCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
    _isCameraInitialized = false;
    notifyListeners();
  }

  /// 🧹 Limpa o valor detectado e destrava o scanner para novas leituras
  void clearDetectedPrice() {
    _detectedPrice = null;
    _detectedLabel = null;
    _recentSamples.clear();
    notifyListeners();
  }

  /// 🛑 Pausa/Para a câmera (ao sair da tela)
  @override
  void dispose() {
    _cameraController?.dispose();
    _ocrService.dispose();
    super.dispose();
  }
}

class _OCRSample {
  final double price;
  final String label;
  _OCRSample(this.price, this.label);
}

String _normalizeLabel(String input) {
  var s = input.trim();
  // Preserva espaços e hífens; remove ruídos
  s = s.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ0-9\-\s]'), '');
  // Insere espaço entre letras e números colados (ex.: 500ML -> 500 ML)
  s = s.replaceAllMapped(RegExp(r'([A-Za-zÀ-ÿ])(\d)'), (m) => '${m.group(1)} ${m.group(2)}');
  s = s.replaceAllMapped(RegExp(r'(\d)([A-Za-zÀ-ÿ])'), (m) => '${m.group(1)} ${m.group(2)}');
  // Colapsa múltiplos espaços em um
  s = s.replaceAll(RegExp(r'\s{2,}'), ' ');
  return s;
}
