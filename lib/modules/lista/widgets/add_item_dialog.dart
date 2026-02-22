import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
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
  late String _selectedUnit;
  late final Map<String, List<Map<String, String>>> _unitCategories;
  bool _showUnitMenu = false;
  // Ajuste de altura da folha (0.30 = 30% da tela, 0.80 = 80% da tela)
  double _sheetHeightFactor = 0.48; // EDITAR AQUI para altura desejada
  // Ajuste fino para espaço acima do teclado quando focar campos
  double _keyboardOffset = 18; // EDITAR AQUI para subir mais/menos com teclado

  bool get isEditing => widget.itemToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.itemToEdit?.name ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.itemToEdit != null ? widget.itemToEdit!.quantity.toString() : '',
    );
    _nameFocusNode = FocusNode();
    _selectedUnit = widget.itemToEdit?.unitLabel != null && widget.itemToEdit!.unitLabel!.isNotEmpty
        ? widget.itemToEdit!.unitLabel!
        : 'un';
    _unitCategories = {
      'Massa': [
        {'abbr': 'mg', 'name': 'miligrama'},
        {'abbr': 'g', 'name': 'grama'},
        {'abbr': 'kg', 'name': 'quilograma'},
      ],
      'Volume': [
        {'abbr': 'ml', 'name': 'mililitro'},
        {'abbr': 'L', 'name': 'litro'},
        {'abbr': 'peso líq.', 'name': 'peso líquido'},
      ],
      'Contagem': [
        {'abbr': 'un', 'name': 'unidade'},
        {'abbr': 'pç', 'name': 'peça'},
        {'abbr': 'dz', 'name': 'dúzia'},
        {'abbr': 'qtd.', 'name': 'quantidade'},
      ],
      'Embalagens': [
        {'abbr': 'pct', 'name': 'pacote'},
        {'abbr': 'cx', 'name': 'caixa'},
        {'abbr': 'ct', 'name': 'cartela'},
        {'abbr': 'fd', 'name': 'fardo'},
        {'abbr': 'rl', 'name': 'rolo'},
        {'abbr': 'kit', 'name': 'conjunto'},
      ],
      'Comprimento': [
        {'abbr': 'mm', 'name': 'milímetros'},
        {'abbr': 'cm', 'name': 'centímetros'},
        {'abbr': 'm', 'name': 'metros'},
      ],
      'Papel': [
        {'abbr': 'folh', 'name': 'folhas'},
      ],
      'Outros': [
        {'abbr': 'a granel', 'name': 'a granel'},
      ],
    };
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
      child: SizedBox(
        height: _computeSheetHeight(context), // Altura controlada
        child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Form(
            key: _formKey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? 'Editar Produto' : 'Adicionar Produto',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Campo Nome
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Nome do Produto',
                  labelStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFF36607), size: 18),
                ),
                style: const TextStyle(fontSize: 14),
                textCapitalization: TextCapitalization.words,
                autofocus: !isEditing,
                textInputAction: TextInputAction.done,
                scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 80,
                ),
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
              
              const SizedBox(height: 10),
              
              // Linha: Quantidade (valor digitado) + Unidade (dropdown laranja com rolagem)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Medida',
                        labelStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: const Icon(Icons.straighten, color: Color(0xFFF36607), size: 18),
                        counterText: '',
                      ),
                      style: const TextStyle(fontSize: 14),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + _keyboardOffset,
                      ),
                      maxLength: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a quantidade';
                        }
                        final qty = int.tryParse(value);
                        if (qty == null || qty <= 0) {
                          return 'Quantidade deve ser maior que zero';
                        }
                        if (qty > 9999) {
                          return 'Quantidade máxima é 9999';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showUnitMenu = !_showUnitMenu;
                            });
                          },
                          child: InputDecorator(
                            isFocused: _showUnitMenu,
                            decoration: InputDecoration(
                              labelText: 'Unidade',
                              labelStyle: const TextStyle(fontSize: 12),
                              filled: true,
                              fillColor: Colors.orange.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFF36607)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFF36607)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(color: Color(0xFFF36607), width: 1.5),
                              ),
                              suffixIcon: SizedBox(
                                width: 44,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.scale_outlined, color: Color(0xFFF36607), size: 18),
                                    const SizedBox(width: 4),
                                    Icon(
                                      _showUnitMenu ? Icons.expand_less : Icons.expand_more,
                                      color: const Color(0xFFF36607),
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.circle, size: 6, color: Color(0xFFF36607)),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedUnit.toUpperCase(),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _unitLongName(_selectedUnit),
                                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_showUnitMenu) ...[
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFF36607)),
                            ),
                            constraints: const BoxConstraints(maxHeight: 160), // ~4 itens visíveis
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              itemBuilder: (context, index) {
                                final entries = _flattenUnits();
                                final u = entries[index];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedUnit = u['abbr']!;
                                      _showUnitMenu = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.circle, size: 6, color: Color(0xFFF36607)),
                                        const SizedBox(width: 8),
                                        Text(
                                          u['abbr']!.toUpperCase(),
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          u['name']!,
                                          style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.orange.shade100),
                              itemCount: _flattenUnits().length,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Dica: unidade já está incluída na seleção de quantidade acima
              
              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF36607),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
        unitLabel: _selectedUnit,
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
        unitLabel: _selectedUnit,
      );
      controller.addItem(newItem);
      _nameController.text = '';
      _selectedUnit = 'un';
      _quantityController.text = '';
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
  
  List<Map<String, String>> _flattenUnits() {
    final list = <Map<String, String>>[];
    _unitCategories.forEach((category, units) {
      for (final u in units) {
        list.add({'abbr': u['abbr']!, 'name': u['name']!, 'category': category});
      }
    });
    return list;
  }
  
 
  
  String _unitLongName(String abbr) {
    for (final entry in _unitCategories.entries) {
      for (final u in entry.value) {
        if (u['abbr'] == abbr) return u['name']!;
      }
    }
    return abbr;
  }
  
  // Cálculo da altura da folha baseado em _sheetHeightFactor e teclado
  double _computeSheetHeight(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    final desired = size.height * _sheetHeightFactor;
    final available = size.height - keyboard;
    // Garante mínimo confortável e não ultrapassar área disponível
    final clamped = desired.clamp(240.0, available);
    return clamped.toDouble();
  }
}
