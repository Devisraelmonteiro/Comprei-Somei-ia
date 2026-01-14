import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';

/// 📊 Indicadores de Progresso - VERSÃO PROFISSIONAL 2025
/// 
/// Mostra barras de progresso para cada categoria com itens.
/// Design compacto: categoria + progresso na mesma barra.
class ProgressIndicators extends StatelessWidget {
  const ProgressIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final categoriesWithItems = ShoppingListController.categories
            .where((cat) => controller.itemsInCategory(cat) > 0)
            .take(6) // Máximo 6 categorias
            .toList();

        if (categoriesWithItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding.w),
          child: Column(
            children: categoriesWithItems
                .map((category) => _ProgressBar(category: category))
                .toList(),
          ),
        );
      },
    );
  }
}

/// 🔹 Barra de progresso individual
class _ProgressBar extends StatelessWidget {
  final String category;

  const _ProgressBar({required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final percentage = controller.completionPercentage(category);
        final color = _getCategoryColor();

        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.spacingSmall.h),
          child: Stack(
            children: [
              // 🎨 Fundo cinza
              Container(
                height: AppSizes.progressBarHeight.h + 14.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),

              // 🎨 Barra de progresso colorida
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: AppSizes.progressBarHeight.h + 14.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),

              // 📝 Texto sobre a barra
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nome da categoria
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),

                      // Percentual
                      Text(
                        '${percentage.toInt()}%',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🎨 Cor da categoria
  Color _getCategoryColor() {
    switch (category) {
      case 'Alimentos':
        return AppColors.categoryAlimentos;
      case 'Limpeza':
        return AppColors.categoryLimpeza;
      case 'Higiene':
        return AppColors.categoryHigiene;
      case 'Bebidas':
        return AppColors.categoryBebidas;
      case 'Frios':
        return AppColors.categoryFrios;
      case 'Hortifruti':
        return AppColors.categoryHortifruti;
      default:
        return AppColors.grey500;
    }
  }
}