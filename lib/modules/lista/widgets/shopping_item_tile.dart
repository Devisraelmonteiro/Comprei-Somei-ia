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

    return Card( // Usando Card para elevação (efeito Matrix/Material)
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: item.isChecked ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.toggleItemCheck(item.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                // Checkbox circular
                _buildCheckbox(context, controller),
                
                const SizedBox(width: 16),
                
                // Conteúdo (Nome + Quantidade + Categoria)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Categoria (Título para saber qual lista está)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(70, 249, 200, 153).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 4),

                      // Nome do produto
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: item.isChecked 
                              ? Colors.grey.shade400 
                              : Colors.black87,
                          decoration: item.isChecked 
                              ? TextDecoration.lineThrough 
                              : null,
                        ),
                      ),
                      
                      const SizedBox(height: 2),
                      
                      // Quantidade
                      Text(
                        'Qtd: ${item.quantity}',
                        style: TextStyle(
                          fontSize: 10,
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
                    
                    // Excluir
                    _buildActionIcon(
                      icon: Icons.delete_outline,
                      color: Colors.red.shade400,
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

  /// Cor do indicador baseado no nome (Simulação para demo)
  Color _getItemIndicatorColor(String name) {
    // Demo logic conforme imagem
    if (name.toLowerCase().contains('arroz')) return const Color(0xFFFF8C42); // Laranja
    if (name.toLowerCase().contains('feijão')) return const Color(0xFFE84545); // Vermelho
    if (name.toLowerCase().contains('maarn')) return const Color(0xFFE84545); // Vermelho
    return Colors.grey.shade400; // Padrão
  }

  /// Checkbox circular
  Widget _buildCheckbox(BuildContext context, ShoppingListController controller) {
    return GestureDetector(
      onTap: () => controller.toggleItemCheck(item.id),
      child: Container(
        width: 28, // Aumentado
        height: 28, 
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: item.isChecked 
              ? const Color(0xFF4CAF50) 
              : Colors.transparent, // Transparente quando não marcado
          border: Border.all(
            color: item.isChecked 
                ? const Color(0xFF4CAF50) 
                : Colors.grey.shade400, // Cinza mais escuro na borda
            width: 1.5,
          ),
        ),
        child: item.isChecked
            ? const Icon(
                Icons.check,
                size: 18, // Aumentado
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
      opacity: enabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 36, // Botões maiores para toque fácil
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withValues(alpha: 0.1), // Fundo mais suave
          ),
          child: Icon(
            icon,
            size: 20, // Ícone maior
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