import 'package:flutter/material.dart';

class ButtonCompreiSomei extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor; // ← Cor opcional (sobrescreve automática)

  const ButtonCompreiSomei({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // Cor automática baseada no label
    final Color activeColor = iconColor ?? _getColorByLabel(label);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: activeColor.withValues(alpha: 0.12),
        highlightColor: activeColor.withValues(alpha: 0.08),
        child: Container(
          width: 75,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.04),
              width: 1,
            ),
            boxShadow: [
              // Sombra principal
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
              // Sombra secundária (mais suave)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ÍCONE COM ANIMAÇÃO
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.95, end: 1.0),
                duration: const Duration(milliseconds: 200),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      icon,
                      color: activeColor,
                      size: 32,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 8),
              
              // TEXTO
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF424242),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para definir cor baseada na função
  Color _getColorByLabel(String label) {
    final String labelLower = label.toLowerCase();
    
    if (labelLower.contains('confirm')) {
      return const Color(0xFF4CAF50); // Verde - ação positiva
    } else if (labelLower.contains('cancel') || labelLower.contains('exclu')) {
      return const Color(0xFFF44336); // Vermelho - ação negativa
    } else if (labelLower.contains('multipl') || labelLower.contains('repet')) {
      return const Color(0xFF2196F3); // Azul - ação de cálculo
    } else if (labelLower.contains('manual') || labelLower.contains('edit')) {
      return const Color(0xFFFF9800); // Laranja - entrada manual
    } else if (labelLower.contains('saldo') || labelLower.contains('valor')) {
      return const Color(0xFF9C27B0); // Roxo - valores/saldo
    } else if (labelLower.contains('list') || labelLower.contains('item')) {
      return const Color(0xFF00BCD4); // Ciano - listas
    } else {
      return const Color(0xFF4CAF50); // Verde padrão
    }
  }
}
