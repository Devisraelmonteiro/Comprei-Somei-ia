import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

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
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/lista'); break;
      case 2: context.go('/encartes'); break;
      case 3: context.go('/orcamento'); break;
      case 4: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,

      drawer: userName != null ? _buildDrawer(context) : null,

      body: child,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.spacingMedium.w,
            AppSizes.spacingSmall.h,
            AppSizes.spacingMedium.w,
            AppSizes.spacingSmall.h,
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
        ),
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
              padding: EdgeInsets.fromLTRB(
                AppSizes.screenPadding.w + 4.w,
                60.h,
                AppSizes.screenPadding.w + 4.w,
                30.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72.w,
                    height: 72.h,
                    decoration: BoxDecoration(
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
                  Text(
                    userName ?? "Usuário",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Bem-vindo!",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: AppColors.divider),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: AppSizes.spacingSmall.h),
                children: [
                  _buildMenuItem(context, Icons.home, AppStrings.homeTitle, '/home'),
                  _buildMenuItem(context, Icons.receipt_long, "Minhas Listas", '/lista'),
                  _buildMenuItem(context, Icons.local_offer, AppStrings.encartesTitle, '/encartes'),
                  _buildMenuItem(context, Icons.account_balance_wallet, "Controle de Gastos", '/orcamento'),
                  Divider(height: 24.h, color: AppColors.divider),
                  _buildMenuItem(context, Icons.settings, AppStrings.settingsTitle, '/settings'),
                  _buildMenuItem(context, Icons.help_outline, "Ajuda", null),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppSizes.screenPadding.w + 4.w),
              child: Text(
                AppStrings.appVersion,
                style: TextStyle(
                  fontSize: AppSizes.bodySmall.sp,
                  color: AppColors.textDisabled,
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
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: 26.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppSizes.bodyMedium.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (route != null) context.go(route);
      },
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.screenPadding.w + 4.w,
        vertical: 6.h,
      ),
    );
  }
}