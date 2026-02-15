// lib/shared/constants/app_sizes.dart

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 📐 TAMANHOS RESPONSIVOS DO APP - NÍVEL SÊNIOR
/// 
/// ✅ Escalável para iOS e Android
/// ✅ Usa ScreenUtil (.h, .w, .sp, .r)
/// ✅ Todos os valores em um único lugar
/// ✅ Fácil manutenção
class AppSizes {
  AppSizes._();

  // ═══════════════════════════════════════════════════════════════
  // 🔝 HEADER - LAYOUT
  // ═══════════════════════════════════════════════════════════════
  
  /// Altura do header (controla posição do scanner)
  /// Este valor controla onde o scanner aparece verticalmente
  /// - 120: scanner mais alto
  /// - 140: posição PERFEITA (padrão) ✅
  /// - 150: scanner um pouco mais baixo
  /// - 160: scanner mais baixo ainda
  static double get headerHeight => 140.h;
  
  static double get headerPaddingTop => 0.h;
  
  /// ✅ Padding bottom GRANDE para criar fundo laranja nas laterais do scanner!
  /// O scanner vai SOBREPOR o header no centro
  static double get headerPaddingBottom => 100.h;
  
  static double get headerPaddingHorizontal => 16.w;
  static double get headerBorderRadius => 20.r;
  
  /// Espaçamentos internos do header (textos colados)
  static double get headerAvatarToGreetingSpacing => 5.w;
  static double get headerGreetingToSaldoSpacing => 0.h;
  static double get headerSaldoToValueSpacing => 0.h;

  // ═══════════════════════════════════════════════════════════════
  // 👤 AVATAR
  // ═══════════════════════════════════════════════════════════════
  
  static double get avatarSize => 40.w;
  static double get avatarBorderWidth => 1.5;

  // ═══════════════════════════════════════════════════════════════
  // 📝 FONTES - ESCALÁVEIS
  // ═══════════════════════════════════════════════════════════════
  
  static double get displayLarge => 32.sp;
  static double get displayMedium => 28.sp;
  static double get displaySmall => 24.sp;
  static double get headlineLarge => 22.sp;
  static double get headlineMedium => 20.sp;
  static double get headlineSmall => 18.sp;
  static double get titleLarge => 18.sp;
  static double get titleMedium => 16.sp;
  static double get titleSmall => 14.sp;
  static double get titleExtraSmall => 12.sp;  // ← NOVO! Para títulos menores
  static double get bodyLarge => 16.sp;
  static double get bodyMedium => 14.sp;
  static double get bodySmall => 11.sp;
  static double get labelLarge => 14.sp;
  static double get labelMedium => 12.sp;
  static double get labelSmall => 10.sp;

  // ═══════════════════════════════════════════════════════════════
  // 🔝 HEADER - FONTES ESPECÍFICAS
  // ═══════════════════════════════════════════════════════════════
  
  static double get greetingText => 12.sp;
  static double get balanceLabel => 10.sp;
    static double get balanceExtraLabel => 12.sp;
  static double get balanceValue => 12.sp;
  static double get balanceExtraValue => 15.sp;

  // ═══════════════════════════════════════════════════════════════
  // 🎨 ÍCONES
  // ═══════════════════════════════════════════════════════════════
  
  static double get iconSmall => 16.sp;
  static double get iconMedium => 20.sp;
  static double get iconLarge => 24.sp;
  static double get iconExtraLarge => 28.sp;
  static double get eyeIconSize => 18.sp;
  static double get eyeIconContainer => 25.w;

  // ═══════════════════════════════════════════════════════════════
  // 🔘 BOTÕES
  // ═══════════════════════════════════════════════════════════════
  
  static double get buttonHeight => 48.h;
  static double get buttonRadius => 12.r;
  static double get buttonPaddingHorizontal => 24.w;
  static double get buttonPaddingVertical => 12.h;

  // ═══════════════════════════════════════════════════════════════
  // 📦 CARDS
  // ═══════════════════════════════════════════════════════════════
  
  static double get cardRadius => 12.r;
  static double get cardPadding => 12.w;
  static double get cardElevation => 2;

  // ═══════════════════════════════════════════════════════════════
  // 🔲 SPACING - ESCALÁVEL
  // ═══════════════════════════════════════════════════════════════
  
  static double get spacingTiny => 4.h;
  static double get spacingSmall => 8.h;
  static double get spacingMedium => 12.h;
  static double get spacingLarge => 16.h;
  static double get spacingExtraLarge => 24.h;
  static double get spacingHuge => 32.h;

  // ═══════════════════════════════════════════════════════════════
  // 📐 LAYOUT
  // ═══════════════════════════════════════════════════════════════
  
  static double get screenPadding => 16.w;
  static double get modalRadius => 20.r;

