import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';
import 'shopping_item_tile.dart';

/// 📝 Lista de Itens de Compras - VERSÃO PROFISSIONAL 2025
/// 
/// ListView com itens filtrados por categoria.
/// Mostra estado vazio quando não há itens.
class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final items = controller.filteredItems;

        // Estado de loading
        if (controller.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        // Estado vazio
        if (items.isEmpty) {
          return _buildEmptyState(controller.selectedCategory);
        }

        // Lista de itens
        return ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding.w,
            vertical: 4.h,
          ),
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.grey[200],
            indent: 16.w,
            endIndent: 16.w,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return ShoppingItemTile(
              key: ValueKey(item.id),
              item: item,
            );
          },
        );
      },
    );
  }

  /// 🔍 Estado vazio
  Widget _buildEmptyState(String category) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacingHuge.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone
            Icon(
              Icons.format_list_bulleted,
              size: 64.sp,
              color: AppColors.grey300,
            ),
            
            SizedBox(height: AppSizes.spacingLarge.h),
            
            // Título
            Text(
              'Nenhum item em $category',
              style: TextStyle(
                fontSize: AppSizes.bodyMedium.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            
            SizedBox(height: AppSizes.spacingSmall.h),
            
            // Subtítulo
            Text(
              AppStrings.listEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.bodySmall.sp,
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
