import '../controllers/scanner_controller.dart';

class ScannerOcrService {
  final ScannerController controller;

  ScannerOcrService(this.controller);

  /// Simulação do OCR
  /// Depois você troca pelo OCR real sem mexer no controller
  void mockDetect(double value) {
    controller.onValueDetected(value);
  }
}
