import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

/// 🏗️ Scaffold base com bottom navigation responsivo
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

      // 🎯 Bottom Nav com sistema responsivo profissional
      bottomNavigationBar: Builder(
        builder: (context) {
          // 📊 Pega o SafeArea do dispositivo (adapta automaticamente)
          final bottomSafeArea = MediaQuery.of(context).padding.bottom;
          
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.bottomNavPaddingHorizontal.w,
              AppSizes.bottomNavPaddingTop.h,
              AppSizes.bottomNavPaddingHorizontal.w,
              // 🔥 FÓRMULA: SafeArea (auto) + valor configurável
              bottomSafeArea + AppSizes.bottomNavPaddingBottom.h,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.bottomNavRadius.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
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

                    selectedFontSize: AppSizes.bodySmall.sp,
                    unselectedFontSize: AppSizes.bodySmall.sp,

                    selectedItemColor: AppColors.white,
                    unselectedItemColor: AppColors.whiteWithOpacity(0.7),

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
      ),
    );
  }

  // ================= DRAWER =================

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    userName ?? "Usuário",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Versão 1.0.0",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(context, Icons.home, "Home", '/home'),
                  _buildMenuItem(context, Icons.receipt_long, "Minhas Listas", '/lista'),
                  _buildMenuItem(context, Icons.local_offer, "Encartes", '/encartes'),
                  _buildMenuItem(context, Icons.account_balance_wallet, "Controle de Gastos", '/orcamento'),
                  const Divider(height: 24),
                  _buildMenuItem(context, Icons.settings, "Configurações", '/settings'),
                  _buildMenuItem(context, Icons.help_outline, "Ajuda", null),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "CompreiSomei v1.0.0",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
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
      leading: Icon(icon, color: AppColors.primary, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (route != null) context.go(route);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    );
  }
}