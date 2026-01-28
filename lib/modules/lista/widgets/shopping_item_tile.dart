import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () => controller.toggleItemCheck(item.id),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // Mais compacto
          child: Row(
            children: [
              // Checkbox circular
              _buildCheckbox(context, controller),
              
              SizedBox(width: 12.w), // Reduzido
              
              // Conteúdo (Nome + Quantidade)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nome do produto
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14.sp, // Reduzido (antes 16)
                        fontWeight: FontWeight.w600,
                        color: item.isChecked 
                            ? Colors.grey.shade400 
                            : Colors.black87,
                        decoration: item.isChecked 
                            ? TextDecoration.lineThrough 
                            : null,
                      ),
                    ),
                    
                    SizedBox(height: 2.h), // Reduzido
                    
                    // Quantidade
                    Text(
                      'Qtd: ${item.quantity}',
                      style: TextStyle(
                        fontSize: 11.sp, // Reduzido (antes 13)
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
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onTap: () => _showEditDialog(context),
                    enabled: !item.isChecked,
                  ),
                  
                  SizedBox(width: 4.w),
                  
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
        width: 28.w, // Aumentado
        height: 28.w, 
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: item.isChecked 
              ? const Color(0xFF4CAF50) 
              : Colors.transparent, // Transparente quando não marcado
          border: Border.all(
            color: item.isChecked 
                ? const Color(0xFF4CAF50) 
                : Colors.grey.shade400, // Cinza mais escuro na borda
            width: 1.5.w,
          ),
        ),
        child: item.isChecked
            ? Icon(
                Icons.check,
                size: 18.sp, // Aumentado
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
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 32.w, // Reduzido (antes 36)
          height: 32.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.1), // Fundo mais suave
          ),
          child: Icon(
            icon,
            size: 18.sp, // Reduzido (antes 20)
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
