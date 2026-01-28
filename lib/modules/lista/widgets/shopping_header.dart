import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';

/// 📱 Header da Lista de Compras - VERSÃO BANNER HEADER
class ShoppingHeader extends StatelessWidget {
  const ShoppingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F7), // Fundo estilo iOS Grouped
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header com Banner (Topo Total)
          Stack(
            children: [
              // Imagem de Fundo (Banner)
              SizedBox(
                height: 150.h, // Altura reduzida para compactar (antes 220)
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.r),
                    bottomRight: Radius.circular(0.r),
                  ),
                  child: Image.asset(
                    'assets/images/compras.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Gradiente para legibilidade
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.r),
                      bottomRight: Radius.circular(0.r),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // Conteúdo do Header (SafeArea)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Barra Superior (Voltar + Logo)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18.sp),
                              ),
                            ),
                            const Spacer(),
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.white.withOpacity(0.9),
                              backgroundImage: const AssetImage('assets/images/logo.png'),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Títulos Dentro do Banner
                        Text(
                          'Lista de Compras',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

         

          // 3. Categorias (Cards Estilo Imagem de Referência)
          SizedBox(
            height: 110.h, // Altura ajustada
            child: Consumer<ShoppingListController>(
              builder: (context, controller, _) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: ShoppingListController.categories.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final category = ShoppingListController.categories[index];
                    
                    // Cálculo para exibir exatamente 3 itens
                    // Largura total - Padding lateral (16*2) - Espaçamento entre itens (12*2 para 3 itens)
                    final double screenWidth = MediaQuery.of(context).size.width;
                    final double availableWidth = screenWidth - (32.w); 
                    final double itemWidth = (availableWidth - (24.w)) / 3;

                    return _buildCategoryCard(
                      category: category,
                      isSelected: controller.selectedCategory == category,
                      onTap: () => controller.selectCategory(category),
                      width: itemWidth,
                    );
                  },
                );
              },
            ),
          ),
          
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  /// 🏷️ Card Categoria (Estilo Referência)
  Widget _buildCategoryCard({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width, // Largura dinâmica
        padding: EdgeInsets.all(8.w), // Padding interno reduzido
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r), // ~20px border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          // Borda sutil apenas para destacar seleção, sem mudar tamanho
          border: isSelected 
              ? Border.all(color: Colors.grey[300]!, width: 1.5) 
              : Border.all(color: const Color.fromARGB(21, 131, 131, 130), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Imagem Circular
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(_getCategoryImage(category)),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            
            // Texto Central "ESCOLHA"
            Text(
              "ESCOLHA",
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600, // Regular
                color: const Color.fromARGB(138, 127, 127, 127), // Cinza médio
                letterSpacing: 0.4,
              ),
            ),
            
            // Botão Inferior (Pílula) - Sem efeito touch visual drástico
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // Cinza muito claro fixo
                borderRadius: BorderRadius.circular(10.r), // ~8-12px radius
              ),
              child: Text(
                _formatCategoryName(category),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800], // Cinza escuro
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryImage(String category) {
    if (category.contains('Alimentos')) return 'assets/images/alimento.png';
    if (category.contains('Limpeza')) return 'assets/images/limpeza.png';
    if (category.contains('Higiene')) return 'assets/images/higiene.jpg';
    if (category.contains('Bebidas')) return 'assets/images/bebidas.png';
    if (category.contains('Frios')) return 'assets/images/frios.png';
    if (category.contains('Hortifruti')) return 'assets/images/hotfrut.png';
    return 'assets/images/logo.png';
  }

  String _formatCategoryName(String category) {
    return category.replaceAll('Lista de ', '');
  }
}
