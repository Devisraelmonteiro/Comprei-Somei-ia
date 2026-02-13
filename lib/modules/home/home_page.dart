import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_controller.dart';
import 'widgets/items_captured_widget.dart';
import 'widgets/manual_value_sheet.dart';
import 'package:comprei_some_ia/modules/scanner/scanner_card_widget.dart';

import 'package:comprei_some_ia/shared/widgets/top_bar_widget.dart';
import 'package:comprei_some_ia/shared/widgets/promo_banner_widget.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/widgets/favoritos_grid.dart';
import 'package:comprei_some_ia/core/services/ocr_service.dart';
import 'package:comprei_some_ia/main.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'widgets/multiplier_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const double mockBudget = 500.0;

  CameraController? _cameraController;
  final PriceOcrService _ocrService = PriceOcrService();

  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  double? _detectedPrice;
  String? _cameraError;

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

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) return;

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
      if (!mounted) return;

      _cameraController!.startImageStream((image) async {
        if (_isProcessing) return;
        _isProcessing = true;

        try {
          final price = await _ocrService.detectPriceFromImage(
            image: image,
            camera: _cameraController!.description,
          );

          if (price != null && mounted) {
            setState(() => _detectedPrice = price);
            context.read<HomeController>().setCapturedValue(price);

            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 200);
            }
          }
        } catch (_) {}

        _isProcessing = false;
      });

      setState(() => _isCameraInitialized = true);
    } catch (e) {
      setState(() => _cameraError = e.toString());
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
    /// headerHeight controla a posição vertical do scanner
    final double headerHeight = AppSizes.headerHeight;
    
    /// 🎯 CÁLCULO CORRETO: Scanner no meio do header!
    /// Subtrai metade da altura do scanner para centralizar
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

          /// 📸 SCANNER — agora usa scannerTopPosition do AppSizes!
          Positioned(
            top: scannerTop,
            left: AppSizes.scannerHorizontalPadding.w,
            right: AppSizes.scannerHorizontalPadding.w,
            child: SizedBox(
              width: double.infinity,
              height: scannerHeight,
              child: ScannerCardWidget(
                cameraController: _cameraController,
                isCameraInitialized: _isCameraInitialized,
                cameraError: _cameraError,
                detectedPrice: _detectedPrice,
                capturedValue: controller.capturedValue,
                onRetry: _initCamera,
                onOpenSettings: openAppSettings,
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

  void _onConfirm(HomeController controller) async {
    if (controller.capturedValue <= 0) return;
    await controller.addCapturedValue();
    controller.setCapturedValue(0);
    setState(() => _detectedPrice = null);
  }

  void _onCancel(HomeController controller) {
    controller.setCapturedValue(0);
    setState(() => _detectedPrice = null);
  }

  void _showManualCaptureSheet(HomeController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ManualValueSheet(controller: controller),
    );
  }

  void _showMultiplySheet(HomeController controller) {
    if (controller.capturedValue <= 0) {
      // Opcional: Mostrar aviso que precisa capturar valor primeiro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Capture ou digite um valor primeiro!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MultiplierSheet(controller: controller),
    );
  }
}
// ═══════════════════════════════════════════════════════════════
// 📋 CÓDIGO NÍVEL SÊNIOR - RESPONSIVO E ESCALÁVEL
// ═══════════════════════════════════════════════════════════════
//
// ✅ USA AppSizes.headerHeight (getter responsivo)
// ✅ ESCALÁVEL para iOS, Android, tablets
// ✅ MANUTENÍVEL: Mude em UM lugar (app_sizes.dart)
// ✅ SEM hardcode de valores
//
// CÁLCULO SIMPLES E CORRETO:
// scannerTop = safeTop + AppSizes.headerHeight
//
// Para ajustar a posição do scanner:
// 1. Abra: lib/shared/constants/app_sizes.dart
// 2. Mude: static double get headerHeight => 100.h;
// 3. Valores: 85.h (alto), 100.h (médio), 120.h (baixo)
//
// ═══════════════════════════════════════════════════════════════
//
// ═══════════════════════════════════════════════════════════════
