import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import 'home_controller.dart';
import 'widgets/scanner_card_widget.dart';
import 'widgets/items_captured_widget.dart';
import 'package:comprei_some_ia/shared/widgets/top_bar_widget.dart';
import 'package:comprei_some_ia/shared/widgets/promo_banner_widget.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/widgets/favoritos_grid.dart';
import 'package:comprei_some_ia/core/services/ocr_service.dart';
import 'package:comprei_some_ia/main.dart';

/// 🏠 Página principal do app
/// 
/// Responsabilidades:
/// - Coordenar widgets da UI
/// - Gerenciar estado da câmera
/// - Processar OCR em tempo real
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // === CONSTANTES ===
  static const double mockBudget = 500.0;
  
  // === CÂMERA E OCR ===
  CameraController? _cameraController;
  final PriceOcrService _ocrService = PriceOcrService();
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  double? _detectedPrice;
  String? _cameraError;

  // === LIFECYCLE ===
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  // === INICIALIZAÇÃO DA CÂMERA ===
  
  /// 📸 Inicializa câmera e inicia stream de OCR
  Future<void> _initCamera() async {
    try {
      print('🔍 Iniciando câmera...');
      
      // Verificar se existem câmeras disponíveis
      if (cameras.isEmpty) {
        setState(() {
          _cameraError = 'Nenhuma câmera encontrada no dispositivo';
          _isCameraInitialized = false;
        });
        print('❌ Nenhuma câmera disponível');
        return;
      }

      print('📸 ${cameras.length} câmera(s) encontrada(s)');

      // Solicitar permissão
      print('🔐 Solicitando permissão de câmera...');
      final status = await Permission.camera.request();
      
      if (status.isDenied) {
        setState(() {
          _cameraError = 'Permissão de câmera negada';
          _isCameraInitialized = false;
        });
        print('❌ Permissão negada');
        return;
      }

      if (status.isPermanentlyDenied) {
        setState(() {
          _cameraError = 'Permissão negada permanentemente. Ative nas configurações.';
          _isCameraInitialized = false;
        });
        print('❌ Permissão negada permanentemente');
        await openAppSettings();
        return;
      }

      print('✅ Permissão concedida');

      // Inicializar controller
      print('🎥 Inicializando controller...');
      
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
      print('✅ Controller inicializado');

      if (!mounted) return;

      // Iniciar stream de OCR
      print('🔥 Iniciando stream de OCR...');
      _cameraController!.startImageStream((CameraImage image) async {
        if (_isProcessing) return;
        _isProcessing = true;

        try {
          final price = await _ocrService.detectPriceFromImage(
            image: image,
            camera: _cameraController!.description,
          );

          if (price != null && mounted) {
            final previousPrice = _detectedPrice;
            setState(() => _detectedPrice = price);
            
            final controller = context.read<HomeController>();
            controller.setCapturedValue(price);
            
            // Vibrar quando detectar novo preço
            if (previousPrice != price) {
              if (await Vibration.hasVibrator() ?? false) {
                Vibration.vibrate(duration: 500);
              }
            }
            
            print('💰 Preço detectado: R\$ ${price.toStringAsFixed(2)}');
          }
        } catch (e) {
          print('⚠️ Erro no OCR: $e');
        }

        _isProcessing = false;
      });

      setState(() {
        _isCameraInitialized = true;
        _cameraError = null;
      });
      
      print('✅ Câmera totalmente inicializada!');
    } catch (e) {
      print('❌ Erro ao inicializar câmera: $e');
      setState(() {
        _cameraError = 'Erro: $e';
        _isCameraInitialized = false;
      });
    }
  }

  // === BUILD ===
  
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final remaining = mockBudget - controller.total;

    return BaseScaffold(
      currentIndex: 0,
      userName: "Israel",
      child: Stack(
        children: [
          // Header
          _buildTopBar(remaining),
          
          // Conteúdo scrollável
          _buildScrollableContent(controller),
          
          // Loading indicator
          if (controller.loading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  /// 🔝 Barra superior
  Widget _buildTopBar(double remaining) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: TopBarWidget(
        userName: "Israel",
        remaining: remaining,
        userImagePath: "assets/images/user.jpg",
        height: 200,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        avatarSize: 42,
        greetingFontSize: 14,
        balanceLabelFontSize: 12,
        balanceValueFontSize: 18,
        eyeIconSize: 20,
        eyeInsets: const EdgeInsets.only(right: 210, top: 30),
        spaceBetweenAvatarAndText: 10,
        spaceBetweenGreetingAndBalance: 2,
        spaceBetweenBalanceLabelAndValue: 0,
      ),
    );
  }

  /// 📜 Conteúdo SEM scroll (layout fixo)
Widget _buildScrollableContent(HomeController controller) {
  return Positioned.fill(
    child: Padding(
      padding: EdgeInsets.only(
        top: 100,
        bottom: MediaQuery.of(context).padding.bottom + 52 + 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scanner
          ScannerCardWidget(
            cameraController: _cameraController,
            isCameraInitialized: _isCameraInitialized,
            cameraError: _cameraError,
            detectedPrice: _detectedPrice,
            capturedValue: controller.capturedValue,
            onRetry: _initCamera,
            onOpenSettings: openAppSettings,
          ),
          
          const SizedBox(height: 10),
            
           // Botões de ação
          FavoritosGrid(
            onConfirm: () => _onConfirm(context, controller),
            onCancel: () => _onCancel(context, controller),
            onMultiply: () => _showMultiplySheet(context, controller),
            onManual: () => _showManualCaptureSheet(context, controller),
          ),
          
          const SizedBox(height: 10),
            
            // Banner promocional
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PromoBannerWidget(
                onTap: () => print("Banner clicado!"),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Lista de itens capturados
            ItemsCapturedWidget(controller: controller),
            
          ],
        ),
      ),
    
  );
  }

  /// ⏳ Indicador de loading
  Widget _buildLoadingIndicator() {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(minHeight: 2),
    );
  }

  // === AÇÕES ===
  
  /// ✅ Confirmar valor capturado
  void _onConfirm(BuildContext context, HomeController controller) async {
    if (controller.capturedValue <= 0) {
      _showSnack(context, "Defina um valor antes de confirmar.");
      return;
    }
    
    await controller.addCapturedValue();
    controller.setCapturedValue(0.0);
    setState(() => _detectedPrice = null);
    _showSnack(context, "Valor adicionado!");
  }

  /// ❌ Cancelar valor capturado
  void _onCancel(BuildContext context, HomeController controller) {
    controller.setCapturedValue(0.0);
    setState(() => _detectedPrice = null);
    _showSnack(context, "Valor limpo.");
  }

  // === MODAL SHEETS ===
  
  /// ✏️ Modal para inserir valor manualmente
  void _showManualCaptureSheet(
    BuildContext context,
    HomeController controller,
  ) {
    final textController = TextEditingController(
      text: controller.capturedValue == 0
          ? ''
          : controller.capturedValue.toStringAsFixed(2),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Inserir valor manualmente",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: "Valor (em reais)",
                  prefixText: "R\$ ",
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final raw = textController.text
                            .replaceAll("R\$", "")
                            .replaceAll(" ", "")
                            .replaceAll(",", ".");
                        final value = double.tryParse(raw);
                        
                        if (value == null || value <= 0) return;
                        
                        controller.setCapturedValue(value);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Aplicar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ✖️ Modal para multiplicar valor
  void _showMultiplySheet(BuildContext context, HomeController controller) {
    if (controller.capturedValue <= 0) {
      _showSnack(context, "Defina um valor para multiplicar.");
      return;
    }
    
    final multiplierController = TextEditingController(text: "2");

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Multiplicar valor",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: multiplierController,
                decoration: const InputDecoration(
                  labelText: "Multiplicador",
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final m = int.tryParse(multiplierController.text) ?? 0;
                        if (m <= 0) return;
                        
                        controller.setCapturedValue(
                          controller.capturedValue * m,
                        );
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Aplicar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // === UTILITÁRIOS ===
  
  /// 📢 Mostrar snackbar
  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}