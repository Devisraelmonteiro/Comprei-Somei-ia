import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_controller.dart';
import 'widgets/scanner_card_widget.dart';
import 'widgets/items_captured_widget.dart';
import 'package:comprei_some_ia/shared/widgets/top_bar_widget.dart';
import 'package:comprei_some_ia/shared/widgets/promo_banner_widget.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/widgets/favoritos_grid.dart';
import 'package:comprei_some_ia/core/services/ocr_service.dart';
import 'package:comprei_some_ia/main.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

/// 🏠 Página principal do app - VERSÃO 2025 PROFISSIONAL
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

  Future<void> _initCamera() async {
    try {
      print('🔍 Iniciando câmera...');
      
      if (cameras.isEmpty) {
        setState(() {
          _cameraError = AppStrings.errorNoCamera;
          _isCameraInitialized = false;
        });
        return;
      }

      final status = await Permission.camera.request();
      
      if (status.isDenied) {
        setState(() {
          _cameraError = AppStrings.errorCameraPermission;
          _isCameraInitialized = false;
        });
        return;
      }

      if (status.isPermanentlyDenied) {
        setState(() {
          _cameraError = AppStrings.permissionCameraDenied;
          _isCameraInitialized = false;
        });
        await openAppSettings();
        return;
      }

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

      if (!mounted) return;

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
            
            if (previousPrice != price) {
              if (await Vibration.hasVibrator() ?? false) {
                Vibration.vibrate(duration: 500);
              }
            }
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
    } catch (e) {
      setState(() {
        _cameraError = 'Erro: $e';
        _isCameraInitialized = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final remaining = mockBudget - controller.total;

    return BaseScaffold(
      currentIndex: 0,
      userName: "Israel",
      child: Stack(
        children: [
          _buildTopBar(remaining),
          _buildScrollableContent(controller),
          if (controller.loading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildTopBar(double remaining) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: TopBarWidget(
        userName: "Israel",
        remaining: remaining,
        userImagePath: "assets/images/user.jpg",
        height: AppSizes.headerHeight.h,
        greetingFontSize: AppSizes.titleMedium.sp,
        balanceLabelFontSize: AppSizes.labelLarge.sp,
        balanceValueFontSize: AppSizes.displayMedium.sp,
      ),
    );
  }

  Widget _buildScrollableContent(HomeController controller) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSizes.headerHeight.h,
          bottom: MediaQuery.of(context).padding.bottom + 52.h + 12.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScannerCardWidget(
              cameraController: _cameraController,
              isCameraInitialized: _isCameraInitialized,
              cameraError: _cameraError,
              detectedPrice: _detectedPrice,
              capturedValue: controller.capturedValue,
              onRetry: _initCamera,
              onOpenSettings: openAppSettings,
            ),
            
            SizedBox(height: AppSizes.spacingMedium.h),
              
            FavoritosGrid(
              onConfirm: () => _onConfirm(context, controller),
              onCancel: () => _onCancel(context, controller),
              onMultiply: () => _showMultiplySheet(context, controller),
              onManual: () => _showManualCaptureSheet(context, controller),
            ),
            
            SizedBox(height: AppSizes.spacingMedium.h),
              
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding.w),
              child: PromoBannerWidget(
                onTap: () => print("Banner clicado!"),
              ),
            ),
            
            SizedBox(height: AppSizes.spacingTiny.h),
            
            ItemsCapturedWidget(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(minHeight: 2.h),
    );
  }

  void _onConfirm(BuildContext context, HomeController controller) async {
    if (controller.capturedValue <= 0) {
      _showSnack(context, AppStrings.errorNoValue);
      return;
    }
    
    await controller.addCapturedValue();
    controller.setCapturedValue(0.0);
    setState(() => _detectedPrice = null);
    _showSnack(context, AppStrings.successValueAdded);
  }

  void _onCancel(BuildContext context, HomeController controller) {
    controller.setCapturedValue(0.0);
    setState(() => _detectedPrice = null);
    _showSnack(context, AppStrings.successValueCleared);
  }

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.modalRadius.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSizes.screenPadding.h,
            top: AppSizes.screenPadding.h,
            left: AppSizes.screenPadding.w,
            right: AppSizes.screenPadding.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.modalManualTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.bodyMedium.sp,
                ),
              ),
              SizedBox(height: AppSizes.spacingMedium.h),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: AppStrings.modalManualHint,
                  prefixText: "R\$ ",
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(fontSize: AppSizes.bodySmall.sp),
                ),
                style: TextStyle(fontSize: AppSizes.bodyMedium.sp),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
              ),
              SizedBox(height: AppSizes.spacingMedium.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(AppStrings.btnCancel, style: TextStyle(fontSize: AppSizes.bodySmall.sp)),
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingSmall.w),
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
                      child: Text(AppStrings.btnApply, style: TextStyle(fontSize: AppSizes.bodySmall.sp)),
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

  void _showMultiplySheet(BuildContext context, HomeController controller) {
    if (controller.capturedValue <= 0) {
      _showSnack(context, AppStrings.errorNoMultiplier);
      return;
    }
    
    final multiplierController = TextEditingController(text: "2");

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.modalRadius.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(AppSizes.screenPadding.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.modalMultiplyTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.bodyMedium.sp,
                ),
              ),
              SizedBox(height: AppSizes.spacingMedium.h),
              TextField(
                controller: multiplierController,
                decoration: InputDecoration(
                  labelText: AppStrings.modalMultiplyHint,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(fontSize: AppSizes.bodySmall.sp),
                ),
                style: TextStyle(fontSize: AppSizes.bodyMedium.sp),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                autofocus: true,
              ),
              SizedBox(height: AppSizes.spacingMedium.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(AppStrings.btnCancel, style: TextStyle(fontSize: AppSizes.bodySmall.sp)),
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingSmall.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final m = int.tryParse(multiplierController.text) ?? 0;
                        if (m <= 0) return;
                        
                        controller.setCapturedValue(controller.capturedValue * m);
                        Navigator.of(ctx).pop();
                      },
                      child: Text(AppStrings.btnApply, style: TextStyle(fontSize: AppSizes.bodySmall.sp)),
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

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
