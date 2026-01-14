import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/widgets/button_comprei_somei.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

class FavoritosGrid extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onMultiply;
  final VoidCallback onManual;

  const FavoritosGrid({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.onMultiply,
    required this.onManual,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODOS OS BOTÕES EM 1 LINHA (lado a lado)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ CONFIRMAR
              Expanded(
                child: ButtonCompreiSomei(
                  label: AppStrings.btnConfirm,
                  icon: Icons.check_circle_outline,
                  onTap: onConfirm,
                ),
              ),
              
              SizedBox(width: AppSizes.spacingSmall.w),
              
              // ❌ CANCELAR
              Expanded(
                child: ButtonCompreiSomei(
                  label: AppStrings.btnCancel,
                  icon: Icons.cancel_outlined,
                  onTap: onCancel,
                ),
              ),
              
              SizedBox(width: AppSizes.spacingSmall.w),
              
              // 🔄 MULTIPLICAR
              Expanded(
                child: ButtonCompreiSomei(
                  label: AppStrings.btnMultiply,
                  icon: Icons.cached,
                  onTap: onMultiply,
                ),
              ),
              
              SizedBox(width: AppSizes.spacingSmall.w),
              
              // ✏️ MANUAL
              Expanded(
                child: ButtonCompreiSomei(
                  label: AppStrings.btnManual,
                  icon: Icons.create_outlined,
                  onTap: onManual,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}