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
        // Mostra todas as categorias para o usuário ver o progresso de tudo
        final categoriesToShow = ShoppingListController.categories;

        // Cálculo para caber exatamente 3 itens na tela
        // Tela - Padding Horizontal (32) - Espaço entre itens (2 * 12) = Espaço disponível
        // Dividido por 3 itens
        final itemWidth = (MediaQuery.of(context).size.width - 56.w) / 3;

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
                child: _CompactProgressBar(
                  category: category,
                  width: itemWidth,
                ),
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
  final double width;

  const _CompactProgressBar({
    required this.category,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final percentage = controller.completionPercentage(category);
        
        return Container(
          width: width,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
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
                    category.replaceFirst('Lista de ', ''), // Nome limpo
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
    if (category.contains('Alimentos')) return const Color(0xFFD9722E);
    if (category.contains('Limpeza')) return const Color(0xFF5D9B9B);
    if (category.contains('Higiene')) return const Color(0xFFEBC866);
    if (category.contains('Bebidas')) return const Color(0xFF4A90E2);
    if (category.contains('Frios')) return const Color(0xFF7BADD1);
    if (category.contains('Hortifruti')) return const Color(0xFF6DA34D);
    return const Color(0xFF999999);
  }

  Color _getProgressColor(double percentage, String category) {
    return _getCategoryColor(category);
  }
}