import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

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

  /// 🍎 iOS - EXATAMENTE como estava (BackdropFilter + Gradiente)
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
          currentIndex: currentIndex,
          onTap: (i) => _onItemTapped(context, i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: AppSizes.bottomNavTextSize,
          unselectedFontSize: AppSizes.bottomNavTextSize,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.whiteWithOpacity(0.7),
          iconSize: AppSizes.bottomNavIconSize,
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
    );
  }

  /// 🤖 ANDROID - Cor sólida + ícones Material maiores
  Widget _buildAndroidNav(BuildContext context) {
    return Container(
      height: 60,
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
        currentIndex: currentIndex,
        onTap: (i) => _onItemTapped(context, i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        iconSize: 26,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_rounded),
            label: 'Encartes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Controle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Config.',
          ),
        ],
      ),
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