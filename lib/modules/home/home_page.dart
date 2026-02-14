import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home_controller.dart';
import 'widgets/items_captured_widget.dart';
import 'widgets/manual_value_sheet.dart';
import 'package:comprei_some_ia/modules/scanner/scanner_card_widget.dart';
import 'package:comprei_some_ia/modules/scanner/controllers/scanner_controller.dart';

import 'package:comprei_some_ia/shared/widgets/top_bar_widget.dart';
import 'package:comprei_some_ia/shared/widgets/promo_banner_widget.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/widgets/favoritos_grid.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'widgets/multiplier_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const double mockBudget = 500.0;
  
  // 1. Instancia o Controller (Separação de Responsabilidade - Senior Level)
  final ScannerController _scannerController = ScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // 2. Inicializa a câmera via Controller
    _scannerController.initializeCamera();
    
    // 3. Escuta mudanças para atualizar o HomeController
    _scannerController.addListener(_onScannerChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.removeListener(_onScannerChanged);
    _scannerController.dispose();
    super.dispose();
  }

  void _onScannerChanged() {
    // Sincroniza o valor detectado com o HomeController
    // A lógica de "lock" já está encapsulada no ScannerController
    if (_scannerController.detectedPrice != null) {
      context.read<HomeController>().setCapturedValue(_scannerController.detectedPrice!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 🛑 CICLO DE VIDA (SENIOR LEVEL):
    // Apps de câmera DEVEM pausar a pré-visualização quando o app vai para background
    // Isso economiza bateria e evita crashes em alguns dispositivos Android.
    
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _scannerController.stopCamera();
    } else if (state == AppLifecycleState.resumed) {
      _scannerController.initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final remaining = mockBudget - controller.total;

    final media = MediaQuery.of(context);
    final safeTop = media.padding.top;
    final safeBottom = media.padding.bottom;

    /// 🔹 ALTURAS E POSIÇÕES - TOTALMENTE RESPONSIVO
    final double scannerHeight = AppSizes.scannerCardHeight;
    final double bottomNavHeight = AppSizes.bottomNavHeight;
    
    /// ✅ Scanner SOBREPÕE o header (metade dentro, metade fora)
    final double headerHeight = AppSizes.headerHeight;
    
    /// 🎯 CÁLCULO CORRETO: Scanner no meio do header!
    final double scannerTop = safeTop + headerHeight - (scannerHeight / 2);

    final double contentTop = scannerTop + scannerHeight + AppSizes.spacingMedium;

    return BaseScaffold(
      currentIndex: 0,
      userName: "Israel",
      
      child: Stack(
        children: [
          /// 🔶 HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBarWidget(
              userName: "Israel",
              remaining: remaining,
              userImagePath: "assets/images/user.jpg",
            ),
          ),

          /// 📸 SCANNER - Usando ListenableBuilder para reconstruir apenas este widget
          Positioned(
            top: scannerTop,
            left: AppSizes.scannerHorizontalPadding.w,
            right: AppSizes.scannerHorizontalPadding.w,
            child: SizedBox(
              width: double.infinity,
              height: scannerHeight,
              child: ListenableBuilder(
                listenable: _scannerController,
                builder: (context, child) {
                  return ScannerCardWidget(
                    cameraController: _scannerController.cameraController,
                    isCameraInitialized: _scannerController.isCameraInitialized,
                    cameraError: _scannerController.cameraError,
                    detectedPrice: _scannerController.detectedPrice,
                    capturedValue: controller.capturedValue,
                    onRetry: _scannerController.initializeCamera,
                    onOpenSettings: openAppSettings,
                  );
                },
              ),
            ),
          ),

          /// 📄 CONTEÚDO
          Positioned.fill(
            top: contentTop,
            bottom: bottomNavHeight + safeBottom,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding.w,
              ),
              child: Column(
                children: [
                  FavoritosGrid(
                    onConfirm: () => _onConfirm(controller),
                    onCancel: () => _onCancel(controller),
                    onMultiply: () => _showMultiplySheet(controller),
                    onManual: () => _showManualCaptureSheet(controller),
                  ),

                  SizedBox(height: AppSizes.spacingMedium.h),

                  PromoBannerWidget(onTap: () {}),

                  SizedBox(height: AppSizes.spacingSmall.h),

                  Expanded(
                    child: ItemsCapturedWidget(controller: controller),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔒 Wrapper Seguro para fluxos que precisam pausar o scanner
  Future<void> _runWithScannerPause(Future<void> Function() action) async {
    // 1. Pausa o scanner antes de abrir qualquer coisa
    _scannerController.pauseScanning();
    
    try {
      // 2. Executa a ação (ex: abrir modal)
      await action();
    } finally {
      // 3. Garante que o scanner volte a funcionar, mesmo se der erro
      _scannerController.resumeScanning();
    }
  }

  void _onConfirm(HomeController controller) async {
    if (controller.capturedValue <= 0) return;
    await controller.addCapturedValue();
    controller.setCapturedValue(0);
    _scannerController.clearDetectedPrice(); // Destrava o scanner para próxima leitura
  }

  void _onCancel(HomeController controller) {
    controller.setCapturedValue(0);
    _scannerController.clearDetectedPrice(); // Destrava o scanner
  }

  void _showManualCaptureSheet(HomeController controller) {
    _runWithScannerPause(() async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ManualValueSheet(controller: controller),
      );
    });
  }

  Future<void> _showMultiplySheet(HomeController controller) async {
    if (controller.capturedValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Capture ou digite um valor primeiro!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    await _runWithScannerPause(() async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => MultiplierSheet(controller: controller),
      );
    });
  }
}
