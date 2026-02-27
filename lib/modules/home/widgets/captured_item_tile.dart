import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/modules/home/models/captured_item.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';

/// 📋 Widget de um item capturado individual - SEM NUMERAÇÃO
/// 
/// ✅ Apenas ícone de câmera (sem números)
/// ✅ Usa AppSizes (código sênior)
/// ✅ Altura compacta (52px)
class CapturedItemTile extends StatelessWidget {
  /// Item a ser exibido
  final CapturedItem item;
  
  /// Índice na lista (não é mais usado para exibição)
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
      height: AppSizes.itemTileHeight,  // 48px - BEM compacto!
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),  // ← MENOR (era 8h)
            child: Row(
              children: [
                // Botão de deletar
                _buildDeleteButton(),
                
                SizedBox(width: 12.w),
                
                // Informações do item
                Expanded(child: _buildItemInfo()),
                
                SizedBox(width: 12.w),
                
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
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.delete_outline,
          color: Colors.red,
          size: 18.sp,
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
        // Nome/label SEM numeração! ✅
        Row(
          children: [
            Flexible(
              child: Text(
                item.displayLabel,  // ← SEM '${index + 1}'!
                style: TextStyle(
                  fontSize: 11.sp,  // ← MENOR (era 13sp)
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 6.w),
            _buildTypeIndicator(),
          ],
        ),
        
        SizedBox(height: 1.h),  // ← MENOR (era 2h)
        
        // Informações extras
        _buildExtraInfo(),
      ],
    );
  }

  /// 🏷️ Indicador de tipo (APENAS ÍCONE DE CÂMERA)
  Widget _buildTypeIndicator() {
    IconData icon;
    Color color;
    String tooltip;

    switch (item.type) {
      case CaptureType.automatic:
        icon = Icons.camera_alt;  // Ícone de câmera (Verde)
        color = const Color.fromARGB(255, 3, 136, 36); // Verde iOS Oficial
        tooltip = 'Capturado automaticamente';
        break;
      case CaptureType.manual:
        icon = Icons.add_circle_outline; // Ícone do botão Manual (sinal de soma)
        color = const Color.fromARGB(255, 243, 122, 41); // Laranja App
        tooltip = 'Adicionado manualmente';
        break;
      case CaptureType.multiplied:
        icon = Icons.cached; // Ícone do botão Multiplicador (Loop)
        color = const Color.fromARGB(255, 15, 125, 242); // Azul iOS
        tooltip = 'Multiplicado';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        size: 16.sp,  // Aumentei um pouco para visibilidade
        color: color,
      ),
    );
  }

  /// ℹ️ Informações extras (multiplicador, horário)
  Widget _buildExtraInfo() {
    final extras = <String>[];

    if (item.type == CaptureType.manual) {
      extras.add('Qtd: ${item.multiplier}');
    } else {
      if (item.multiplier > 1) {
        extras.add('x${item.multiplier}');
      }
    }

    final time = _formatTime(item.capturedAt);
    extras.add(time);

    return Text(
      extras.join(' • '),
      style: TextStyle(
        fontSize: 10.sp,
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
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF34C759), // Verde iOS unificado
          ),
        ),
        
        // Valor unitário (se tiver multiplicador)
        if (item.multiplier > 1)
          Text(
            'R\$ ${item.value.toStringAsFixed(2)} cada',
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }

  /// 🎨 Cor da borda baseada no tipo
  Color _getBorderColor() {
    return AppColors.primaryWithOpacity(0.35);
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

// ═══════════════════════════════════════════════════════════════
// ✅ MUDANÇAS APLICADAS:
// ═══════════════════════════════════════════════════════════════
//
// ❌ REMOVIDO: '${index + 1}' (numeração)
// ✅ MANTIDO: Ícone de câmera para itens automáticos
// ✅ ADICIONADO: AppSizes.itemTileHeight (52px - compacto)
// ✅ ADICIONADO: ScreenUtil (.w, .h, .sp, .r) - responsivo
//
// Agora os itens aparecem como:
// - "Preço Capturado 📷" (sem números!)
// - "Valor Manual ✏️"
// - "Preço Capturado ✖️" (multiplicado)
//
// ═══════════════════════════════════════════════════════════════
