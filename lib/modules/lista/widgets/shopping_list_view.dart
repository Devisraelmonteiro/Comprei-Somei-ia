import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_item_tile.dart';

/// 📝 Lista de Itens de Compras
/// 
/// ListView com itens filtrados por categoria
/// Mostra estado vazio quando não há itens
class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListController>(
      builder: (context, controller, _) {
        final items = controller.filteredItems;

        if (controller.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFF36607),
            ),
          );
        }

        if (items.isEmpty) {
          return _buildEmptyState(controller.selectedCategory);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: items.length,
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

  /// Estado vazio
  Widget _buildEmptyState(String category) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum item em $category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione produtos usando o botão acima',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}