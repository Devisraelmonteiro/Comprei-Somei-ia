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
                    width: 25.sp,
                    height: 25.sp,
                    padding: EdgeInsets.all(4.sp),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'CompreiSomei',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
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

        // 2. Card Azul com Conteúdo + Botão
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Card Azul
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 18.h), // Sem margem lateral
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 45.h), // Padding aumentado para ficar "roomy"
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
                      fontSize: 20.sp, // Aumentado conforme imagem
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 4.h),
                  
                  // Subtítulo
                  Text(
                    'Adicione os produtos que deseja lembrar na hora das compras',
                    textAlign: TextAlign.left, // Alinhamento à esquerda
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7), // Mais suave conforme imagem
                      fontSize: 8.sp, // Aumentado
                    ),
                  ),
                  
                  SizedBox(height: 12.h), // Mais espaço antes das categorias
                  
                  // Categorias
                  SizedBox(
                    height: 32.h, // Altura confortável
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
                                  child: _buildCategoryPill(
                                    category: category,
                                    isSelected: isSelected,
                                    onTap: () => controller.selectCategory(category),
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

            // Botão "Adicionar Produto" (Sobreposto)
            Positioned(
              bottom: 0, 
              child: _buildAddButton(context),
            ),
          ],
        ),
      ],
    );
  }

  // _buildTopBar removido

  // _buildCompactHeaderContent removido/integrado no build

  /// 🏷️ Pill de categoria Compacto
  Widget _buildCategoryPill({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w, // Mais largo conforme imagem
          vertical: 6.h,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _getCategoryColor(category),
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected ? Border.all(color: AppColors.white, width: 1.5) : null, // Borda branca se selecionado
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(category),
              color: category == 'Higiene' ? const Color(0xFF5A4A10) : AppColors.white,
              size: 16.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              category,
              style: TextStyle(
                color: category == 'Higiene' ? const Color(0xFF5A4A10) : AppColors.white, // Texto escuro só no amarelo
                fontSize: 12.sp,
                fontWeight: FontWeight.w700, // Mais bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ➕ Botão adicionar produto Compacto
  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AddItemDialog(),
      ),
      child: Container(
        width: 160.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE8833A), // Laranja igual ao topo
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Adicionar Produto',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Alimentos':
        return Icons.restaurant;
      case 'Limpeza':
        return Icons.cleaning_services;
      case 'Higiene':
        return Icons.soap;
      case 'Bebidas':
        return Icons.local_drink;
      case 'Frios':
        return Icons.ac_unit;
      case 'Hortifruti':
        return Icons.eco;
      default:
        return Icons.list;
    }
  }

  /// 🎨 Cores das categorias Clone
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Alimentos':
        return const Color(0xFFD9722E); // Laranja queimado
      case 'Limpeza':
        return const Color(0xFF5D9B9B); // Verde água (Teal)
      case 'Higiene':
        return const Color(0xFFEBC866); // Amarelo mostarda
      case 'Bebidas':
        return const Color(0xFF4A90E2); // Azul Bebidas
      case 'Frios':
        return const Color(0xFF7BADD1); // Azul Frios/Gelo
      case 'Hortifruti':
        return const Color(0xFF6DA34D); // Verde Hortifruti
      default:
        return const Color(0xFF999999);
    }
  }
}