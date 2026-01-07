import 'package:flutter/material.dart';
import 'package:comprei_some_ia/modules/home/models/captured_item.dart';

/// 📋 Widget de um item capturado individual
/// 
/// Exibe:
/// - Nome/label do item
/// - Valor com formatação
/// - Botão de deletar
/// - Indicador de tipo (manual/automático/multiplicado)
class CapturedItemTile extends StatelessWidget {
  /// Item a ser exibido
  final CapturedItem item;
  
  /// Índice na lista (para exibir número)
  final int index;
  
  /// Callback ao clicar em deletar
  final VoidCallback onDelete;
  
  /// Callback ao clicar no item (opcional, para editar)
  final VoidCallback? onTap;

  const CapturedItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Botão de deletar
                _buildDeleteButton(),
                
                const SizedBox(width: 12),
                
                // Informações do item
                Expanded(child: _buildItemInfo()),
                
                const SizedBox(width: 12),
                
                // Valor
                _buildValue(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🗑️ Botão de deletar
  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.red,
          size: 18,
        ),
      ),
    );
  }

  /// 📝 Informações do item
  Widget _buildItemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nome/label
        Row(
          children: [
            Flexible(
              child: Text(
                '${item.displayLabel} ${index + 1}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            _buildTypeIndicator(),
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Informações extras
        _buildExtraInfo(),
      ],
    );
  }

  /// 🏷️ Indicador de tipo
  Widget _buildTypeIndicator() {
    IconData icon;
    Color color;
    String tooltip;

    switch (item.type) {
      case CaptureType.automatic:
        icon = Icons.camera_alt;
        color = const Color(0xFFF36607);
        tooltip = 'Capturado automaticamente';
        break;
      case CaptureType.manual:
        icon = Icons.edit;
        color = Colors.blue;
        tooltip = 'Adicionado manualmente';
        break;
      case CaptureType.multiplied:
        icon = Icons.close;
        color = Colors.purple;
        tooltip = 'Multiplicado';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        size: 14,
        color: color,
      ),
    );
  }

  /// ℹ️ Informações extras (multiplicador, horário)
  Widget _buildExtraInfo() {
    final extras = <String>[];

    // Multiplicador (se > 1)
    if (item.multiplier > 1) {
      extras.add('x${item.multiplier}');
    }

    // Horário
    final time = _formatTime(item.capturedAt);
    extras.add(time);

    return Text(
      extras.join(' • '),
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey.shade600,
      ),
    );
  }

  /// 💰 Valor
  Widget _buildValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Valor final
        Text(
          '+R\$ ${item.finalValue.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF039D2C),
          ),
        ),
        
        // Valor unitário (se tiver multiplicador)
        if (item.multiplier > 1)
          Text(
            'R\$ ${item.value.toStringAsFixed(2)} cada',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }

  /// 🎨 Cor da borda baseada no tipo
  Color _getBorderColor() {
    switch (item.type) {
      case CaptureType.automatic:
        return const Color(0xFFF36607).withOpacity(0.2);
      case CaptureType.manual:
        return Colors.blue.withOpacity(0.2);
      case CaptureType.multiplied:
        return Colors.purple.withOpacity(0.2);
    }
  }

  /// 🕐 Formata horário
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}