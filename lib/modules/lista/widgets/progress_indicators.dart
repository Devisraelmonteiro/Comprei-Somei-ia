import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

/// 📊 Indicadores de Progresso - TODAS MEDIDAS EDITÁVEIS
/// 
/// ✏️ EDITE AQUI EMBAIXO:
class ProgressIndicators extends StatelessWidget {
  const ProgressIndicators({super.key});

  // ═══════════════════════════════════════════════════════════
  // 🎨 CONFIGURAÇÕES EDITÁVEIS - MUDE AQUI!
  // ═══════════════════════════════════════════════════════════
  
   static const double _paddingHorizontal = 16.0;
  static const double _paddingTop = 16.0;
  static const double _paddingBottom = 8.0;
  
  static const double _titleFontSize = 15.0;
  static const double _titleBottomSpacing = 12.0;
  
  static const double _categoryTextFontSize = 13.0;
  static const double _categoryTextBottomSpacing = 8.0;
  
  static const double _progressBarHeight = 12.0;
  static const double _progressBarRadius = 10.0;
  static const double _progressBarRightSpacing = 12.0;
  
  static const double _percentageFontSize = 13.0;
  static const double _percentageWidth = 45.0;
  
  static const double _itemCountFontSize = 11.0;
  static const double _itemCountTopSpacing = 4.0;
  
  static const double _barBottomSpacing = .0; // Entre barras
  
  static const int _maxCategoriesToShow = 6; // ✅ Quantas categorias mostrar
  
 

  
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        // Pega categorias com itens
        final categoriesWithItems = ShoppingListController.categories
            .where((cat) => controller.itemsInCategory(cat) > 0)
            .take(_maxCategoriesToShow)
            .toList();

        if (categoriesWithItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(
            _paddingHorizontal,
            _paddingTop,
            _paddingHorizontal,
            _paddingBottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção
              const Text(
                'Progresso por Categoria',
                style: TextStyle(
                  fontSize: _titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              SizedBox(height: _titleBottomSpacing),
              
              // Barras de progresso
              ...categoriesWithItems.map(
                (category) => _ProgressBar(category: category),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Barra de progresso individual
class _ProgressBar extends StatelessWidget {
  final String category;

  const _ProgressBar({required this.category});

  /// ✅ Retorna a cor da categoria
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
        final categoryColor = _getCategoryColor();

        return Padding(
          padding: const EdgeInsets.only(
            bottom: ProgressIndicators._barBottomSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texto: "Alimentos Concluídos: 50%"
              Text(
                '$category Concluídos: ${percentage.toInt()}%',
                style: const TextStyle(
                  fontSize: ProgressIndicators._categoryTextFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              SizedBox(height: ProgressIndicators._categoryTextBottomSpacing),
              
              // Barra de progresso
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Fundo cinza
                        Container(
                          height: ProgressIndicators._progressBarHeight,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(
                              ProgressIndicators._progressBarRadius,
                            ),
                          ),
                        ),
                        
                        // ✅ Progresso com cor da categoria
                        FractionallySizedBox(
                          widthFactor: percentage / 100,
                          child: Container(
                            height: ProgressIndicators._progressBarHeight,
                            decoration: BoxDecoration(
                              color: categoryColor, // ✅ Cor da categoria!
                              borderRadius: BorderRadius.circular(
                                ProgressIndicators._progressBarRadius,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: ProgressIndicators._progressBarRightSpacing),
                  
                  // Percentual (com cor da categoria)
                  SizedBox(
                    width: ProgressIndicators._percentageWidth,
                    child: Text(
                      '${percentage.toInt()}%',
                      style: TextStyle(
                        fontSize: ProgressIndicators._percentageFontSize,
                        fontWeight: FontWeight.bold,
                        color: categoryColor, // ✅ Mesma cor da categoria!
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              
              // ✅ REMOVIDO: Contador de itens
            ],
          ),
        );
      },
    );
  }
}