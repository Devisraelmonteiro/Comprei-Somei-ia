import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

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
        // Se tem categoria selecionada, mostra só ela (se tiver itens)
        // Se não, mostra todas que tem itens
        final categoriesToShow = ShoppingListController.categories
            .where((cat) => controller.itemsInCategory(cat) > 0)
            .toList();

        if (categoriesToShow.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 50.h, // Altura fixa e compacta
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: categoriesToShow.length,
            itemBuilder: (context, index) {
              final category = categoriesToShow[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: _CompactProgressBar(category: category),
              );
            },
          ),
        );
      },
    );
  }
}

/// 🔹 Barra de progresso compacta (Card Horizontal)
class _CompactProgressBar extends StatelessWidget {
  final String category;

  const _CompactProgressBar({required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final percentage = controller.completionPercentage(category);
        
        return Container(
          width: 140.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            //border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${percentage.toInt()}%',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: _getProgressColor(percentage, category),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: percentage > 0 ? percentage / 100 : 0,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(percentage, category)),
                  minHeight: 4.h,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Lista de Alimentos':
        return const Color(0xFFD9722E); // Laranja queimado
      case 'Lista de Limpeza':
        return const Color(0xFF5D9B9B); // Verde água (Teal)
      case 'Lista de Higiene':
        return const Color(0xFFEBC866); // Amarelo mostarda
      case 'Lista de Bebidas':
        return const Color(0xFF4A90E2); // Azul Bebidas
      case 'Lista de Frios':
        return const Color(0xFF7BADD1); // Azul Frios/Gelo
      case 'Lista de Hortifruti':
        return const Color(0xFF6DA34D); // Verde Hortifruti
      default:
        return const Color(0xFF999999);
    }
  }

  Color _getProgressColor(double percentage, String category) {
    return _getCategoryColor(category);
  }
}