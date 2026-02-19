import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

/// ➕ Dialog para Adicionar/Editar Item
class AddItemDialog extends StatefulWidget {
  final ShoppingItem? itemToEdit;

  const AddItemDialog({
    super.key,
    this.itemToEdit,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  final _formKey = GlobalKey<FormState>();
  late final FocusNode _nameFocusNode;

  bool get isEditing => widget.itemToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.itemToEdit?.name ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.itemToEdit?.quantity.toString() ?? '1',
    );
    _nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Editar Produto' : 'Adicionar Produto',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Campo Nome
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Nome do Produto',
                  hintText: 'Ex: Arroz, Feijão, Macarrão',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.shopping_cart_outlined),
                ),
                textCapitalization: TextCapitalization.words,
                autofocus: !isEditing,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome do produto';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Campo Quantidade
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  hintText: '1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a quantidade';
                  }
                  final qty = int.tryParse(value);
                  if (qty == null || qty <= 0) {
                    return 'Quantidade deve ser maior que zero';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF36607),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(isEditing ? 'Salvar' : 'Adicionar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<ShoppingListController>();
    final name = _nameController.text.trim();
    final quantity = int.parse(_quantityController.text);

    if (isEditing) {
      // Editar item existente
      final updatedItem = widget.itemToEdit!.copyWith(
        name: name,
        quantity: quantity,
      );
      controller.updateItem(updatedItem);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Item atualizado!'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Adicionar novo item
      final newItem = ShoppingItem(
        name: name,
        quantity: quantity,
        category: controller.selectedCategory,
      );
      controller.addItem(newItem);
      _nameController.text = '';
      _quantityController.text = '1';
      FocusScope.of(context).requestFocus(_nameFocusNode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Item adicionado!'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
