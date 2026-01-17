// lib/shared/widgets/top_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

/// 🔝 TopBar - Header COMPACTO com textos COLADOS
/// 
/// Layout:
/// ┌─────────────────────────┐
/// │ 👤  Olá, Israel    👁️   │
/// │     Saldo               │
/// │     R$ 500,00           │
/// └─────────────────────────┘
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 AVATAR
              _buildAvatar(),
              
              SizedBox(width: AppSizes.headerAvatarToGreetingSpacing.w),
              
              // 📝 TEXTOS (COLADOS)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ROW: "Olá, Israel" + Olhinho
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 👋 "Olá, Israel"
                        Text(
                          AppStrings.greeting(widget.userName),
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: AppSizes.greetingText.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        // 👁️ Olhinho (agora alinhado à direita da primeira linha)
                        _buildEyeToggle(),
                      ],
                    ),
                    
                    // ⚠️ SEM ESPAÇO entre "Olá" e "Saldo"
                    SizedBox(height: AppSizes.headerGreetingToSaldoSpacing.h),
                    
                    // 💼 "Saldo"
                    Text(
                      AppStrings.balanceLabel,
                      style: TextStyle(
                        color: const Color.fromARGB(183, 255, 255, 255),
                        fontSize: AppSizes.balanceLabel.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    // ⚠️ SEM ESPAÇO entre "Saldo" e valor
                    SizedBox(height: AppSizes.headerSaldoToValueSpacing.h),
                    
                    // 💵 "R$ 500,00"
                    _buildBalanceValue(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 👤 Avatar
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
        ),
        child: widget.userImagePath == null
            ? Icon(
                Icons.person,
                color: AppColors.white,
                size: 30.sp,
              )
            : null,
      ),
    );
  }

  /// 💵 Valor do saldo
  Widget _buildBalanceValue() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        showBalance
            ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
            : "R\$ ••••••",
        key: ValueKey(showBalance),
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: AppSizes.balanceValue.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  /// 👁️ Botão toggle
  Widget _buildEyeToggle() {
    return GestureDetector(
      onTap: () => setState(() => showBalance = !showBalance),
      child: Container(
        width: AppSizes.eyeIconContainer.w,
        height: AppSizes.eyeIconContainer.w,
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

// ═══════════════════════════════════════════════════════════════
// 📋 ESTRUTURA DO HEADER
// ═══════════════════════════════════════════════════════════════
//
// Row (horizontal):
//   - Avatar (40x40)
//   - Spacing (12px)
//   - Column (vertical) - TEXTOS COLADOS:
//       - Row: "Olá, Israel" + Olhinho
//       - Spacing = 0 ← SEM ESPAÇO
//       - "Saldo"
//       - Spacing = 0 ← SEM ESPAÇO
//       - "R$ 500,00"
//
// ═══════════════════════════════════════════════════════════════
//
// 🎯 VALORES DE AppSizes USADOS:
//
// headerPaddingTop = 0           (avatar colado no topo)
// headerPaddingBottom = 100      (espaço para scanner)
// headerPaddingHorizontal = 16
// headerAvatarToGreetingSpacing = 12
// headerGreetingToSaldoSpacing = 0    ← TEXTOS COLADOS
// headerSaldoToValueSpacing = 0       ← TEXTOS COLADOS
//
// avatarSize = 40
// greetingText = 12
// balanceLabel = 10
// balanceValue = 15
// eyeIconSize = 18
// eyeIconContainer = 25
//
// ═══════════════════════════════════════════════════════════════