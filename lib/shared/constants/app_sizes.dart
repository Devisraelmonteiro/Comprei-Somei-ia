// lib/shared/constants/app_sizes.dart

/// 📐 TAMANHOS PADRÃO DO APP
/// 
/// Centraliza todos os valores de dimensões para facilitar
/// manutenção e garantir consistência visual em todo o app.
/// 
/// USO:
/// - width: AppSizes.buttonHeight.h
/// - fontSize: AppSizes.bodyText.sp
class AppSizes {
  // === PRIVADO (impede instanciação) ===
  AppSizes._();

  // ===========================
  // 🔝 HEADER / TOP BAR
  // ===========================
  static const double headerHeight = 200;
  static const double headerPaddingHorizontal = 20;
  static const double headerPaddingTop = 2;  // Avatar mais no topo
  static const double headerPaddingBottom = 20;
  static const double headerBorderRadius = 20;
  
  // 🎯 ESPAÇAMENTOS INTERNOS DO HEADER (controle fino)
  static const double headerAvatarToGreetingSpacing = 12;   // Entre avatar e "Olá, Israel"
  static const double headerGreetingToSaldoSpacing = 4;     // Entre "Olá, Israel" e "Saldo"
  static const double headerSaldoToValueSpacing = 0;        // Entre "Saldo" e "R$ 454,00"

  // ===========================
  // 👤 AVATAR
  // ===========================
  static const double avatarSize = 42;
  static const double avatarBorderWidth = 1.5;

  // ===========================
  // 📝 FONTES
  // ===========================
  // Títulos grandes
  static const double displayLarge = 32;
  static const double displayMedium = 28;
  static const double displaySmall = 24;

  // Títulos médios
  static const double headlineLarge = 22;
  static const double headlineMedium = 20;
  static const double headlineSmall = 18;

  // Títulos pequenos
  static const double titleLarge = 18;
  static const double titleMedium = 16;
  static const double titleSmall = 14;

  // Texto corpo
  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double bodySmall = 12;

  // Labels
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
  static const double buttonRadius = 12;
  static const double buttonPaddingHorizontal = 24;
  static const double buttonPaddingVertical = 12;

  // ===========================
  // 🎨 ÍCONES
  // ===========================
  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;
  static const double iconExtraLarge = 28;

  // Header específico
  static const double eyeIconSize = 22;
  static const double eyeIconContainer = 40;

  // ===========================
  // 📦 CARDS
  // ===========================
  static const double cardRadius = 12;
  static const double cardPadding = 16;
  static const double cardElevation = 2;

  // ===========================
  // 🔲 SPACING
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
  
  // 🎯 BOTTOM NAVIGATION BAR - Valores da segunda imagem (que funciona!)
  // 
  // Estes valores foram extraídos da segunda imagem que NÃO tem overflow
  // e funcionam perfeitamente em todos os dispositivos
  // 
  // ⚠️ NÃO MUDE ESTES VALORES SEM TESTAR!
  static const double bottomNavHeight = 64;                // Altura confortável (segunda imagem)
  static const double bottomNavRadius = 30;                // Bem arredondado
  static const double bottomNavPaddingHorizontal = 16;     // Margem lateral
  static const double bottomNavPaddingTop = 0;             // Sem padding extra no topo
  static const double bottomNavPaddingBottom = 8;          // Pequeno espaço no fundo

  // ===========================
  // 📸 SCANNER
  // ===========================
  static const double scannerCardHeight = 240;
  static const double scannerRadius = 10;

  // ===========================
  // 🛒 LISTA DE COMPRAS
  // ===========================
  static const double categoryPillHeight = 32;
  static const double itemTileHeight = 60;
  static const double progressBarHeight = 4;
}