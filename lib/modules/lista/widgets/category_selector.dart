import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 🏷️ Seletor de Categorias
/// 
/// ScrollView horizontal com botões de categoria
/// Categorias: Alimentos, Limpeza, Higiene, Bebidas, Frios, Hortifruti
class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: ShoppingListController.categories.length,
            itemBuilder: (context, index) {
              final category = ShoppingListController.categories[index];
              final isSelected = controller.selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _CategoryButton(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => controller.selectCategory(category),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Botão individual de categoria
class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFF36607) 
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFF36607) 
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF777777),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}