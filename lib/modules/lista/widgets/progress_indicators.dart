import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

/// 📊 Indicadores de Progresso COMPACTOS
/// Categoria + Progresso na MESMA barra
class ProgressIndicators extends StatelessWidget {
  const ProgressIndicators({super.key});

  // 🎨 CONFIGURAÇÕES EDITÁVEIS
  static const double _paddingHorizontal = 16.0;
  static const double _paddingTop = 0;
  static const double _paddingBottom = 0;

  static const double _barHeight = 18.0;
  static const double _barRadius = 14.0;
  static const double _barBottomSpacing = 8.0;

  static const double _labelFontSize = 12.5;
  static const double _percentageFontSize = 12.5;

  static const int _maxCategoriesToShow = 6;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final categoriesWithItems = ShoppingListController.categories
            .where((cat) => controller.itemsInCategory(cat) > 0)
            .take(_maxCategoriesToShow)
            .toList();

        if (categoriesWithItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            _paddingHorizontal,
            _paddingTop,
            _paddingHorizontal,
            _paddingBottom,
          ),
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

/// 🔹 Barra única: Categoria + Progresso
class _ProgressBar extends StatelessWidget {
  final String category;

  const _ProgressBar({required this.category});

  Color _getCategoryColor() {
    switch (category) {
      case 'Alimentos':
        return const Color(0xFFF68A07);
      case 'Limpeza':
        return const Color(0xFF5DBFB3);
      case 'Higiene':
        return const Color(0xFFE8C547);
      case 'Bebidas':
        return const Color(0xFF6BA5D6);
      case 'Frios':
        return const Color(0xFFB38DD6);
      case 'Hortifruti':
        return const Color(0xFF7BC96F);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final percentage = controller.completionPercentage(category);
        final color = _getCategoryColor();

        return Padding(
          padding: const EdgeInsets.only(
            bottom: ProgressIndicators._barBottomSpacing,
          ),
          child: Stack(
            children: [
              // Fundo
              Container(
                height: ProgressIndicators._barHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(
                    ProgressIndicators._barRadius,
                  ),
                ),
              ),

              // Progresso
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: ProgressIndicators._barHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(
                      ProgressIndicators._barRadius,
                    ),
                  ),
                ),
              ),

              // Texto SOBRE a barra
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nome da categoria
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: ProgressIndicators._labelFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      // Percentual
                      Text(
                        '${percentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: ProgressIndicators._percentageFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
}
