import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'add_item_dialog.dart';

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
      builder: (context) => const AddItemDialog(),
    );
  }
}
