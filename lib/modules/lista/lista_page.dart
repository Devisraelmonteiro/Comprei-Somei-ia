import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/modules/lista/widgets/shopping_header.dart';
import 'package:comprei_some_ia/modules/lista/widgets/add_product_button.dart';
import 'package:comprei_some_ia/modules/lista/widgets/progress_indicators.dart';
import 'package:comprei_some_ia/modules/lista/widgets/shopping_list_view.dart';

/// 🛒 Página de Lista OTIMIZADA - Igual à segunda imagem
/// 
/// Layout:
/// - Header laranja + azul (com categorias)
/// - Container branco:
///   - Botão Adicionar Produto
///   - Progresso
///   - Lista
/// 
/// ✏️ EDITE AQUI EMBAIXO:
class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  // ═══════════════════════════════════════════════════════════
  // 🎨 CONFIGURAÇÕES EDITÁVEIS - MUDE AQUI!
  // ═══════════════════════════════════════════════════════════
  
  static const double _whiteContainerTopRadius = 20.0;
  static const double _spaceBetweenButtonAndProgress = 8.0;
  static const double _spaceBetweenProgressAndList = 8.0;
  static const double _bottomPaddingBase = 70.0;
  
  // ═══════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShoppingListController>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaBottom = mediaQuery.padding.bottom;
    final bottomPadding = _bottomPaddingBase + safeAreaBottom;

    return BaseScaffold(
      currentIndex: 1,
      child: Container(
        color: const Color(0xFFF68A07),
        child: SafeArea(
          top: false,    // ✅ Laranja INVADE o status bar
          bottom: false, // ✅ Footer fica visível
          child: Column(
            children: [
              // Padding do status bar
              SizedBox(height: MediaQuery.of(context).padding.top),
              
              // ✅ Header (laranja + azul com categorias)
              const ShoppingHeader(),
              
              // ✅ Container branco (botão + progresso + lista)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_whiteContainerTopRadius),
                    ),
                  ),
                  child: Column(
                    children: [
                      // ✅ Botão Adicionar Produto (AQUI, não no header)
                      const AddProductButton(),
                      
                      // Espaço
                      if (_spaceBetweenButtonAndProgress > 0)
                        SizedBox(height: _spaceBetweenButtonAndProgress),
                      
                      // ✅ Progresso
                      const ProgressIndicators(),
                      
                      // Espaço
                      if (_spaceBetweenProgressAndList > 0)
                        SizedBox(height: _spaceBetweenProgressAndList),
                      
                      // ✅ Lista
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding),
                          child: const ShoppingListView(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}