  // ═══════════════════════════════════════════════════════════════
  // 🎯 BOTTOM NAV (FOOTER DO APP) - SUPER COMPACTO!
  // ═══════════════════════════════════════════════════════════════
  
  /// Altura do bottom nav (BEM COMPACTO para liberar espaço!)
  static double get bottomNavHeight => 50.h;
  
  static double get bottomNavRadius => 25.r;
  static double get bottomNavPaddingHorizontal => 16.w;
  
  /// Espaço acima do bottom nav (mínimo)
  static double get bottomNavPaddingTop => 2.h;
  
  /// Espaço abaixo do bottom nav (mínimo)
  static double get bottomNavPaddingBottom => 4.h;
  
  /// Tamanho dos ícones do bottom nav (compacto)
  static double get bottomNavIconSize => 22.sp;
  
  /// Tamanho do texto do bottom nav (compacto)
  static double get bottomNavTextSize => 8.sp;

  // ═══════════════════════════════════════════════════════════════
  // 📸 SCANNER - RESPONSIVO
  // ═══════════════════════════════════════════════════════════════
  
  static double get scannerCardHeight => 175.h;
  static double get scannerRadius => 12.r;
  static double get scannerHorizontalPadding => 0.w;

  // ═══════════════════════════════════════════════════════════════
  // 📄 CONTEÚDO
  // ═══════════════════════════════════════════════════════════════
  
  static double get contentBottomPadding => 75.h;

  // ═══════════════════════════════════════════════════════════════
  // 📋 FOOTER - TAMANHOS MAIORES (VISÍVEL!)
  // ═══════════════════════════════════════════════════════════════
  
  /// Padding vertical do footer (altura total)
  static double get footerPaddingVertical => 8.h;
  
  /// Tamanho da label "Total"
  static double get footerLabelSize => 8.sp;
  
  /// Tamanho do valor "R$ 46,00"
  static double get footerValueSize => 15.sp;
  
  /// Padding horizontal do botão "Limpar"
  static double get footerButtonPaddingH => 12.w;
  
  /// Padding vertical do botão "Limpar"
  static double get footerButtonPaddingV => 6.h;
  
  /// Tamanho do ícone do botão "Limpar"
  static double get footerButtonIconSize => 16.sp;
  
  /// Tamanho do texto do botão "Limpar"
  static double get footerButtonTextSize => 11.sp;

  // ═══════════════════════════════════════════════════════════════
  // 🛒 LISTA - ITENS BEM COMPACTOS (3 ITENS COMPLETOS!)
  // ═══════════════════════════════════════════════════════════════
  
  static double get categoryPillHeight => 32.h;
  
  /// Altura de cada item da lista (BEM COMPACTA para caber 3 itens)
  static double get itemTileHeight => 56.h;
  
  static double get progressBarHeight => 4.h;
  // ═══════════════════════════════════════════════════════════════
// 🏢 LOGO DA EMPRESA - ADICIONE ESTA SEÇÃO NO app_sizes.dart
// ═══════════════════════════════════════════════════════════════
// 
// Adicione estas linhas logo após a seção de eyeIconContainer:

  // ═══════════════════════════════════════════════════════════════
  // 🏢 LOGO DA EMPRESA
  // ═══════════════════════════════════════════════════════════════
  
  /// Tamanho do container do logo (controla o tamanho total do logo)
  /// AJUSTE ESTE VALOR PARA DEIXAR O LOGO MAIOR OU MENOR:
  /// - 25.w = pequeno
  /// - 30.w = médio
  /// - 35.w = grande (recomendado) ✅
  /// - 40.w = extra grande
  /// - 45.w = muito grande
  static double get logoIconContainer => 35.w;
  
  /// Tamanho do ícone de fallback do logo
  static double get logoIconSize => 20.sp;
}

// ═══════════════════════════════════════════════════════════════
// 📊 VANTAGENS DESTE CÓDIGO SÊNIOR:
// ═══════════════════════════════════════════════════════════════
//
// ✅ ESCALÁVEL: .h, .w, .sp, .r adaptam para qualquer tela
// ✅ RESPONSIVO: iPhone SE, iPhone 15 Pro Max, iPad, Android
// ✅ MANUTENÍVEL: Mude headerHeight e funciona em TUDO
// ✅ PERFORMÁTICO: getters são lazy (calculam quando usa)
// ✅ TYPE-SAFE: Dart analisa erros em compile-time
// ✅ DRY: Um único lugar para TODOS os tamanhos
//
// ═══════════════════════════════════════════════════════════════
//
// 🔧 COMO AJUSTAR A POSIÇÃO DO SCANNER:
//
// No começo do arquivo, mude:
//   static double get headerHeight => 100.h;
//
// Valores recomendados:
//   85.h  = scanner um pouco mais alto
//   100.h = scanner médio (atual)
//   110.h = scanner original
//   120.h = scanner mais baixo
//
// ═══════════════════════════════════════════════════════════════
