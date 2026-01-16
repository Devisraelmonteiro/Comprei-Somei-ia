import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

/// 🏗️ Scaffold RESPONSIVO PROFISSIONAL
/// 
/// ✅ Bottom Nav adaptável a TODOS os dispositivos
/// ✅ Usa SafeArea automático (iPhone com notch, Android)
/// ✅ ScreenUtil para responsividade (.w, .h, .sp)
/// ✅ Drawer completo
/// 
/// 📝 COMO AJUSTAR O BOTTOM NAV:
/// 
/// 🎯 ALTURA DO BOTTOM NAV:
/// - Linha 109: height (altura da barra)
///   • Aumentar = barra mais alta
///   • Diminuir = barra mais baixa
///   • RECOMENDADO: 60-70.h
/// 
/// 🎯 ESPAÇAMENTO DO CHÃO:
/// - Linha 93: bottomSafeArea + valor
///   • bottomSafeArea = auto (notch do iPhone, botões Android)
///   • Valor adicional = espaço extra
///   • RECOMENDADO: 8-12.h
/// 
/// 🎯 TAMANHO DOS ÍCONES:
/// - Linha 127: iconSize
///   • Aumentar = ícones maiores
///   • Diminuir = ícones menores
///   • RECOMENDADO: 24-28.sp
/// 
/// 🎯 TAMANHO DO TEXTO:
/// - Linhas 123-124: fontSize
///   • Aumentar = texto maior
///   • Diminuir = texto menor
///   • RECOMENDADO: 10-12.sp
class BaseScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String? userName;

  const BaseScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    this.userName,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    final routes = ['/home', '/lista', '/encartes', '/orcamento', '/settings'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      drawer: userName != null ? _buildDrawer(context) : null,
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎯 BOTTOM NAVIGATION - 100% RESPONSIVO
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBottomNav(BuildContext context) {
    return Builder(
      builder: (context) {
        // 📊 PEGA O SAFEAREA DO DISPOSITIVO (automático)
        // 
        // bottomSafeArea adapta para:
        // - iPhone com notch (parte inferior)
        // - iPhone sem notch
        // - Android com botões virtuais
        // - Android com gestos
        // 
        // ⚠️ NUNCA remova isso! É essencial para responsividade.
        final bottomSafeArea = MediaQuery.of(context).padding.bottom;
        
        return Padding(
          padding: EdgeInsets.fromLTRB(
            // 📏 MARGENS LATERAIS ← AJUSTE AQUI (linha 87)!
            // 
            // Aumentar = bottom nav mais estreito
            // Diminuir = bottom nav mais largo
            // 
            // VALORES SUGERIDOS:
            // - 12.w = quase full width
            // - 16.w = médio (recomendado)
            // - 20.w = mais estreito
            AppSizes.bottomNavPaddingHorizontal.w,
            
            // 📏 ESPAÇO ACIMA DO BOTTOM NAV ← AJUSTE AQUI (linha 89)!
            // 
            // Aumentar = mais espaço entre conteúdo e bottom nav
            // Diminuir = menos espaço
            // 
            // VALORES SUGERIDOS:
            // - 6.h  = bem próximo do conteúdo
            // - 8.h  = próximo (recomendado)
            // - 10.h = médio
            AppSizes.bottomNavPaddingTop.h,
            
            AppSizes.bottomNavPaddingHorizontal.w,
            
            // 📏 ESPAÇO EMBAIXO DO BOTTOM NAV ← AJUSTE AQUI (linha 93)!
            // 
            // 🔥 FÓRMULA: SafeArea (auto) + valor adicional
            // 
            // SafeArea = adapta automaticamente para cada dispositivo
            // Valor adicional = espaço extra que você quer
            // 
            // VALORES SUGERIDOS para o adicional:
            // - 8.h  = bem próximo do chão
            // - 10.h = próximo (recomendado)
            // - 12.h = médio
            // - 14.h = mais afastado
            // 
            // EXEMPLOS DE RESULTADO FINAL:
            // - iPhone 15 Pro: SafeArea(34) + 10.h = ~44 pixels
            // - iPhone SE: SafeArea(0) + 10.h = ~10 pixels
            // - Android: SafeArea(16) + 10.h = ~26 pixels
            bottomSafeArea + AppSizes.bottomNavPaddingBottom.h,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.bottomNavRadius.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                // 📐 ALTURA DO BOTTOM NAV ← AJUSTE AQUI (linha 109)!
                // 
                // Aumentar = barra mais alta (mais espaço)
                // Diminuir = barra mais baixa (compacta)
                // 
                // VALORES SUGERIDOS:
                // - 58.h = bem compacta
                // - 62.h = compacta
                // - 65.h = média (recomendado)
                // - 68.h = alta
                // - 72.h = bem alta
                height: AppSizes.bottomNavHeight.h,
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.bottomNavRadius.r),
                  gradient: AppColors.bottomNavGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackWithOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (i) => _onItemTapped(context, i),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  
                  // 📝 TAMANHO DO TEXTO ← AJUSTE AQUI (linhas 123-124)!
                  // 
                  // selectedFontSize = quando o item está selecionado
                  // unselectedFontSize = quando o item NÃO está selecionado
                  // 
                  // VALORES SUGERIDOS:
                  // - 9.sp  = muito pequeno
                  // - 10.sp = pequeno
                  // - 11.sp = médio (recomendado)
                  // - 12.sp = grande
                  selectedFontSize: AppSizes.bodySmall.sp,
                  unselectedFontSize: AppSizes.bodySmall.sp,
                  
                  selectedItemColor: AppColors.white,
                  unselectedItemColor: AppColors.whiteWithOpacity(0.7),
                  
                  // 📐 TAMANHO DOS ÍCONES ← AJUSTE AQUI (linha 127)!
                  // 
                  // Aumentar = ícones maiores
                  // Diminuir = ícones menores
                  // 
                  // VALORES SUGERIDOS:
                  // - 22.sp = pequenos
                  // - 24.sp = médios (recomendado)
                  // - 26.sp = grandes
                  // - 28.sp = bem grandes
                  iconSize: AppSizes.iconLarge.sp,
                  
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Iconsax.home_2),
                      label: AppStrings.homeTitle,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Iconsax.note_text),
                      label: AppStrings.listTitle,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Iconsax.ticket_discount),
                      label: AppStrings.encartesTitle,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Iconsax.wallet_3),
                      label: AppStrings.budgetTitle,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Iconsax.setting_2),
                      label: AppStrings.settingsTitle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 📂 DRAWER (MENU LATERAL)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            // 👤 CABEÇALHO DO DRAWER
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 42.sp,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  
                  // Nome do usuário
                  Text(
                    userName ?? "Usuário",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  
                  // Versão
                  Text(
                    "Versão 1.0.0",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // 📋 MENU ITEMS
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                children: [
                  _buildMenuItem(context, Icons.home, "Home", '/home'),
                  _buildMenuItem(context, Icons.receipt_long, "Minhas Listas", '/lista'),
                  _buildMenuItem(context, Icons.local_offer, "Encartes", '/encartes'),
                  _buildMenuItem(context, Icons.account_balance_wallet, "Controle de Gastos", '/orcamento'),
                  Divider(height: 24.h),
                  _buildMenuItem(context, Icons.settings, "Configurações", '/settings'),
                  _buildMenuItem(context, Icons.help_outline, "Ajuda", null),
                ],
              ),
            ),
            
            // 📄 RODAPÉ
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                "CompreiSomei v1.0.0",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String? route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 26.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (route != null) context.go(route);
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 GUIA RÁPIDO - AJUSTAR BOTTOM NAV
// ═══════════════════════════════════════════════════════════════
//
// 🎯 BOTTOM NAV MUITO ALTO (sobrando espaço em cima)?
// 
//   SOLUÇÃO: DIMINUA a linha 109 (height)
//     height: 65.h,  →  height: 60.h,
//
// ─────────────────────────────────────────────────────────────
//
// 🎯 BOTTOM NAV MUITO PERTO DO CHÃO?
// 
//   SOLUÇÃO: AUMENTE o valor adicional na linha 93
//     bottomSafeArea + 10.h,  →  bottomSafeArea + 12.h,
//
// ─────────────────────────────────────────────────────────────
//
// 🎯 BOTTOM NAV MUITO LONGE DO CHÃO?
// 
//   SOLUÇÃO: DIMINUA o valor adicional na linha 93
//     bottomSafeArea + 10.h,  →  bottomSafeArea + 8.h,
//
// ─────────────────────────────────────────────────────────────
//
// 🎯 ÍCONES MUITO PEQUENOS?
// 
//   SOLUÇÃO: AUMENTE a linha 127 (iconSize)
//     iconSize: 24.sp,  →  iconSize: 26.sp,
//
// ─────────────────────────────────────────────────────────────
//
// 🎯 TEXTO MUITO PEQUENO?
// 
//   SOLUÇÃO: AUMENTE as linhas 123-124 (fontSize)
//     fontSize: 11.sp,  →  fontSize: 12.sp,
//
// ─────────────────────────────────────────────────────────────
//
// 💡 VALORES RECOMENDADOS:
// 
//   Altura bottom nav: 65.h
//   Espaço do chão: bottomSafeArea + 10.h
//   Tamanho ícones: 24.sp
//   Tamanho texto: 11.sp
//
// ═══════════════════════════════════════════════════════════════
//
// 🔥 COMO FUNCIONA O SAFEAREA:
//
// O bottomSafeArea é CALCULADO AUTOMATICAMENTE para cada device:
//
// iPhone 15 Pro (com notch):
//   bottomSafeArea = 34 pixels
//   + 10.h adicional
//   = ~44 pixels total
//
// iPhone SE (sem notch):
//   bottomSafeArea = 0 pixels
//   + 10.h adicional
//   = ~10 pixels total
//
// Android (com botões virtuais):
//   bottomSafeArea = 16 pixels
//   + 10.h adicional
//   = ~26 pixels total
//
// ⚠️ NUNCA use valores fixos! Sempre use:
//   bottomSafeArea + valor.h
//
// ═══════════════════════════════════════════════════════════════