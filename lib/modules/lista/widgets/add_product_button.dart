import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/modules/lista/models/shopping_item.dart';

/// ➕ Botão Adicionar Produto - FORA DO HEADER
/// 
/// ✏️ EDITE AQUI EMBAIXO:
class AddProductButton extends StatelessWidget {
  const AddProductButton({super.key});

  // ═══════════════════════════════════════════════════════════
  // 🎨 CONFIGURAÇÕES EDITÁVEIS - MUDE AQUI!
  // ═══════════════════════════════════════════════════════════
  
  static const double _buttonPaddingHorizontal = 28.0;
  static const double _buttonPaddingVertical = 10.0;
  static const double _buttonBorderRadius = 20.0;
  static const double _buttonFontSize = 13.0;
  
  static const double _marginTop = 12.0;
  static const double _marginBottom = 0.0;
  static const double _marginHorizontal = 16.0;
  
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _marginHorizontal,
        _marginTop,
        _marginHorizontal,
        _marginBottom,
      ),
      child: Center(
        child: GestureDetector(
          onTap: () => _showAddDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _buttonPaddingHorizontal,
              vertical: _buttonPaddingVertical,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF68A07), Color(0xFFE45C00)],
              ),
              borderRadius: BorderRadius.circular(_buttonBorderRadius),
            ),
            child: const Text(
              'Adicionar Produto',
              style: TextStyle(
                color: Colors.white,
                fontSize: _buttonFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddProductDialog(),
    );
  }
}

/// Dialog de adicionar
class _AddProductDialog extends StatefulWidget {
  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Adicionar Produto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _qtyController,
              decoration: InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final qty = int.tryParse(_qtyController.text) ?? 1;
                      
                      if (name.isNotEmpty) {
                        final controller = context.read<ShoppingListController>();
                        final item = ShoppingItem(
                          name: name,
                          quantity: qty,
                          category: controller.selectedCategory,
                        );
                        controller.addItem(item);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF68A07),
                    ),
                    child: const Text('Adicionar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}