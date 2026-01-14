// lib/shared/constants/app_colors.dart

import 'package:flutter/material.dart';

/// 🎨 CORES PADRÃO DO APP
/// 
/// Centraliza toda a paleta de cores para garantir
/// consistência visual e facilitar temas (dark mode).
/// 
/// USO:
/// - color: AppColors.primary
/// - backgroundColor: AppColors.background
class AppColors {
  // === PRIVADO (impede instanciação) ===
  AppColors._();

  // ===========================
  // 🔶 CORES PRINCIPAIS
  // ===========================
  static const Color primary = Color(0xFFF68A07); // Laranja principal
  static const Color primaryDark = Color(0xFFE45C00); // Laranja escuro
  static const Color primaryLight = Color(0xFFE8913F); // Laranja claro

  static const Color secondary = Color(0xFF0B6B53); // Verde
  static const Color accent = Color(0xFF2196F3); // Azul

  // ===========================
  // 🎨 GRADIENTES
  // ===========================
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFFCA5F01), Color(0xFFE8913F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bottomNavGradient = LinearGradient(
    colors: [Color(0xFFF68A07), Color(0xFFE45C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===========================
  // ⚪ CORES NEUTRAS
  // ===========================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ===========================
  // 🟢 CORES DE STATUS
  // ===========================
  static const Color success = Color(0xFF4CAF50); // Verde sucesso
  static const Color error = Color(0xFFF44336); // Vermelho erro
  static const Color warning = Color(0xFFFFA726); // Laranja aviso
  static const Color info = Color(0xFF2196F3); // Azul informação

  // ===========================
  // 🎨 CORES DO SCANNER
  // ===========================
  static const Color scannerBackground = Color(0xFF000000);
  static const Color scannerOverlay = Color(0x80000000); // Semi-transparente
  static const Color capturedPrice = Color(0xFFF36607); // Laranja captura

  // ===========================
  // 🛒 CORES DAS CATEGORIAS
  // ===========================
  static const Color categoryAlimentos = Color(0xFF4CAF50);
  static const Color categoryLimpeza = Color(0xFF2196F3);
  static const Color categoryHigiene = Color(0xFFE91E63);
  static const Color categoryBebidas = Color(0xFFFF9800);
  static const Color categoryFrios = Color(0xFF9C27B0);
  static const Color categoryHortifruti = Color(0xFF8BC34A);

  // ===========================
  // 📱 CORES DA UI
  // ===========================
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFE0E0E0);

  // ===========================
  // 📝 CORES DE TEXTO
  // ===========================
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ===========================
  // 🔘 CORES DE BOTÕES
  // ===========================
  static const Color buttonPrimary = Color(0xFFF68A07);
  static const Color buttonSecondary = Color(0xFF2196F3);
  static const Color buttonSuccess = Color(0xFF4CAF50);
  static const Color buttonDanger = Color(0xFFF44336);

  // ===========================
  // 🌓 CORES COM OPACIDADE
  // ===========================
  static Color whiteWithOpacity(double opacity) => 
      Color.fromRGBO(255, 255, 255, opacity);
  
  static Color blackWithOpacity(double opacity) => 
      Color.fromRGBO(0, 0, 0, opacity);
  
  static Color primaryWithOpacity(double opacity) => 
      primary.withOpacity(opacity);
}