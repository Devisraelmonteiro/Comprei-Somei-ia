import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/modules/lista/widgets/add_item_dialog.dart';

/// 🛒 Card de Item COMPLETO
class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ShoppingListController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.toggleItemCheck(item.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Checkbox circular
                _buildCheckbox(context, controller),
                
                const SizedBox(width: 16),
                
                // Conteúdo (Nome + Quantidade)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome do produto
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: item.isChecked 
                              ? Colors.grey.shade400 
                              : Colors.black87,
                          decoration: item.isChecked 
                              ? TextDecoration.lineThrough 
                              : null,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Quantidade
                      Text(
                        'Qtd: ${item.quantity}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Ícones de ação
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Editar
                    _buildActionIcon(
                      icon: Icons.edit_outlined,
                      color: Colors.blue.shade600,
                      onTap: () => _showEditDialog(context),
                      enabled: !item.isChecked,
                    ),
                    
                    const SizedBox(width: 4),
                    
                    // Duplicar
                    _buildActionIcon(
                      icon: Icons.content_copy_outlined,
                      color: Colors.orange.shade600,
                      onTap: () => _duplicateItem(context, controller),
                      enabled: true,
                    ),
                    
                    const SizedBox(width: 4),
                    
                    // Excluir
                    _buildActionIcon(
                      icon: Icons.delete_outline,
                      color: Colors.red.shade600,
                      onTap: () => _confirmDelete(context, controller),
                      enabled: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Checkbox circular
  Widget _buildCheckbox(BuildContext context, ShoppingListController controller) {
    return GestureDetector(
      onTap: () => controller.toggleItemCheck(item.id),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: item.isChecked 
              ? const Color(0xFF4CAF50) 
              : Colors.white,
          border: Border.all(
            color: item.isChecked 
                ? const Color(0xFF4CAF50) 
                : Colors.grey.shade300,
            width: 2.5,
          ),
        ),
        child: item.isChecked
            ? const Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  /// Ícone de ação circular
  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }

  /// Mostra dialog de edição
  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddItemDialog(itemToEdit: item),
    );
  }

  /// Duplica o item
  void _duplicateItem(BuildContext context, ShoppingListController controller) {
    final newItem = ShoppingItem(
      name: '${item.name} (cópia)',
      quantity: item.quantity,
      category: item.category,
    );
    controller.addItem(newItem);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Item duplicado!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  /// Confirma exclusão
  void _confirmDelete(BuildContext context, ShoppingListController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Excluir item?'),
        content: Text('Deseja remover "${item.name}" da lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteItem(item.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Item removido!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}