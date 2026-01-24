import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'add_item_dialog.dart';

/// 📱 Header da Lista de Compras - COMPACTO (Ref. Imagem 2)
class ShoppingHeader extends StatelessWidget {
  const ShoppingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Top Bar (Laranja)
        Container(
          padding: EdgeInsets.only(
            left: 16.w, 
            right: 16.w, 
            top: MediaQuery.of(context).padding.top + 5.h, // Topo ajustado dinamicamente
            bottom: 4.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE8833A), // Laranja Clone #E8833A
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão Voltar (Seta Esquerda)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
              
              // Logo Centralizada
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36.sp, 
                    height: 36.sp, 
                    // Sem padding para a imagem ocupar tudo
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(190, 255, 255, 255),
                      shape: BoxShape.circle,
                    ),
                    // Transform scale para dar "zoom" na imagem se ela tiver borda transparente
                    child: Transform.scale(
                      scale: 1.3,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'CompreiSomei',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              // Espaço vazio para equilibrar (tamanho do ícone de voltar)
              SizedBox(width: 24.sp),
            ],
          ),
        ),

        // 2. Card Azul com Conteúdo
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h), // Padding bottom reduzido
          decoration: BoxDecoration(
            color: const Color(0xFF2C5461), // Azul Petróleo Escuro Clone #2C5461
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r),
            ), // Só borda arredondada no final
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
            children: [
              // Título
              Text(
                'Sua Lista de Compras',
                textAlign: TextAlign.left, // Alinhamento à esquerda
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.sp, // Reduzido levemente
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 2.h),
              
              // Subtítulo
              Text(
                'Adicione os produtos que deseja lembrar na hora das compras',
                textAlign: TextAlign.left, // Alinhamento à esquerda
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.7), // Mais suave conforme imagem
                  fontSize: 10.sp, // Aumentado
                ),
              ),
              
              SizedBox(height: 8.h), // Espaço reduzido
              
              // Categorias
              SizedBox(
                height: 110.h, // Altura reduzida para evitar overflow
                child: Consumer<ShoppingListController>(
                  builder: (context, controller, _) {
                    return Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: ShoppingListController.categories.map((category) {
                            final isSelected = controller.selectedCategory == category;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: _buildCategoryCard(
                                category: category,
                                isSelected: isSelected,
                                onTap: () => controller.selectCategory(category),
                                context: context,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🏷️ Card de categoria (Novo Design Compacto)
  Widget _buildCategoryCard({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    // Cálculo para caber 3 itens na tela
    final itemWidth = (MediaQuery.of(context).size.width - 60.w) / 3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        height: 105.h, // Altura reduzida
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w), // Padding reduzido
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white 
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected 
              ? Border.all(color: const Color(0xFFE8833A), width: 2) // Laranja se selecionado
              : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo com Imagem/Ícone
            Container(
              width: 40.sp, // Reduzido de 50
              height: 40.sp, // Reduzido de 50
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getCategoryColor(category).withOpacity(0.2),
                image: _getCategoryAsset(category) != null
                    ? DecorationImage(
                        image: AssetImage(_getCategoryAsset(category)!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _getCategoryAsset(category) == null
                  ? Icon(
                      _getCategoryIcon(category),
                      color: _getCategoryColor(category),
                      size: 20.sp, // Reduzido
                    )
                  : null,
            ),
            
            SizedBox(height: 4.h), // Espaço reduzido
            
            // Label "ESCOLHA"
            Text(
              'ESCOLHA',
              style: TextStyle(
                color: const Color(0xFF2C5461).withOpacity(0.6),
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            
            SizedBox(height: 2.h),
            
            // Nome da Categoria
            Text(
              category.replaceFirst('Lista de ', ''),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF2C5461),
                fontSize: 11.sp, // Levemente reduzido
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getCategoryAsset(String category) {
    if (category.contains('Alimentos')) return 'assets/images/alimento.png';
    if (category.contains('Bebidas')) return 'assets/images/bebidas.png';
    if (category.contains('Frios')) return 'assets/images/frios.png';
    if (category.contains('Higiene')) return 'assets/images/higiene.jpg';
    if (category.contains('Hortifruti')) return 'assets/images/hotfrut.png';
    if (category.contains('Limpeza')) return 'assets/images/limpeza.png';
    return null;
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('Alimentos')) return Icons.restaurant;
    if (category.contains('Limpeza')) return Icons.cleaning_services;
    if (category.contains('Higiene')) return Icons.soap;
    if (category.contains('Bebidas')) return Icons.local_drink;
    if (category.contains('Frios')) return Icons.ac_unit;
    if (category.contains('Hortifruti')) return Icons.eco;
    return Icons.list;
  }

  /// 🎨 Cores das categorias Clone
  Color _getCategoryColor(String category) {
    if (category.contains('Alimentos')) return const Color.fromARGB(255, 232, 91, 3); // Laranja queimado
    if (category.contains('Limpeza')) return const Color(0xFF5D9B9B); // Verde água (Teal)
    if (category.contains('Higiene')) return const Color(0xFFEBC866); // Amarelo mostarda
    if (category.contains('Bebidas')) return const Color(0xFF4A90E2); // Azul Bebidas
    if (category.contains('Frios')) return const Color(0xFF7BADD1); // Azul Frios/Gelo
    if (category.contains('Hortifruti')) return const Color(0xFF6DA34D); // Verde Hortifruti
    return const Color(0xFF999999);
  }
}