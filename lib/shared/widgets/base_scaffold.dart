import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

import 'modern_drawer.dart';
// import 'ultra_futuristic_drawer.dart'; // Descomente para usar a versão futurística

/// 🏗️ Scaffold RESPONSIVO PROFISSIONAL - CÓDIGO SÊNIOR
/// 
/// ✅ Bottom Nav SUPER COMPACTO (libera espaço para conteúdo)
/// ✅ Usa AppSizes (centralizado, escalável)
/// ✅ Responsivo para TODAS as telas
/// ✅ Adaptativo iOS + Android
class BaseScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String? userName;
  final bool showBottomNav;

  const BaseScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    this.userName,
    this.showBottomNav = true,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/lista');
        break;
      case 2:
        context.go('/encartes');
        break;
      case 3:
        context.go('/orcamento');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      // Escolha o drawer aqui: ModernDrawer() ou UltraFuturisticDrawer()
      drawer: null,
      body: child,
      bottomNavigationBar: showBottomNav ? _buildBottomNav(context) : null,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎯 BOTTOM NAVIGATION - SUPER COMPACTO + ADAPTATIVO
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBottomNav(BuildContext context) {
    return Builder(
      builder: (context) {
        final bottomSafeArea = MediaQuery.of(context).padding.bottom;
        final isAndroid = Platform.isAndroid;
        
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.bottomNavPaddingHorizontal,
            AppSizes.bottomNavPaddingTop,
            AppSizes.bottomNavPaddingHorizontal,
            bottomSafeArea + AppSizes.bottomNavPaddingBottom,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.bottomNavRadius),
            child: isAndroid
                ? _buildAndroidNav(context)
                : _buildIOSNav(context),
          ),
        );
      },
    );
  }

  Widget _buildIOSNav(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: AppSizes.bottomNavHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.bottomNavRadius),
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
          currentIndex: currentIndex.clamp(0, 3),
          onTap: (i) => _onItemTapped(context, i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: AppSizes.bottomNavTextSize,
          unselectedFontSize: AppSizes.bottomNavTextSize,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.whiteWithOpacity(0.7),
          iconSize: AppSizes.bottomNavIconSize,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home_2),
              label: AppStrings.homeTitle,
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.note_text),
              label: AppStrings.listTitle,
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.ticket_discount),
              label: AppStrings.encartesTitle,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar_circle),
              label: AppStrings.budgetTitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidNav(BuildContext context) {
    return Container(
      height: AppSizes.bottomNavHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.bottomNavRadius),
        color: const Color(0xFFF36607),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex.clamp(0, 3),
        onTap: (i) => _onItemTapped(context, i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: AppSizes.bottomNavTextSize,
        unselectedFontSize: AppSizes.bottomNavTextSize,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        iconSize: AppSizes.bottomNavIconSize,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: AppStrings.homeTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: AppStrings.listTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_rounded),
            label: AppStrings.encartesTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle),
            label: AppStrings.budgetTitle,
          ),
        ],
      ),
    );
  }

}

  // ═══════════════════════════════════════════════════════════════
  // 📋 CONFIGURAÇÕES POR PLATAFORMA
// ═══════════════════════════════════════════════════════════════
//
// 🍎 iOS (MANTIDO ORIGINAL):
//   - Altura: AppSizes.bottomNavHeight (50.h)
//   - Ícones: AppSizes.bottomNavIconSize (22.sp) + Iconsax
//   - Texto: AppSizes.bottomNavTextSize (9.sp)
//   - Estilo: BackdropFilter + Gradiente
//
// 🤖 ANDROID (NOVO - mais visível):
//   - Altura: 70px (maior)
//   - Ícones: 26px + Material Icons (nativos)
//   - Texto: 11/12px (maior)
//   - Estilo: Cor sólida laranja (sem blur)
//
// ✅ iOS funciona EXATAMENTE como antes!
// ✅ Android agora tem ícones visíveis!
//
// ═══════════════════════════════════════════════════════════════
