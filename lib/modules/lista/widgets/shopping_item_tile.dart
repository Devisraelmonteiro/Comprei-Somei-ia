import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/home/home_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
                    
                    // Quantidade + Unidade (sem prefixo "Qtd")
                    Text(
                      '${item.quantity}${item.unitLabel != null && item.unitLabel!.isNotEmpty ? ' ${item.unitLabel}' : ''}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    // Preço (se disponível)
                    if (item.totalPrice != null || item.unitPrice != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        _priceLabel(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Ícones de ação
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selecionar para captura (vincular nome)
                  _buildActionIcon(
                    icon: item.isChecked ? Icons.camera_alt : Icons.camera_alt_outlined,
                    color: item.isChecked ? const Color(0xFF4CAF50) : Colors.black87,
                    onTap: () => _selectForCapture(context),
                    enabled: true,
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

  void _selectForCapture(BuildContext context) {
    final list = context.read<ShoppingListController>();
    final home = context.read<HomeController>();
    list.setItemCheck(item.id, true);
    home.setSelectedItemForCapture(item.name, unitLabel: item.unitLabel, quantity: item.quantity);
    context.go('/home');
  }

  String _priceLabel() {
    if (item.totalPrice != null) {
      return 'Total: R\$ ${item.totalPrice!.toStringAsFixed(2)}';
    }
    if (item.unitPrice != null) {
      final unit = (item.unitLabel ?? '').trim();
      final suffix = unit.isNotEmpty ? ' / $unit' : '';
      return 'Preço: R\$ ${item.unitPrice!.toStringAsFixed(2)}$suffix';
    }
    return '';
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
            color: Colors.grey.withValues(alpha: 0.1), // Fundo mais suave
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
