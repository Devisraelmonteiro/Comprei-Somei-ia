import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/modules/home/home_controller.dart';
import 'package:comprei_some_ia/modules/home/models/captured_item.dart';
import 'package:comprei_some_ia/modules/home/widgets/captured_item_tile.dart';

/// 📋 Widget da lista de itens capturados - VERSÃO RESPONSIVA
/// 
/// ✅ SEM altura fixa - usa Expanded para ocupar todo espaço
/// ✅ Responsivo com ScreenUtil (.w, .h, .sp)
/// ✅ Scroll interno quando tem 3+ itens
/// ✅ Ocupa espaço até o footer automaticamente
/// 
/// 🎯 MUDANÇAS PRINCIPAIS:
/// - Removido: altura fixa (_cardHeight)
/// - Adicionado: Container sem height (ocupa espaço do Expanded no pai)
/// - Resultado: Lista cresce automaticamente até o footer
class ItemsCapturedWidget extends StatelessWidget {
  // ═══════════════════════════════════════════════════════════════
  // 📐 CONFIGURAÇÕES RESPONSIVAS
  // ═══════════════════════════════════════════════════════════════
  
  /// ❌ REMOVIDO: _cardHeight (altura fixa)
  /// ✅ AGORA: Usa Expanded do pai (home_page.dart)
  
  /// Padding horizontal do card
  static const double _cardHorizontalMargin = 16.0;
  
  /// Padding vertical do card
  static const double _cardVerticalMargin = 4.0;
  
  /// Raio de arredondamento do card
  static const double _cardBorderRadius = 24.0;
  
  /// Elevação da sombra
  static const double _cardShadowBlur = 12.0;
  
  /// Espaçamento entre itens na lista
  static const double _itemSpacing = 0;
  
  // ═══════════════════════════════════════════════════════════════
  
  final HomeController controller;

  const ItemsCapturedWidget({
    super.key,
    required this.controller,
  });

  // ═══════════════════════════════════════════════════════════════
  // 🎨 BUILD PRINCIPAL
  // ═══════════════════════════════════════════════════════════════
  
  @override
  Widget build(BuildContext context) {
    final items = controller.items;
    final total = controller.total;
    final hasItems = items.isNotEmpty;

    return Container(
      // ❌ REMOVIDO: height: _cardHeight,
      // ✅ SEM height = ocupa TODO espaço do Expanded (no pai)
      
      margin: EdgeInsets.symmetric(
        horizontal: _cardHorizontalMargin.w,
        vertical: _cardVerticalMargin.h,
      ),
      decoration: _buildCardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(items.length),
          _buildDivider(),
          
          // ✅ ESTE Expanded faz a lista ocupar todo espaço disponível
          Expanded(
            child: hasItems
                ? _buildItemsList(items)
                : _buildEmptyState(),
          ),
          
          _buildDivider(),
          _buildFooter(total, hasItems),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎨 DECORAÇÃO
  // ═══════════════════════════════════════════════════════════════
  
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_cardBorderRadius.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: _cardShadowBlur,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔝 HEADER
  // ═══════════════════════════════════════════════════════════════
  
  Widget _buildHeader(int itemCount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF36607).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFF36607).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        _getCountLabel(count),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF36607),
        ),
      ),
    );
  }

  String _getCountLabel(int count) {
    return '$count ${count == 1 ? 'item' : 'itens'}';
  }

  // ═══════════════════════════════════════════════════════════════
  // 📭 ESTADO VAZIO
  // ═══════════════════════════════════════════════════════════════
  
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(),
            SizedBox(height: 16.h),
            _buildEmptyTitle(),
            SizedBox(height: 8.h),
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
        size: 30.sp,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildEmptyTitle() {
    return Text(
      "Nenhum item ainda",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 12.sp,
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
        fontSize: 10.sp,
        height: 1.4,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 📋 LISTA DE ITENS
  // ═══════════════════════════════════════════════════════════════
  
  Widget _buildItemsList(List<CapturedItem> items) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: _itemSpacing.h),
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

  // ═══════════════════════════════════════════════════════════════
  // 📊 FOOTER
  // ═══════════════════════════════════════════════════════════════
  
  Widget _buildFooter(double total, bool hasItems) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: _buildFooterDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTotalSection(total),
          if (hasItems) _buildClearButton(),
        ],
      ),
    );
  }

  BoxDecoration _buildFooterDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(_cardBorderRadius.r),
        bottomRight: Radius.circular(_cardBorderRadius.r),
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
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          _formatCurrency(total),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: const Color(0xFFEA6207),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleClearAll,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: _buildClearButtonDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_sweep_outlined,
                size: 20.sp,
                color: Colors.red.shade600,
              ),
              SizedBox(width: 8.w),
              Text(
                "Limpar",
                style: TextStyle(
                  fontSize: 13.sp,
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
      borderRadius: BorderRadius.circular(12.r),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎬 HANDLERS
  // ═══════════════════════════════════════════════════════════════
  
  void _handleDeleteItem(int index) {
    controller.deleteItem(index);
    debugPrint('🗑️ [ItemsCaptured] Item $index deletado');
  }

  void _handleEditItem(CapturedItem item) {
    // TODO: Implementar edição de item
    debugPrint('✏️ [ItemsCaptured] Editar item: ${item.id}');
  }

  void _handleClearAll() {
    controller.clearAll();
    debugPrint('🗑️ [ItemsCaptured] Todos os itens limpos');
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔧 UTILITÁRIOS
  // ═══════════════════════════════════════════════════════════════
  
  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 EXPLICAÇÃO - POR QUE AGORA FUNCIONA?
// ═══════════════════════════════════════════════════════════════
//
// ANTES (com altura fixa):
// ┌─────────────────────┐
// │                     │
// │  CONTEÚDO           │
// │                     │
// ├─────────────────────┤
// │                     │
// │  LISTA (326px)      │ ← ALTURA FIXA!
// │  ❌ Não cresce      │
// │                     │
// ├─────────────────────┤
// │  FOOTER             │
// └─────────────────────┘
//     ↓ Sobra espaço
//
// AGORA (sem altura fixa):
// ┌─────────────────────┐
// │                     │
// │  CONTEÚDO           │
// │                     │
// ├─────────────────────┤
// │                     │
// │  LISTA              │
// │  ✅ Ocupa TODO      │
// │     espaço até      │
// │     o footer        │
// │                     │
// ├─────────────────────┤
// │  FOOTER             │
// └─────────────────────┘
//     ✅ Sem sobra!
//
// ESTRUTURA NO home_page.dart:
//
// Expanded(  ← Este Expanded dá espaço infinito
//   child: ItemsCapturedWidget(  ← Container SEM height
//     child: Column(
//       children: [
//         Header,
//         Divider,
//         Expanded(  ← Este Expanded faz a lista ocupar
//           child: ListView(...),  ← todo espaço disponível
//         ),
//         Divider,
//         Footer,
//       ],
//     ),
//   ),
// )
//
// 🔥 REGRA DE OURO:
// - Widget DENTRO de Expanded = NÃO use height fixa
// - Deixe o Expanded controlar o tamanho
//
// ═══════════════════════════════════════════════════════════════