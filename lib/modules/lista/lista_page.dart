import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/modules/lista/controllers/shopping_list_controller.dart';
import 'package:comprei_some_ia/modules/lista/widgets/shopping_header.dart';
import 'package:comprei_some_ia/modules/lista/widgets/progress_indicators.dart';
import 'package:comprei_some_ia/modules/lista/widgets/shopping_list_view.dart';

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
              Container(
                color: const Color(0xFFF68A07),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      const ShoppingHeader(),
                      
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),
                              const ProgressIndicators(),
                              SizedBox(height: 8.h),
                              
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: hasItems ? 130.h + safeAreaBottom : 70.h + safeAreaBottom,
                                  ),
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
              
              // ✅ RODAPÉ FIXO
              if (hasItems)
                Positioned(
                  bottom: 60.h + safeAreaBottom,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            icon: Icons.share_outlined,
                            label: 'Compartilhar\nLista',
                            color: const Color(0xFF2196F3),
                            onTap: () => _handleShare(context, controller),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildButton(
                            icon: Icons.restaurant_menu_outlined,
                            label: 'Gerar\nReceitas',
                            color: const Color(0xFF4CAF50),
                            onTap: () => _handleRecipes(context, controller),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleShare(BuildContext context, ShoppingListController controller) {
    if (!controller.isFinalized) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('Finalizar lista', style: TextStyle(fontSize: 18.sp)),
          content: Text('Para compartilhar, finalize a lista.', style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(fontSize: 14.sp)),
            ),
            ElevatedButton(
              onPressed: () {
                controller.finalizeList();
                Navigator.pop(context);
                _showShareDialog(context, controller);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF68A07)),
              child: Text('Finalizar', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      );
      return;
    }
    _showShareDialog(context, controller);
  }

  void _showShareDialog(BuildContext context, ShoppingListController controller) {
    final emailController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.share_outlined, color: const Color(0xFF2196F3), size: 48.sp),
              SizedBox(height: 16.h),
              Text('Compartilhar Lista', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 24.h),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar', style: TextStyle(fontSize: 14.sp)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Digite um email', style: TextStyle(fontSize: 14.sp))),
                          );
                          return;
                        }
                        Navigator.pop(context);
                        await controller.shareList(emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✅ Lista enviada!', style: TextStyle(fontSize: 14.sp)),
                            backgroundColor: const Color(0xFF4CAF50),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2196F3)),
                      child: Text('Enviar', style: TextStyle(fontSize: 14.sp)),
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

  void _handleRecipes(BuildContext context, ShoppingListController controller) {
    if (!controller.isFinalized) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('Finalizar lista', style: TextStyle(fontSize: 18.sp)),
          content: Text('Finalize a lista para gerar receitas.', style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(fontSize: 14.sp)),
            ),
            ElevatedButton(
              onPressed: () async {
                await controller.finalizeList();
                Navigator.pop(context);
                _generateRecipes(context, controller);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF68A07)),
              child: Text('Finalizar', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      );
      return;
    }
    _generateRecipes(context, controller);
  }

  Future<void> _generateRecipes(BuildContext context, ShoppingListController controller) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final recipes = await controller.generateRecipes();
      Navigator.pop(context);
      
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Icon(Icons.restaurant_menu, color: const Color(0xFF4CAF50), size: 28.sp),
                    SizedBox(width: 12.w),
                    Text('Sugestões de Receitas', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 24.sp,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(20.w),
                  itemCount: recipes.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            recipe.content,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700,
                              height: 1.5,
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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e', style: TextStyle(fontSize: 14.sp))),
      );
    }
  }
}