/// 📐 TAMANHOS PADRÃO DO APP - VALORES TESTADOS E APROVADOS
/// 
/// Baseado na SEGUNDA imagem (layout correto, sem overflow)
class AppSizes {
  AppSizes._();

  // ===========================
  // 🔝 HEADER / TOP BAR
  // ===========================
  static const double headerHeight = 230;
  static const double headerPaddingHorizontal = 20;
  static const double headerPaddingTop = 6;
  static const double headerPaddingBottom = 22;
  static const double headerBorderRadius = 24;
  
  // 🎯 Espaçamentos internos do header
  static const double headerAvatarToGreetingSpacing = 12;
  static const double headerGreetingToSaldoSpacing = 6;
  static const double headerSaldoToValueSpacing = 2;

  // ===========================
  // 👤 AVATAR
  // ===========================
  static const double avatarSize = 42;
  static const double avatarBorderWidth = 1.5;

  // ===========================
  // 📝 FONTES (Typography Scale)
  // ===========================
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
  static const double bodySmall = 12;
  
  static const double labelLarge = 14;
  static const double labelMedium = 12;
  static const double labelSmall = 10;
  
  // Header específico
  static const double greetingText = 16;
  static const double balanceLabel = 13;
  static const double balanceValue = 28;

  // ===========================
  // 🔘 BOTÕES
  // ===========================
  static const double buttonHeight = 48;
  static const double buttonRadius = 14;
  static const double buttonPaddingHorizontal = 24;
  static const double buttonPaddingVertical = 12;

  // ===========================
  // 🎨 ÍCONES
  // ===========================
  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;
  static const double iconExtraLarge = 28;
  
  static const double eyeIconSize = 22;
  static const double eyeIconContainer = 40;

  // ===========================
  // 📦 CARDS
  // ===========================
  static const double cardRadius = 14;
  static const double cardPadding = 16;
  static const double cardElevation = 2;

  // ===========================
  // 🔲 SPACING (8px Grid System)
  // ===========================
  static const double spacingTiny = 4;
  static const double spacingSmall = 8;
  static const double spacingMedium = 12;
  static const double spacingLarge = 16;
  static const double spacingExtraLarge = 24;
  static const double spacingHuge = 32;

  // ===========================
  // 📐 LAYOUT
  // ===========================
  static const double screenPadding = 16;
  static const double modalRadius = 20;
  
  // ===========================
  // 🔻 BOTTOM NAVIGATION BAR
  // (Ajustado para NÃO dar overflow)
  // ===========================
  static const double bottomNavHeight = 72;
  static const double bottomNavRadius = 32;
  static const double bottomNavPaddingHorizontal = 18;
  static const double bottomNavPaddingTop = 4;
  static const double bottomNavPaddingBottom = 10;

  // ===========================
  // 📸 SCANNER
  // ===========================
  static const double scannerCardHeight = 210;
  static const double scannerRadius = 14;

  // ===========================
  // 🛒 LISTA DE COMPRAS
  // ===========================
  static const double categoryPillHeight = 34;
  static const double itemTileHeight = 64;
  static const double progressBarHeight = 4;
}
