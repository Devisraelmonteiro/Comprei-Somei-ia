// lib/shared/widgets/top_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

/// 🔝 TopBar - Header do App VERDADEIRAMENTE RESPONSIVO
/// 
/// Sistema dinâmico que:
/// - Adapta ao SafeArea automaticamente
/// - Calcula altura baseada no conteúdo
/// - Funciona em qualquer dispositivo
/// 
/// Widget reutilizável que exibe:
/// - Avatar do usuário
/// - Saudação personalizada
/// - Saldo disponível
/// - Toggle para mostrar/ocultar saldo
class TopBarWidget extends StatefulWidget {
  final String userName;
  final double remaining;
  final String? userImagePath;

  const TopBarWidget({
    super.key,
    required this.userName,
    required this.remaining,
    this.userImagePath,
  });

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    // 🎯 CÁLCULO DINÂMICO do SafeArea top
    final topSafeArea = MediaQuery.of(context).padding.top;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.headerBorderRadius.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.headerPaddingHorizontal.w,
            AppSizes.headerPaddingTop.h,
            AppSizes.headerPaddingHorizontal.w,
            AppSizes.headerPaddingBottom.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ← Altura baseada no conteúdo
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔝 LINHA 1: Avatar + "Olá, Israel"
              Row(
                children: [
                  // 👤 AVATAR
                  _buildAvatar(),
                  
                  SizedBox(width: AppSizes.headerAvatarToGreetingSpacing.w),
                  
                  // 👋 SAUDAÇÃO
                  Text(
                    AppStrings.greeting(widget.userName),
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: AppSizes.greetingText.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppSizes.headerGreetingToSaldoSpacing.h),
              
              // 🔝 LINHA 2: "Saldo"
              Text(
                AppStrings.balanceLabel,
                style: TextStyle(
                  color: AppColors.whiteWithOpacity(0.9),
                  fontSize: AppSizes.balanceLabel.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: AppSizes.headerSaldoToValueSpacing.h),
              
              // 🔝 LINHA 3: "R$ 454,00" + Olhinho
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 💵 VALOR
                  _buildBalanceValue(),
                  
                  // 👁️ OLHINHO
                  _buildEyeToggle(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================
  // 🎨 WIDGETS AUXILIARES
  // ===========================

  /// 👤 Avatar clicável que abre o drawer
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Container(
        width: AppSizes.avatarSize.w,
        height: AppSizes.avatarSize.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteWithOpacity(0.2),
          border: Border.all(
            color: AppColors.whiteWithOpacity(0.3),
            width: AppSizes.avatarBorderWidth,
          ),
          image: widget.userImagePath != null
              ? DecorationImage(
                  image: AssetImage(widget.userImagePath!),
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackWithOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: widget.userImagePath == null
            ? Icon(
                Icons.person,
                color: AppColors.white,
                size: AppSizes.avatarSize.w * 0.6,
              )
            : null,
      ),
    );
  }

  /// 💵 Valor do saldo com animação
  Widget _buildBalanceValue() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        showBalance
            ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
            : "R\$ ••••••",
        key: ValueKey(showBalance),
        style: TextStyle(
          fontSize: AppSizes.balanceValue.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
        ),
      ),
    );
  }

  /// 👁️ Botão para mostrar/ocultar saldo
  Widget _buildEyeToggle() {
    return GestureDetector(
      onTap: () => setState(() => showBalance = !showBalance),
      child: Container(
        width: AppSizes.eyeIconContainer.w,
        height: AppSizes.eyeIconContainer.h,
        decoration: BoxDecoration(
          color: AppColors.whiteWithOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          showBalance 
              ? Icons.visibility_outlined 
              : Icons.visibility_off_outlined,
          color: AppColors.white,
          size: AppSizes.eyeIconSize.sp,
        ),
      ),
    );
  }
}