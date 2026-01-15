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
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

/// 🏠 Home Page - LAYOUT FIXO + CÁLCULO DINÂMICO PROFISSIONAL
/// 
/// Características principais:
/// ✅ Scanner SOBREPÕE o header (70% dentro do laranja)
/// ✅ Layout FIXO (sem scroll na página principal)
/// ✅ Sistema DINÂMICO (adapta em qualquer dispositivo)
/// ✅ Código SENIOR (LayoutBuilder + MediaQuery)
/// 
/// 📝 PRINCIPAIS AJUSTES POSSÍVEIS:
/// 
/// 🎯 POSIÇÃO DO SCANNER:
/// - Linha 212: top (posição vertical do scanner)
///   • Aumentar = scanner mais para baixo
///   • Diminuir = scanner mais para cima (mais dentro do laranja)
/// 
/// 🎯 ESPAÇO DO CONTEÚDO:
/// - Linha 249: top (onde o conteúdo começa, abaixo do scanner)
///   • Fórmula: posição scanner + altura scanner + espaço
///   • Scanner topo (212) + altura (240) + espaço (10) = 462
/// - Linha 250: bottom (espaço para bottom nav)
///   • Aumentar = mais espaço no fundo
///   • Diminuir = menos espaço
/// 
/// 🎯 ESPAÇAMENTOS ENTRE ELEMENTOS:
/// - Linha 258: espaço após scanner (10.h)
/// - Linha 267: espaço após botões (10.h)
/// - Linha 276: espaço após banner (6.h)
/// 
/// 🎯 ORÇAMENTO MOCK:
/// - Linha 37: mockBudget (valor inicial do saldo)
///   • Alterar para testar com valores diferentes
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // 💰 ORÇAMENTO INICIAL (mock)
  // Alterar aqui para testar com valores diferentes
  // Exemplo: 1000.0, 300.0, etc.
  static const double mockBudget = 500.0;

  // 📸 CÂMERA E OCR
  CameraController? _cameraController;
  final PriceOcrService _ocrService = PriceOcrService();

  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  double? _detectedPrice;
  String? _cameraError;

  // ═══════════════════════════════════════════════════════════════
  // 🔄 LIFECYCLE METHODS (gerenciamento de estado)
  // ═══════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════
  // 📸 INICIALIZAÇÃO DA CÂMERA
  // ═══════════════════════════════════════════════════════════════

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
                // ⏱️ DURAÇÃO DA VIBRAÇÃO
                // Aumentar = vibração mais longa
                // Diminuir = vibração mais curta
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

  // ═══════════════════════════════════════════════════════════════
  // 🎨 BUILD PRINCIPAL
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final remaining = mockBudget - controller.total;

    return BaseScaffold(
      currentIndex: 0,
      userName: "Israel",
      child: Stack(
        children: [
          // 1️⃣ Conteúdo fixo (atrás de tudo)
          _buildFixedContent(controller),
          
          // 2️⃣ Header laranja (no meio)
          _buildTopBar(remaining),
          
          // 3️⃣ Scanner (na frente, sobrepõe o header)
          _buildOverlayScanner(controller),
          
          // 4️⃣ Loading indicator
          if (controller.loading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔝 HEADER LARANJA
  // ═══════════════════════════════════════════════════════════════

  /// Header compacto com avatar, saudação e saldo
  /// 
  /// 📝 Customização feita no arquivo top_bar_widget.dart
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

  // ═══════════════════════════════════════════════════════════════
  // 📸 SCANNER (SOBREPÕE O HEADER)
  // ═══════════════════════════════════════════════════════════════

  /// Scanner posicionado para sobrepor o header (70% dentro do laranja)
  /// 
  /// 📝 COMO AJUSTAR A POSIÇÃO:
  /// - top: altura em pixels (com .h para responsividade)
  /// - left/right: margens laterais
  /// 
  /// 🎯 VALORES RECOMENDADOS:
  /// - top: 120.h a 150.h (70% dentro do laranja)
  /// - left/right: 16.w (padding padrão)
  Widget _buildOverlayScanner(HomeController controller) {
    return Positioned(
      // 📐 POSIÇÃO VERTICAL DO SCANNER
      // Aumentar = scanner mais para baixo (menos dentro do laranja)
      // Diminuir = scanner mais para cima (mais dentro do laranja)
      // VALOR ATUAL: 120.h (70% dentro do header)
      top: 110.h,
      
      // 📐 MARGENS LATERAIS
      // Aumentar = scanner mais estreito
      // Diminuir = scanner mais largo
      left: 0.w,
      right: 0.w,
      
      child: ScannerCardWidget(
        cameraController: _cameraController,
        isCameraInitialized: _isCameraInitialized,
        cameraError: _cameraError,
        detectedPrice: _detectedPrice,
        capturedValue: controller.capturedValue,
        onRetry: _initCamera,
        onOpenSettings: openAppSettings,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 📄 CONTEÚDO FIXO (BOTÕES + BANNER + LISTA)
  // ═══════════════════════════════════════════════════════════════

  /// Conteúdo abaixo do scanner (layout fixo, sem scroll)
  /// 
  /// 📝 COMO AJUSTAR O LAYOUT:
  /// 
  /// 🎯 PADDING TOP:
  /// - Linha 249: onde o conteúdo começa
  /// - Fórmula: posição scanner + altura scanner + espaço
  /// - Exemplo: 120 (top scanner) + 240 (altura) + 10 (espaço) = 370
  /// 
  /// 🎯 PADDING BOTTOM:
  /// - Linha 250: espaço para bottom nav + SafeArea
  /// - bottomSafeArea = adaptativo (varia por dispositivo)
  /// 
  /// 🎯 COMPONENTES:
  /// 1. Botões de ação (Confirmar, Cancelar, etc.)
  /// 2. Banner promocional
  /// 3. Lista de itens capturados (expansível)
  Widget _buildFixedContent(HomeController controller) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 🎯 CÁLCULO DINÂMICO DO BOTTOM NAV
          // Pega o SafeArea do dispositivo automaticamente
          final bottomSafeArea = MediaQuery.of(context).padding.bottom;
          
          return Padding(
            padding: EdgeInsets.only(
              // 📐 ONDE O CONTEÚDO COMEÇA (abaixo do scanner)
              // Aumentar = conteúdo mais para baixo
              // Diminuir = conteúdo mais para cima
              // CÁLCULO: Scanner (120) + Altura scanner (240) + Espaço (10) = 370
              top: 290.h,
              
              // 📐 ESPAÇO PARA BOTTOM NAV
              // Aumentar = mais espaço no fundo
              // Diminuir = menos espaço
              // FÓRMULA: valor fixo + SafeArea (dinâmico)
              bottom: 80.h + bottomSafeArea,
            ),
            child: Column(
              children: [
                // ✅ BOTÕES DE AÇÃO (Confirmar, Cancelar, Multiplicar, Manual)
                FavoritosGrid(
                  onConfirm: () => _onConfirm(context, controller),
                  onCancel: () => _onCancel(context, controller),
                  onMultiply: () => _showMultiplySheet(context, controller),
                  onManual: () => _showManualCaptureSheet(context, controller),
                ),
                
                // 📏 ESPAÇO APÓS BOTÕES
                // Aumentar = mais espaço
                // Diminuir = menos espaço
                SizedBox(height: 10.h),
                
                // 🎁 BANNER PROMOCIONAL
                Padding(
                  // 📏 PADDING LATERAL DO BANNER
                  // Aumentar = banner mais estreito
                  // Diminuir = banner mais largo
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: PromoBannerWidget(
                    onTap: () => debugPrint('Banner clicado'),
                  ),
                ),
                
                // 📏 ESPAÇO APÓS BANNER
                // Aumentar = mais espaço
                // Diminuir = menos espaço
                SizedBox(height: 6.h),
                
                // 📋 LISTA DE ITENS CAPTURADOS
                // Expanded = ocupa todo espaço disponível restante
                // A lista tem scroll interno (ItemsCapturedWidget)
                Expanded(
                  child: ItemsCapturedWidget(controller: controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ⏳ LOADING INDICATOR
  // ═══════════════════════════════════════════════════════════════

  /// Barra de progresso no topo (quando carregando)
  /// 
  /// 📝 COMO AJUSTAR:
  /// - minHeight: espessura da barra
  Widget _buildLoadingIndicator() {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      // 📏 ALTURA DA BARRA DE LOADING
      // Aumentar = barra mais grossa
      // Diminuir = barra mais fina
      child: LinearProgressIndicator(minHeight: 2),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎬 AÇÕES DOS BOTÕES
  // ═══════════════════════════════════════════════════════════════

  /// ✅ Confirmar valor capturado (adiciona na lista)
  void _onConfirm(BuildContext context, HomeController controller) async {
    if (controller.capturedValue <= 0) return;
    await controller.addCapturedValue();
    controller.setCapturedValue(0);
    setState(() => _detectedPrice = null);
  }

  /// ❌ Cancelar valor capturado (limpa)
  void _onCancel(BuildContext context, HomeController controller) {
    controller.setCapturedValue(0);
    setState(() => _detectedPrice = null);
  }

  // ═══════════════════════════════════════════════════════════════
  // 📱 MODAL SHEETS (TELAS DE INPUT)
  // ═══════════════════════════════════════════════════════════════

  /// ✏️ Modal para inserir valor manualmente
  /// 
  /// 📝 COMO AJUSTAR:
  /// - Padding: linha 311-316
  /// - Campos do TextField: decoration
  void _showManualCaptureSheet(BuildContext context, HomeController controller) {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          // 📏 PADDING DO MODAL
          // bottom: teclado + espaço extra
          // left/right: margens laterais
          // top: espaço superior
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
                decoration: const InputDecoration(
                  labelText: "Valor",
                  prefixText: "R\$ ",
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final value = double.tryParse(textController.text.replaceAll(",", "."));
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

  /// ✖️ Modal para multiplicar valor
  /// 
  /// 📝 COMO AJUSTAR:
  /// - Valor padrão: linha 366 (text: "2")
  /// - Padding: linha 371
  void _showMultiplySheet(BuildContext context, HomeController controller) {
    // 🔢 VALOR PADRÃO DO MULTIPLICADOR
    // Alterar "2" para outro número (3, 4, 5, etc.)
    final multiplierController = TextEditingController(text: "2");

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          // 📏 PADDING DO MODAL
          // Aumentar = mais espaço interno
          // Diminuir = menos espaço
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: multiplierController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Multiplicador",
                ),
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

// ═══════════════════════════════════════════════════════════════
// 📋 RESUMO DE AJUSTES RÁPIDOS
// ═══════════════════════════════════════════════════════════════
//
// 🎯 POSIÇÃO DO SCANNER:
// - Linha 212: top (120.h) - Scanner 70% dentro do laranja
//   • Aumentar = mais para baixo
//   • Diminuir = mais para cima
//
// 🎯 ESPAÇO DO CONTEÚDO:
// - Linha 249: top (370.h) - Onde começa o conteúdo
//   • Fórmula: Scanner top + altura + espaço
// - Linha 250: bottom (80.h + SafeArea) - Espaço bottom nav
//
// 🎯 ESPAÇAMENTOS:
// - Linha 258: Após botões = 10.h
// - Linha 267: Após banner = 6.h
//
// 🎯 ORÇAMENTO MOCK:
// - Linha 37: mockBudget = 500.0
//   • Alterar para testar com valores diferentes
//
// 🎯 VIBRAÇÃO:
// - Linha 169: duration (300ms)
//   • Aumentar = vibração mais longa
//   • Diminuir = vibração mais curta
//
// 🎯 MODAL MULTIPLICADOR:
// - Linha 366: Valor padrão = "2"
//   • Alterar para 3, 4, 5, etc.
//
// ═══════════════════════════════════════════════════════════════