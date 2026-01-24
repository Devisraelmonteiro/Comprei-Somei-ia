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
              // ═══════════════════════════════════════════════════════════
              // 🎨 FUNDO BRANCO GERAL DA PÁGINA
              // ═══════════════════════════════════════════════════════════
              Container(color: Colors.white),

              // ═══════════════════════════════════════════════════════════
              // 🟠 FUNDO LARANJA DO CABEÇALHO
              // Cor: #FFE8833A (laranja primário)
              // Posição: Fixo no topo, altura 150.h
              // ═══════════════════════════════════════════════════════════
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 80.h, // ⚠️ Ajustar altura se necessário
                child: Container(color: const Color(0xFFE8833A)), // 🟠 COR DO HEADER
              ),

              // ═══════════════════════════════════════════════════════════
              // 📋 CONTEÚDO PRINCIPAL DA PÁGINA
              // ═══════════════════════════════════════════════════════════
              Positioned.fill(
                child: Column(
                  children: [
                    // ───────────────────────────────────────────────────────
                    // 📌 HEADER (Título "Sua Lista de Compras" + Categorias)
                    // Widget: shopping_header.dart
                    // Contém: Título, subtítulo, botões de categoria
                    // ───────────────────────────────────────────────────────
                    const ShoppingHeader(),
                    
                    // ───────────────────────────────────────────────────────
                    // 📊 ÁREA DE CONTEÚDO (Barras de Progresso + Lista)
                    // Fundo: Branco
                    // ───────────────────────────────────────────────────────
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 16.h), // 📏 Espaçamento superior
                          
                          // ───────────────────────────────────────────────
                          // 📊 BARRAS DE PROGRESSO
                          // Widget: progress_indicators.dart
                          // Mostra: "Alimentos Concluídos: 50%" etc
                          // ───────────────────────────────────────────────
                          const ProgressIndicators(),
                          
                          SizedBox(height: 16.h), // 📏 Espaçamento superior
                          
                          // ───────────────────────────────────────────────
                          // 📌 TÍTULO DA LISTA (Categoria Selecionada) + Botão Adicionar
                          // ───────────────────────────────────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Título da Categoria
                                Text(
                                  controller.selectedCategory, // Ex: "Alimentos", "Limpeza"
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                
                                // Botão Adicionar Produto
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => const AddItemDialog(),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18.r),
                                      border: Border.all(
                                        color: const Color(0xFFE8833A),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: const Color(0xFFE8833A),
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Adicionar',
                                          style: TextStyle(
                                            color: const Color(0xFFE8833A),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8.h), // 📏 Espaçamento entre título e lista
                          
                          // ───────────────────────────────────────────────
                          // 📝 LISTA DE PRODUTOS
                          // Widget: shopping_list_view.dart
                          // Contém: arroz, feijão, maarn (com checkboxes)
                          // ───────────────────────────────────────────────
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                // 📏 Espaçamento inferior (para evitar colisão com botões + NavBar)
                                bottom: hasItems ? 120.h + safeAreaBottom : 100.h + safeAreaBottom,
                              ),
                              child: const ShoppingListView(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // ═══════════════════════════════════════════════════════════
              // 🔘 BOTÕES FIXOS NO RODAPÉ (Compartilhar + Gerar Receitas)
              // Posição: Acima da BottomNavBar
              // ═══════════════════════════════════════════════════════════
              if (hasItems)
                Positioned(
                  bottom: 70.h + safeAreaBottom, // 📍 Distância do fundo (acima da NavBar)
                  left: 16.w,   // 📍 Margem esquerda
                  right: 16.w,  // 📍 Margem direita
                  child: Row(
                    children: [
                      // ───────────────────────────────────────────────────
                      // 🟠 BOTÃO "COMPARTILHAR"
                      // Cor: Laranja (#FFE8833A)
                      // Ícone: share_outlined
                      // ───────────────────────────────────────────────────
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.share_outlined,
                          label: 'Compartilhar',
                          color: const Color.fromARGB(255, 2, 115, 12), // 🟠 COR LARANJA
                          onTap: () => _handleShare(context, controller),
                        ),
                      ),
                      
                      SizedBox(width: 18.w), // 📏 Espaçamento entre botões
                      
                      // ───────────────────────────────────────────────────
                      // 🔵 BOTÃO "GERAR RECEITAS"
                      // Cor: Azul Petróleo (#FF2C5461)
                      // Ícone: restaurant_menu
                      // ───────────────────────────────────────────────────
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.restaurant_menu,
                          label: 'Gerar Receitas',
                          color: const Color(0xFF2C5461), // 🔵 COR AZUL PETRÓLEO
                          onTap: () => _handleRecipes(context, controller),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🏗️ CONSTRUTOR DE BOTÕES DE AÇÃO (Compartilhar / Gerar Receitas)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 35.h, // Altura reduzida (era 50)
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r), // Pílula
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp), // Ícone levemente menor
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp, // Fonte levemente menor
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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