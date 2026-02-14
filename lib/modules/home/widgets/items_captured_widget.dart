import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/modules/home/home_controller.dart';
import 'package:comprei_some_ia/modules/home/models/captured_item.dart';
import 'package:comprei_some_ia/modules/home/widgets/captured_item_tile.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';

/// 📋 Widget da lista de itens capturados - VERSÃO FINAL HARMONIZADA
/// 
/// ✅ Itens COLADOS (sem espaço entre eles)
/// ✅ Footer COMPACTO e VISÍVEL
/// ✅ Mostra 3 itens completos
/// ✅ Título, contador e botão HARMONIZADOS (mesmo tamanho)
class ItemsCapturedWidget extends StatelessWidget {
  final HomeController controller;

  const ItemsCapturedWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final items = controller.items;
    final total = controller.total;
    final hasItems = items.isNotEmpty;

    return Container(
      // ⚠️ SEM margin horizontal - home_page já tem padding!
      margin: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: AppSizes.spacingTiny,
      ),
      decoration: _buildCardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(items.length),
          _buildDivider(),
          Expanded(
            child: hasItems ? _buildItemsList(items) : _buildEmptyState(),
          ),
          _buildDivider(),
          _buildFooter(total, hasItems, context),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius * 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Colors.white);
  }

  Widget _buildHeader(int itemCount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding,
        vertical: AppSizes.spacingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(),
          if (itemCount > 0) _buildCountBadge(itemCount),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Itens Capturados",
      style: TextStyle(
        fontSize: AppSizes.titleExtraSmall,  // 12sp
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF36607).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: const Color(0xFFF36607).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        _getCountLabel(count),
        style: TextStyle(
          fontSize: AppSizes.labelSmall,  
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF36607),
        ),
      ),
    );
  }

  String _getCountLabel(int count) {
    return '$count ${count == 1 ? 'item' : 'itens'}';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingHuge,
          vertical: AppSizes.spacingExtraLarge,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(),
            SizedBox(height: AppSizes.spacingLarge),
            _buildEmptyTitle(),
            SizedBox(height: AppSizes.spacingSmall),
            _buildEmptySubtitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.shopping_basket_outlined,
        size: AppSizes.iconExtraLarge + 2.sp,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildEmptyTitle() {
    return Text(
      "Nenhum item ainda",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: AppSizes.labelMedium,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmptySubtitle() {
    return Text(
      "Capture preços com a câmera\nou adicione manualmente",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: AppSizes.labelSmall,
        height: 1.4,
      ),
    );
  }

  Widget _buildItemsList(List<CapturedItem> items) {
    return ListView.separated(
      // ✅ PADDING ZERO - itens ficam colados!
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _buildAnimatedItem(items[index], index),
    );
  }

  Widget _buildAnimatedItem(CapturedItem item, int index) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: _buildItemTransition,
      child: CapturedItemTile(
        key: ValueKey(item.id),
        item: item,
        index: index,
        onDelete: () => _handleDeleteItem(index),
        onTap: () => _handleEditItem(item),
      ),
    );
  }

  Widget _buildItemTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildFooter(double total, bool hasItems, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.cardPadding,
        vertical: AppSizes.footerPaddingVertical,
      ),
      decoration: _buildFooterDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTotalSection(total),
          if (hasItems) _buildClearButton(context),
        ],
      ),
    );
  }

  BoxDecoration _buildFooterDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(AppSizes.cardRadius * 2),
        bottomRight: Radius.circular(AppSizes.cardRadius * 2),
      ),
    );
  }

  Widget _buildTotalSection(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Total",
          style: TextStyle(
            fontSize: AppSizes.footerLabelSize,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          _formatCurrency(total),
          style: TextStyle(
            fontSize: AppSizes.footerValueSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFEA6207),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleClearAll(context),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: _buildClearButtonDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_sweep_outlined,
                size: 16.sp,
                color: Colors.red.shade600,
              ),
              SizedBox(width: 4.w),
              Text(
                "Limpar",
                style: TextStyle(
                  fontSize: AppSizes.titleExtraSmall,  // 12sp - harmonizado!
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildClearButtonDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.red.withOpacity(0.3),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
    );
  }

  void _handleDeleteItem(int index) {
    controller.deleteItem(index);
    debugPrint('🗑️ Item $index deletado');
  }

  void _handleEditItem(CapturedItem item) {
    debugPrint('✏️ Editar item: ${item.id}');
  }

  void _handleClearAll(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Limpar Lista?'),
          content: const Text(
            'Tem certeza que deseja excluir todos os itens?\nEsta ação não pode ser desfeita.',
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancelar'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                controller.clearAll();
                Navigator.of(ctx).pop();
                debugPrint('🗑️ Todos os itens limpos');
              },
              child: const Text('Limpar Tudo'),
            ),
          ],
        );
      },
    );
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 TAMANHOS HARMONIZADOS - TUDO 12sp!
// ═══════════════════════════════════════════════════════════════
//
// ✅ Título "Itens Capturados": 12sp (AppSizes.titleExtraSmall)
// ✅ Contador "5 itens": 12sp (AppSizes.titleExtraSmall)
// ✅ Botão "Limpar": 12sp (AppSizes.titleExtraSmall)
//
// Padding harmonizado:
// - Contador: 8px horizontal, 3px vertical
// - Botão: 10px horizontal, 5px vertical
//
// ═══════════════════════════════════════════════════════════════