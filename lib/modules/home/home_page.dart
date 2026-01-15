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
            final previous = _detectedPrice;
            setState(() => _detectedPrice = price);

            final homeController = context.read<HomeController>();
            homeController.setCapturedValue(price);

            if (previous != price) {
              if (await Vibration.hasVibrator() ?? false) {
                Vibration.vibrate(duration: 300);
              }
            }
          }
        } catch (e) {
          debugPrint('Erro OCR: $e');
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
      ),
    );
  }

  Widget _buildScrollableContent(HomeController controller) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Positioned.fill(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 140.h + bottomSafeArea),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            ScannerCardWidget(
              cameraController: _cameraController,
              isCameraInitialized: _isCameraInitialized,
              cameraError: _cameraError,
              detectedPrice: _detectedPrice,
              capturedValue: controller.capturedValue,
              onRetry: _initCamera,
              onOpenSettings: openAppSettings,
            ),
            SizedBox(height: 10.h),
            FavoritosGrid(
              onConfirm: () => _onConfirm(context, controller),
              onCancel: () => _onCancel(context, controller),
              onMultiply: () => _showMultiplySheet(context, controller),
              onManual: () => _showManualCaptureSheet(context, controller),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: PromoBannerWidget(onTap: () {}),
            ),
            SizedBox(height: 6.h),
            ItemsCapturedWidget(controller: controller),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(minHeight: 2),
    );
  }

  void _onConfirm(BuildContext context, HomeController controller) async {
    if (controller.capturedValue <= 0) return;
    await controller.addCapturedValue();
    controller.setCapturedValue(0);
    setState(() => _detectedPrice = null);
  }

  void _onCancel(BuildContext context, HomeController controller) {
    controller.setCapturedValue(0);
    setState(() => _detectedPrice = null);
  }

  void _showManualCaptureSheet(BuildContext context, HomeController controller) {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final value = double.tryParse(textController.text);
                  if (value != null && value > 0) {
                    controller.setCapturedValue(value);
                  }
                  Navigator.of(ctx).pop();
                },
                child: const Text("Aplicar"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMultiplySheet(BuildContext context, HomeController controller) {
    final multiplierController = TextEditingController(text: "2");

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: multiplierController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final m = int.tryParse(multiplierController.text) ?? 1;
                  controller.setCapturedValue(controller.capturedValue * m);
                  Navigator.of(ctx).pop();
                },
                child: const Text("Aplicar"),
              ),
            ],
          ),
        );
      },
    );
  }
}
