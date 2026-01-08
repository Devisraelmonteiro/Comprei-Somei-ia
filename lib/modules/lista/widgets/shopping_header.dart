import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

/// 📱 Header OTIMIZADO - Igual à segunda imagem
/// 
/// ✏️ EDITE AQUI EMBAIXO:
class ShoppingHeader extends StatelessWidget {
  const ShoppingHeader({super.key});

  // ═══════════════════════════════════════════════════════════
  // 🎨 CONFIGURAÇÕES EDITÁVEIS - MUDE AQUI!
  // ═══════════════════════════════════════════════════════════
  
  // PARTE LARANJA
  static const double _topPaddingVertical = 10.0;
  static const double _topPaddingHorizontal = 16.0;
  static const double _iconSize = 18.0;
  static const double _iconTextSpacing = 8.0;
  static const double _appNameFontSize = 15.0;
  static const double _closeIconSize = 20.0;
  
  // PARTE AZUL
  static const double _bluePaddingTop = 12.0;
  static const double _bluePaddingBottom = 14.0;
  static const double _bluePaddingHorizontal = 16.0;
  static const Color _blueBackgroundColor = Color(0xFF36515F);
  
  static const double _titleFontSize = 17.0;
  static const double _titleBottomSpacing = 4.0;
  
  static const double _subtitleFontSize = 10.5;
  static const double _subtitleBottomSpacing = 12.0;
  static const double _subtitleOpacity = 0.7;
  
  // CATEGORIAS (2 linhas)
  static const double _categoryPillPaddingHorizontal = 16.0;
  static const double _categoryPillPaddingVertical = 8.0;
  static const double _categoryPillBorderRadius = 18.0;
  static const double _categoryPillFontSize = 12.0;
  static const double _categorySpacing = 8.0; // Entre pills
  static const double _categoryRunSpacing = 8.0; // Entre linhas
  
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOrangeTop(context),
        _buildBlueSection(context),
      ],
    );
  }

  /// Parte laranja
  Widget _buildOrangeTop(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _topPaddingHorizontal,
        vertical: _topPaddingVertical,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF68A07), Color(0xFFE45C00)],
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shopping_cart_outlined, color: Colors.white, size: _iconSize),
          SizedBox(width: _iconTextSpacing),
          const Text(
            'CompreiSomei',
            style: TextStyle(
              color: Colors.white,
              fontSize: _appNameFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, color: Colors.white, size: _closeIconSize),
          ),
        ],
      ),
    );
  }

  /// Parte azul (só título + categorias, SEM botão)
  Widget _buildBlueSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        _bluePaddingHorizontal,
        _bluePaddingTop,
        _bluePaddingHorizontal,
        _bluePaddingBottom,
      ),
      decoration: const BoxDecoration(color: _blueBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Sua Lista de Compras',
            style: TextStyle(
              color: Colors.white,
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: _titleBottomSpacing),
          
          // Subtítulo
          Text(
            'Organize suas compras que deseja levar na sua compra',
            style: TextStyle(
              color: Colors.white.withOpacity(_subtitleOpacity),
              fontSize: _subtitleFontSize,
            ),
          ),
          
          SizedBox(height: _subtitleBottomSpacing),
          
          // ✅ Categorias em 2 linhas
          _buildCategories(context),
        ],
      ),
    );
  }

  /// Categorias em Wrap (2 linhas)
  Widget _buildCategories(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        return Wrap(
          spacing: _categorySpacing,
          runSpacing: _categoryRunSpacing,
          alignment: WrapAlignment.center,
          children: ShoppingListController.categories.map((category) {
            final isSelected = controller.selectedCategory == category;
            return _CategoryPill(
              label: category,
              isSelected: isSelected,
              onTap: () => controller.selectCategory(category),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Pill de categoria
class _CategoryPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  Color _getCategoryColor() {
    switch (label) {
      case 'Alimentos': return const Color(0xFFF68A07);
      case 'Limpeza': return const Color(0xFF5DBFB3);
      case 'Higiene': return const Color(0xFFE8C547);
      case 'Bebidas': return const Color(0xFF6BA5D6);
      case 'Frios': return const Color(0xFFB38DD6);
      case 'Hortifruti': return const Color(0xFF7BC96F);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ShoppingHeader._categoryPillPaddingHorizontal,
          vertical: ShoppingHeader._categoryPillPaddingVertical,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? _getCategoryColor() 
              : _getCategoryColor().withOpacity(0.6),
          borderRadius: BorderRadius.circular(
            ShoppingHeader._categoryPillBorderRadius,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: ShoppingHeader._categoryPillFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}