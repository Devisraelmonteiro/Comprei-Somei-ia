import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/modules/lista/widgets/shopping_header.dart';
import 'package:comprei_some_ia/modules/lista/widgets/progress_indicators.dart';
import 'package:comprei_some_ia/modules/lista/widgets/shopping_list_view.dart';
import 'package:comprei_some_ia/modules/lista/widgets/add_item_dialog.dart';

/// 🛒 Lista Page COMPLETA - VERSÃO 2025
class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShoppingListController>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return BaseScaffold(
      currentIndex: 1,
      child: Consumer<ShoppingListController>(
        builder: (context, controller, _) {
          final hasItems = controller.hasItems;
          
          return Stack(
            children: [
              // 1. Fundo Geral (iOS Grouped Background)
              Container(color: const Color(0xFFF2F2F7)),

              // 2. Conteúdo Principal
              Column(
                children: [
                  // Header (Já inclui SafeArea top)
                  const ShoppingHeader(),
                  
                  // Área Rolável (Indicadores + Lista)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Indicadores de Progresso
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: const ProgressIndicators(),
                        ),

                        // Título da Lista e Botão Adicionar
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.selectedCategory,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1C1C1E),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              SizedBox(width: 10.w),

                              // Botão Adicionar (Estilo Pill Outlined)
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => const AddItemDialog(),
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFF68A07),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: const Color(0xFFF68A07),
                                          size: 18.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Adicionar Produto',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFF68A07),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Lista de Produtos (Estilo Inset Grouped)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 120.h + safeAreaBottom),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                // Lista com Scroll Interno
                                const Expanded(
                                  child: ShoppingListView(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // 3. Botões de Ação Flutuantes (Apple Style)
              if (hasItems)
                Positioned(
                  bottom: 70.h + safeAreaBottom, // Mais perto do footer (AppSizes.bottomNavHeight ~56h + 4h de margem)
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Botão Compartilhar
                          _buildFloatingActionButton(
                            context: context,
                            icon: Icons.share_rounded,
                            label: 'Compartilhar',
                            backgroundColor: const Color(0xFF4CAF50), // Verde
                            onTap: () => _handleShare(context, controller),
                          ),
                          
                          SizedBox(width: 12.w), // Espaço reduzido entre botões
                          
                          // Botão Receitas
                          _buildFloatingActionButton(
                            context: context,
                            icon: Icons.restaurant_menu_rounded,
                            label: 'Gerar Receitas',
                            backgroundColor: const Color(0xFF006064), // Azul Petróleo
                            onTap: () => _handleRecipes(context, controller),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r), // Mais compacto
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h), // Padding vertical reduzido para 4
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18.sp, color: Colors.white), // Ícone menor e branco
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp, // Fonte menor
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texto branco
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔄 FUNÇÃO: COMPARTILHAR LISTA
  // Verifica se lista está finalizada antes de compartilhar
  // ═══════════════════════════════════════════════════════════════════════
  void _handleShare(BuildContext context, ShoppingListController controller) {
    if (!controller.isFinalized) {
      // ───────────────────────────────────────────────────────────────────
      // ⚠️ ALERTA: Lista não finalizada
      // ───────────────────────────────────────────────────────────────────
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r), // 🔵 BORDAS DO DIALOG
          ),
          title: Text(
            'Finalizar lista',
            style: TextStyle(fontSize: 18.sp), // 📝 TÍTULO DO ALERTA
          ),
          content: Text(
            'Para compartilhar, finalize a lista.',
            style: TextStyle(fontSize: 14.sp), // 📝 MENSAGEM DO ALERTA
          ),
          actions: [
            // Botão "Cancelar"
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            // Botão "Finalizar" (Laranja)
            ElevatedButton(
              onPressed: () {
                controller.finalizeList();
                Navigator.pop(context);
                _showShareDialog(context, controller);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF68A07), // 🟠 COR LARANJA
              ),
              child: Text(
                'Finalizar',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      );
      return;
    }
    _showShareDialog(context, controller);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📧 MODAL: COMPARTILHAR LISTA POR EMAIL
  // ═══════════════════════════════════════════════════════════════════════
  void _showShareDialog(BuildContext context, ShoppingListController controller) {
    final emailController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Para subir com teclado
        ),
        child: Container(
          padding: EdgeInsets.all(24.w), // 📏 PADDING INTERNO
          decoration: BoxDecoration(
            color: Colors.white, // 🎨 FUNDO BRANCO
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r), // 🔵 BORDAS SUPERIORES ARREDONDADAS
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ───────────────────────────────────────────────────────────
              // 🎯 ÍCONE DE COMPARTILHAMENTO (Azul)
              // ───────────────────────────────────────────────────────────
              Icon(
                Icons.share_outlined,
                color: const Color(0xFF2196F3), // 🔵 COR AZUL
                size: 48.sp, // 📏 TAMANHO DO ÍCONE
              ),
              SizedBox(height: 16.h),
              
              // ───────────────────────────────────────────────────────────
              // 📝 TÍTULO DO MODAL
              // ───────────────────────────────────────────────────────────
              Text(
                'Compartilhar Lista',
                style: TextStyle(
                  fontSize: 20.sp, // 📝 TAMANHO DA FONTE
                  fontWeight: FontWeight.bold, // 📝 PESO DA FONTE
                ),
              ),
              SizedBox(height: 24.h),
              
              // ───────────────────────────────────────────────────────────
              // 📧 CAMPO DE EMAIL
              // ───────────────────────────────────────────────────────────
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r), // 🔵 BORDAS ARREDONDADAS
                  ),
                  prefixIcon: const Icon(Icons.email_outlined), // 📧 ÍCONE DE EMAIL
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 24.h),
              
              // ───────────────────────────────────────────────────────────
              // 🔘 BOTÕES DE AÇÃO (Cancelar / Enviar)
              // ───────────────────────────────────────────────────────────
              Row(
                children: [
                  // Botão "Cancelar" (Outlined)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  
                  // Botão "Enviar" (Azul)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Digite um email',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          );
                          return;
                        }
                        Navigator.pop(context);
                        await controller.shareList(emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '✅ Lista enviada!',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            backgroundColor: const Color(0xFF4CAF50), // 🟢 VERDE SUCESSO
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3), // 🔵 COR AZUL
                      ),
                      child: Text(
                        'Enviar',
                        style: TextStyle(fontSize: 14.sp),
                      ),
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

  // ═══════════════════════════════════════════════════════════════════════
  // 🍳 FUNÇÃO: GERAR RECEITAS
  // Verifica se lista está finalizada antes de gerar receitas
  // ═══════════════════════════════════════════════════════════════════════
  void _handleRecipes(BuildContext context, ShoppingListController controller) {
    if (!controller.isFinalized) {
      // ───────────────────────────────────────────────────────────────────
      // ⚠️ ALERTA: Lista não finalizada
      // ───────────────────────────────────────────────────────────────────
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r), // 🔵 BORDAS DO DIALOG
          ),
          title: Text(
            'Finalizar lista',
            style: TextStyle(fontSize: 18.sp),
          ),
          content: Text(
            'Finalize a lista para gerar receitas.',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            // Botão "Cancelar"
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
            // Botão "Finalizar" (Laranja)
            ElevatedButton(
              onPressed: () async {
                await controller.finalizeList();
                Navigator.pop(context);
                _generateRecipes(context, controller);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF68A07), // 🟠 COR LARANJA
              ),
              child: Text(
                'Finalizar',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      );
      return;
    }
    _generateRecipes(context, controller);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🍳 MODAL: EXIBIR RECEITAS GERADAS
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _generateRecipes(BuildContext context, ShoppingListController controller) async {
    // ───────────────────────────────────────────────────────────────────
    // ⏳ LOADING: Gerando receitas...
    // ───────────────────────────────────────────────────────────────────
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final recipes = await controller.generateRecipes();
      Navigator.pop(context); // Fecha loading
      
      // ───────────────────────────────────────────────────────────────────
      // 🍽️ MODAL: Lista de Receitas
      // ───────────────────────────────────────────────────────────────────
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8, // 📏 80% da altura da tela
          decoration: BoxDecoration(
            color: Colors.white, // 🎨 FUNDO BRANCO
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r), // 🔵 BORDAS SUPERIORES ARREDONDADAS
            ),
          ),
          child: Column(
            children: [
              // ───────────────────────────────────────────────────────────
              // 🎯 CABEÇALHO DO MODAL (Título + Botão Fechar)
              // ───────────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    // Ícone de restaurante (Verde)
                    Icon(
                      Icons.restaurant_menu,
                      color: const Color(0xFF4CAF50), // 🟢 COR VERDE
                      size: 28.sp,
                    ),
                    SizedBox(width: 12.w),
                    
                    // Título "Sugestões de Receitas"
                    Text(
                      'Sugestões de Receitas',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    
                    // Botão "X" para fechar
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 24.sp,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1), // Linha divisória
              
              // ───────────────────────────────────────────────────────────
              // 📋 LISTA DE RECEITAS (Scrollável)
              // ───────────────────────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(20.w), // 📏 PADDING DA LISTA
                  itemCount: recipes.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h), // 📏 Espaço entre itens
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Container(
                      padding: EdgeInsets.all(16.w), // 📏 PADDING DO CARD
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50, // 🎨 FUNDO CINZA CLARO
                        borderRadius: BorderRadius.circular(12.r), // 🔵 BORDAS ARREDONDADAS
                        border: Border.all(
                          color: Colors.grey.shade200, // 🎨 BORDA CINZA
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─────────────────────────────────────────────
                          // 📝 TÍTULO DA RECEITA (Verde)
                          // ─────────────────────────────────────────────
                          Text(
                            recipe.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4CAF50), // 🟢 COR VERDE
                            ),
                          ),
                          SizedBox(height: 12.h),
                          
                          // ─────────────────────────────────────────────
                          // 📄 CONTEÚDO DA RECEITA (Cinza)
                          // ─────────────────────────────────────────────
                          Text(
                            recipe.content,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700, // 🎨 COR CINZA ESCURO
                              height: 1.5, // 📏 ALTURA DA LINHA
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Fecha loading em caso de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro: $e',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );
    }
  }
}
