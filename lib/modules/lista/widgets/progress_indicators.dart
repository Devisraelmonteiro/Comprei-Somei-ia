import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

/// 📊 Indicadores de Progresso - VERSÃO CLEAN (Apple Style)
/// 
/// Visual:
/// - Minimalista e Fino
/// - Tipografia refinada
/// - 3 itens por vez na tela
class ProgressIndicators extends StatelessWidget {
  const ProgressIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final categoriesToShow = ShoppingListController.categories;

        return Container(
          height: 40.h, // Altura reduzida para ser mais fino (antes 46)
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r), // Borda mais suave
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03), // Sombra muito sutil
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey[100]!), // Borda sutil
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h), // Reduzido (antes 8)
            scrollDirection: Axis.horizontal,
            itemCount: categoriesToShow.length,
            separatorBuilder: (context, index) => Container(
              width: 1,
              height: 16.h, // Reduzido (antes 20)
              color: const Color.fromARGB(28, 238, 238, 238), // Divisor vertical muito leve
              margin: EdgeInsets.symmetric(horizontal: 12.w),
            ),
            itemBuilder: (context, index) {
              final category = categoriesToShow[index];
              // Largura calculada para mostrar exatamente 3 itens (ajustando padding e divisores)
              // Container Width = 1.sw - 40.w (margin)
              // Inner Width = Container Width - 32.w (padding)
              // Separator Width = 1 + 24.w (~25.w)
              // Visible Space = Inner Width - (2 * Separator Width)
              // Item Width = Visible Space / 3
              final innerWidth = 1.sw - 40.w - 32.w;
              final separatorWidth = 25.w;
              final itemWidth = (innerWidth - (2 * separatorWidth)) / 3;

              return Container(
                width: itemWidth,
                alignment: Alignment.center,
                child: _buildIndicatorItem(
                  context, 
                  category, 
                  _getCategoryColor(category),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    // Cores Apple-like (menos saturadas, mais elegantes)
    if (category.contains('Alimentos')) return const Color(0xFFFF9500); // System Orange
    if (category.contains('Limpeza')) return const Color(0xFF5AC8FA);   // System Teal/Blue
    if (category.contains('Higiene')) return const Color(0xFFFFCC00);   // System Yellow
    if (category.contains('Bebidas')) return const Color(0xFF007AFF);   // System Blue
    if (category.contains('Frios')) return const Color(0xFFAF52DE);     // System Purple
    if (category.contains('Hortifruti')) return const Color(0xFF34C759); // System Green
    return Colors.grey;
  }

  Widget _buildIndicatorItem(BuildContext context, String category, Color color) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final percentage = controller.completionPercentage(category);
        final hasProgress = percentage > 0;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.replaceAll('Lista de ', ''),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500, // Peso médio
                      color: Colors.grey[700], // Cinza escuro elegante
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '${percentage.toInt()}%',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: hasProgress ? color : Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h), // Espaçamento reduzido
            ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: LinearProgressIndicator(
                value: hasProgress ? percentage / 100 : 0,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6.5.h, // Barra bem fina
              ),
            ),
          ],
        );
      },
    );
  }
}
