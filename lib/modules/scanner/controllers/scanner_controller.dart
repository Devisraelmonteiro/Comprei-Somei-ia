import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:comprei_some_ia/core/services/ocr_service.dart';
import '../models/scanned_value.dart';

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
  bool _isPaused = false;
  
  // Getters
  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  String? get cameraError => _cameraError;
  double? get detectedPrice => _detectedPrice;
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

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
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
        final price = await _ocrService.detectPriceFromImage(
          image: image,
          camera: _cameraController!.description,
        );

        if (price != null) {
          _detectedPrice = price;
          notifyListeners(); // Notifica a UI que achou um preço

          // 📳 Feedback Hápitico (UX)
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 200);
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
