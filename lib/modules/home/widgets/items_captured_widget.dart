import 'package:flutter/material.dart';
import 'package:comprei_some_ia/modules/home/home_controller.dart';
import 'package:comprei_some_ia/modules/home/models/captured_item.dart';
import 'package:comprei_some_ia/modules/home/widgets/captured_item_tile.dart';

/// 📋 Widget da lista de itens capturados
/// 
/// Características:
/// - Altura fixa e configurável via constante
/// - Scroll interno otimizado com ListView.separated
/// - Header e Footer fixos fora da área de scroll
/// - Estado vazio com UX polido
/// - Animações suaves de entrada/saída
/// - Divisores visuais sutis
/// 
/// Padrões aplicados:
/// - Single Responsibility: apenas exibição de lista
/// - Composition: delega lógica ao Controller
/// - Constantes configuráveis no topo
/// - Métodos privados bem nomeados e focados
class ItemsCapturedWidget extends StatelessWidget {
  // === CONFIGURAÇÕES ===
  
  /// Altura total do card
  /// Ajuste conforme necessário para sua UI
  static const double _cardHeight = 326.0;
  
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
  
  // === PROPRIEDADES ===
  
  /// Controller com os itens e total
  final HomeController controller;

  const ItemsCapturedWidget({
    super.key,
    required this.controller,
  });

  // === BUILD ===
  
  @override
  Widget build(BuildContext context) {
    final items = controller.items;
    final total = controller.total;
    final hasItems = items.isNotEmpty;

    return Container(
      height: _cardHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: _cardHorizontalMargin,
        vertical: _cardVerticalMargin,
      ),
      decoration: _buildCardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(items.length),
          _buildDivider(),
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

  // === DECORAÇÃO ===
  
  /// Decoração do card principal
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_cardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: _cardShadowBlur,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  /// Divisor sutil entre seções
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  // === HEADER ===
  
  /// Header com título e badge de contagem
  Widget _buildHeader(int itemCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(),
          if (itemCount > 0) _buildCountBadge(itemCount),
        ],
      ),
    );
  }

  /// Título do card
  Widget _buildTitle() {
    return const Text(
      "Itens Capturados",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
    );
  }

  /// Badge com contador de itens
  Widget _buildCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF36607).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF36607).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        _getCountLabel(count),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF36607),
        ),
      ),
    );
  }

  /// Retorna label pluralizada
  String _getCountLabel(int count) {
    return '$count ${count == 1 ? 'item' : 'itens'}';
  }

  // === ESTADO VAZIO ===
  
  /// Estado vazio com ícone e mensagem
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(),
            const SizedBox(height: 16),
            _buildEmptyTitle(),
            const SizedBox(height: 8),
            _buildEmptySubtitle(),
          ],
        ),
      ),
    );
  }

  /// Ícone do estado vazio
  Widget _buildEmptyIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.shopping_basket_outlined,
        size: 30,
        color: Colors.grey.shade400,
      ),
    );
  }

  /// Título do estado vazio
  Widget _buildEmptyTitle() {
    return Text(
      "Nenhum item ainda",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Subtítulo do estado vazio
  Widget _buildEmptySubtitle() {
    return Text(
      "Capture preços com a câmera\nou adicione manualmente",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 10,
        height: 1.4,
      ),
    );
  }

  // === LISTA DE ITENS ===
  
  /// Lista de itens com scroll interno e animações
  Widget _buildItemsList(List<CapturedItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: _itemSpacing),
      itemBuilder: (context, index) => _buildAnimatedItem(items[index], index),
    );
  }

  /// Item com animação de entrada
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

  /// Transição animada do item (fade + slide)
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

  // === FOOTER ===
  
  /// Footer com total e botão de limpar
  Widget _buildFooter(double total, bool hasItems) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  /// Decoração do footer
  BoxDecoration _buildFooterDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(_cardBorderRadius),
        bottomRight: Radius.circular(_cardBorderRadius),
      ),
    );
  }

  /// Seção do total acumulado
  Widget _buildTotalSection(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Total",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatCurrency(total),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFFEA6207),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  /// Botão de limpar todos os itens (compacto)
  Widget _buildClearButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleClearAll,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: _buildClearButtonDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_sweep_outlined,
                size: 20,
                color: Colors.red.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                "Limpar",
                style: TextStyle(
                  fontSize: 13,
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

  /// Decoração do botão limpar
  BoxDecoration _buildClearButtonDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.red.withOpacity(0.3),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  // === HANDLERS ===
  
  /// Handler para deletar item individual
  void _handleDeleteItem(int index) {
    controller.deleteItem(index);
    debugPrint('🗑️ [ItemsCaptured] Item $index deletado');
  }

  /// Handler para editar item (placeholder)
  void _handleEditItem(CapturedItem item) {
    // TODO: Implementar edição de item
    // Pode abrir um dialog para editar o nome ou valor
    debugPrint('✏️ [ItemsCaptured] Editar item: ${item.id}');
  }

  /// Handler para limpar todos os itens
  void _handleClearAll() {
    controller.clearAll();
    debugPrint('🗑️ [ItemsCaptured] Todos os itens limpos');
  }

  // === UTILITÁRIOS ===
  
  /// Formata valor como moeda brasileira
  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }
}
