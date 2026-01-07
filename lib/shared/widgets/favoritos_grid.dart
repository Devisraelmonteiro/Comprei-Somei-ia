import 'package:flutter/material.dart';
import 'package:comprei_some_ia/shared/widgets/button_comprei_somei.dart';

class FavoritosGrid extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onMultiply;
  final VoidCallback onManual;

  const FavoritosGrid({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.onMultiply,
    required this.onManual,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODOS OS BOTÕES EM 1 LINHA (lado a lado)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
              // ✅ CONFIRMAR
              Expanded(
                child: ButtonCompreiSomei(
                  label: "Confirmar",
                  icon: Icons.check_circle_outline,
                  onTap: onConfirm,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // ❌ CANCELAR
              Expanded(
                child: ButtonCompreiSomei(
                  label: "Cancelar",
                  icon: Icons.cancel_outlined,
                  onTap: onCancel,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 🔄 MULTIPLICAR
              Expanded(
                child: ButtonCompreiSomei(
                  label: "Multiplicar",
                  icon: Icons.cached,
                  onTap: onMultiply,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // ✏️ MANUAL
              Expanded(
                child: ButtonCompreiSomei(
                  label: "Manual",
                  icon: Icons.create_outlined,
                  onTap: onManual,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}