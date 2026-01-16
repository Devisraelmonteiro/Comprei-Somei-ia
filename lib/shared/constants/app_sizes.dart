// lib/shared/constants/app_sizes.dart
import 'dart:io';

/// 📐 TAMANHOS RESPONSIVOS DO APP
/// Arquivo CENTRAL de design system
class AppSizes {
  AppSizes._();

  // ═══════════════════════════════════════════════════════════════
  // 🔝 HEADER / TOP BAR
  // ═══════════════════════════════════════════════════════════════
  static const double headerPaddingTop = 4;
  static const double headerPaddingBottom = 100;
  static const double headerPaddingHorizontal = 16;
  static const double headerBorderRadius = 20;

  static const double headerAvatarToGreetingSpacing = 12;
  static const double headerGreetingToSaldoSpacing = 1;
  static const double headerSaldoToValueSpacing = 0;

  // ═══════════════════════════════════════════════════════════════
  // 👤 AVATAR
  // ═══════════════════════════════════════════════════════════════
  static const double avatarSize = 40;
  static const double avatarBorderWidth = 1.5;

  // ═══════════════════════════════════════════════════════════════
  // 📝 FONTES – GERAIS
  // ═══════════════════════════════════════════════════════════════
  static const double displayLarge = 32;
  static const double displayMedium = 28;
  static const double displaySmall = 24;

  static const double headlineLarge = 22;
  static const double headlineMedium = 20;
  static const double headlineSmall = 18;

  static const double titleLarge = 18;
  static const double titleMedium = 16;
  static const double titleSmall = 14;

  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double bodySmall = 11;

  static const double labelLarge = 14;
  static const double labelMedium = 12;
  static const double labelSmall = 10;

  // ═══════════════════════════════════════════════════════════════
  // 🔝 HEADER – FONTES ESPECÍFICAS
  // ═══════════════════════════════════════════════════════════════
  static const double greetingText = 12;
  static const double balanceLabel = 10;
  static const double balanceValue = 15;

  // ═══════════════════════════════════════════════════════════════
  // 🎨 ÍCONES
  // ═══════════════════════════════════════════════════════════════
  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;
  static const double iconExtraLarge = 28;

  static const double eyeIconSize = 18;
  static const double eyeIconContainer = 25;

  // ═══════════════════════════════════════════════════════════════
  // 🔘 BOTÕES
  // ═══════════════════════════════════════════════════════════════
  static const double buttonHeight = 48;
  static const double buttonRadius = 12;
  static const double buttonPaddingHorizontal = 24;
  static const double buttonPaddingVertical = 12;

  // ═══════════════════════════════════════════════════════════════
  // 📦 CARDS
  // ═══════════════════════════════════════════════════════════════
  static const double cardRadius = 12;
  static const double cardPadding = 16;
  static const double cardElevation = 2;

  // ═══════════════════════════════════════════════════════════════
  // 🔲 SPACING (ESPAÇAMENTOS)
  // ═══════════════════════════════════════════════════════════════
  static const double spacingTiny = 4;
  static const double spacingSmall = 8;
  static const double spacingMedium = 12;
  static const double spacingLarge = 16;
  static const double spacingExtraLarge = 24;
  static const double spacingHuge = 32;

  // ═══════════════════════════════════════════════════════════════
  // 📐 LAYOUT GERAL
  // ═══════════════════════════════════════════════════════════════
  static const double screenPadding = 16;
  static const double modalRadius = 20;

  // ═══════════════════════════════════════════════════════════════
  // 🎯 BOTTOM NAVIGATION
  // ═══════════════════════════════════════════════════════════════
  static const double bottomNavHeight = 65;
  static const double bottomNavRadius = 30;
  static const double bottomNavPaddingHorizontal = 16;
  static const double bottomNavPaddingTop = 8;
  static const double bottomNavPaddingBottom = 10;

  // ═══════════════════════════════════════════════════════════════
  // 📸 SCANNER
  // ═══════════════════════════════════════════════════════════════
  static const double scannerTopPosition = 160;
  static const double scannerCardHeight = 180;
  static const double scannerRadius = 12;

  /// ✅ CONTROLE POR PLATAFORMA
  /// iOS: mantém 16 (layout perfeito)
  /// Android: 8 (scanner mais largo)
  static double get scannerHorizontalPadding {
    if (Platform.isAndroid) return 2;
    return 2;
  }

  // ═══════════════════════════════════════════════════════════════
  // 📄 CONTEÚDO
  // ═══════════════════════════════════════════════════════════════
  static const double contentStartPosition = 300;
  static const double contentBottomPadding = 83;

  // ═══════════════════════════════════════════════════════════════
  // 🛒 LISTA / PROGRESS
  // ═══════════════════════════════════════════════════════════════
  static const double categoryPillHeight = 32;
  static const double itemTileHeight = 60;
  static const double progressBarHeight = 4;
}
