import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';
import 'add_item_dialog.dart';

/// 📱 Header da Lista de Compras - VERSÃO PROFISSIONAL 2025
class ShoppingHeader extends StatelessWidget {
  const ShoppingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Column(
        children: [
          // ✅ LOGO + TEXTO CENTRALIZADOS + BOTÃO FECHAR
          _buildTopBar(context),
          
          // ✅ CARD COM CATEGORIAS
          _buildCategoriesCard(context),
          
          SizedBox(height: AppSizes.spacingMedium.h),
          
          // ✅ BOTÃO ADICIONAR PRODUTO
          _buildAddButton(context),
          
          SizedBox(height: AppSizes.spacingLarge.h),
        ],
      ),
    );
  }

  /// 🔝 Barra superior com logo e botão fechar
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium.w,
        vertical: AppSizes.spacingSmall.h,
      ),
      child: Stack(
        children: [
          // Logo + Texto centralizados
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.primary,
                    size: AppSizes.iconMedium.sp,
                  ),
                ),
                
                SizedBox(width: AppSizes.spacingSmall.w),
                
                // Texto "CompreiSomm"
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Comprei',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppSizes.titleLarge.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Somm',
                        style: TextStyle(
                          color: const Color(0xFFFFD700),
                          fontSize: AppSizes.titleLarge.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Botão X à direita
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteWithOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: AppSizes.iconMedium.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📦 Card com título e categorias
  Widget _buildCategoriesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding.w),
      padding: EdgeInsets.all(AppSizes.screenPadding.w),
      decoration: BoxDecoration(
        color: const Color(0xFF3D5A6F),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius.r),
      ),
      child: Column(
        children: [
          Text(
            'Sua Lista de Compras',
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.titleLarge.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: AppSizes.spacingSmall.h),
          
          Text(
            'Adicione os produtos que deseja lembrar',
            style: TextStyle(
              color: AppColors.whiteWithOpacity(0.85),
              fontSize: AppSizes.bodySmall.sp,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: AppSizes.spacingLarge.h),
          
          // Pills de categorias
          Consumer<ShoppingListController>(
            builder: (context, controller, _) {
              return Wrap(
                spacing: AppSizes.spacingSmall.w,
                runSpacing: AppSizes.spacingSmall.h,
                alignment: WrapAlignment.center,
                children: ShoppingListController.categories.map((category) {
                  final isSelected = controller.selectedCategory == category;
                  return _buildCategoryPill(
                    category: category,
                    isSelected: isSelected,
                    onTap: () => controller.selectCategory(category),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🏷️ Pill de categoria
  Widget _buildCategoryPill({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: _getCategoryColor(category),
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected
              ? Border.all(color: AppColors.white, width: 2)
              : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppSizes.bodySmall.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// ➕ Botão adicionar produto
  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium.w),
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AddItemDialog(),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: AppSizes.spacingMedium.h),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackWithOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Adicionar Produto',
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSizes.bodyLarge.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 Cores das categorias
  Color _getCategoryColor(String category) {
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