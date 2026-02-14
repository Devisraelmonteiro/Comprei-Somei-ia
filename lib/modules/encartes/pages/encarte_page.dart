import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import '../controllers/encarte_controller.dart';
import '../widgets/encarte_card.dart';
import '../widgets/add_encarte_modal.dart';
import '../widgets/empty_state_widget.dart';

class EncartePage extends StatelessWidget {
  const EncartePage({super.key});

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddEncarteModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 2, // Índice de Encartes
      child: Stack(
        children: [
          // 1. Imagem de Fundo (Banner)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280.h,
            child: Stack(
              children: [
                Container(color: Colors.black),
                Image.asset(
                  'assets/images/encartes.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Gradiente
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Header Content (Voltar, Logo, Título, Add Button)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
                          ),
                        ),
                        const Spacer(),
                        // Botão Adicionar (No Header para fácil acesso)
                        GestureDetector(
                          onTap: () => _showAddModal(context),
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          backgroundImage: const AssetImage('assets/images/logo.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    
                    // CONTROLE DE POSIÇÃO DO TÍTULO "Encartes"
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0.w,  // Edite aqui: Esquerda
                        top: 0.h,   // Edite aqui: Cima
                        right: 0.w, // Edite aqui: Direita
                        bottom: 0.h // Edite aqui: Baixo
                      ),
                      child: Text(
                        'Encartes',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Conteúdo Principal (Folha Sobreposta)
          Positioned.fill(
            top: 160.h,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Consumer<EncarteController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.encartes.isEmpty) {
                    return EmptyStateWidget(
                      onAction: () => _showAddModal(context),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.loadEncartes,
                    color: const Color(0xFF007AFF),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 20.h, bottom: 100.h),
                      itemCount: controller.encartes.length,
                      itemBuilder: (context, index) {
                        final encarte = controller.encartes[index];
                        return EncarteCard(encarte: encarte);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
