// lib/shared/widgets/top_bar_widget.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

/// 🔝 TopBar - Header COMPACTO com textos COLADOS
/// 
/// Layout:
/// ┌─────────────────────────┐
/// │ 👤  Olá, Israel    🏢   │
/// │     Saldo               │
/// │     R$ 500,00      👁️  │
/// └─────────────────────────┘
class TopBarWidget extends StatefulWidget {
  final String userName;
  final double remaining;
  final String? userImagePath;
  final String? logoPath;

  const TopBarWidget({
    super.key,
    required this.userName,
    required this.remaining,
    this.userImagePath,
    this.logoPath = 'assets/images/logo.png', // Caminho padrão do logo
  });

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  // ==========================================================
  // ⚙️ CONTROLE VISUAL DO VIDRO (Edite aqui)
  // ==========================================================
  final double _blurIntensity = 1.0;    // 🌫️ Desfoque: Quanto maior, mais embaçado (Ex: 5.0 a 15.0)
  final double _fumeOpacity = 0.2;       // 🌑 Escuridão: Quanto maior, mais escuro (Ex: 0.1 a 0.5)
  // ==========================================================

  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // gradient: AppColors.headerGradient, // Comentado para usar imagem de fundo
        image: const DecorationImage(
          image: AssetImage('assets/images/fundoh.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.headerBorderRadius.r),
        ),
      ),
      clipBehavior: Clip.hardEdge, // ✅ Garante que o logo de fundo respeite as bordas
      child: Stack(
        children: [
          // 🏢 LOGO DE FUNDO (WATERMARK)
          /*
          if (widget.logoPath != null)
            Positioned(
              right: -40.w, // Alinhado à direita conforme solicitado anteriormente
              top: -0.h,   // "Sem margem top" (subindo para ajustar o corte)
              width: 150.w,  // Tamanho solicitado (Login Page)
              height: 150.h, // Tamanho solicitado (Login Page)
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  widget.logoPath!,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          */

          // 🌫️ CONTROLE FUME (Gradient Overlay) - Imitando ShoppingHeader
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),

          // 📄 CONTEÚDO ORIGINAL
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.headerPaddingHorizontal.w,
                AppSizes.headerPaddingTop.h,
                AppSizes.headerPaddingHorizontal.w,
                AppSizes.headerPaddingBottom.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 AVATAR
                  _buildAvatar(),
                  
                  SizedBox(width: AppSizes.headerAvatarToGreetingSpacing.w),
                  
                  // 📝 TEXTOS (COLADOS)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ROW: "Olá, Israel" + Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 👋 "Olá, Israel"
                            Text(
                              AppStrings.greeting(widget.userName),
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: AppSizes.greetingText.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            
                            // 🏢 Logo da empresa (agora alinhado à direita da primeira linha)
                            _buildLogo(),
                          ],
                        ),
                        
                        // ⚠️ SEM ESPAÇO entre "Olá" e "Saldo"
                        SizedBox(height: AppSizes.headerGreetingToSaldoSpacing.h),
                        
                        // 💼 "Saldo"
                        Text(
                          AppStrings.balanceLabel,
                          style: TextStyle(
                            color: const Color.fromARGB(183, 255, 255, 255),
                            fontSize: AppSizes.balanceLabel.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        // ⚠️ SEM ESPAÇO entre "Saldo" e valor
                        SizedBox(height: AppSizes.headerSaldoToValueSpacing.h),
                        
                        // ROW: "R$ 500,00" + Olhinho
                        Row(
                          children: [
                            // 💵 "R$ 500,00"
                            _buildBalanceValue(),
                            
                            // 👁️ Olhinho (posicionamento controlado internamente com Padding)
                            _buildEyeToggle(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 👤 Avatar com borda BRANCA e GROSSA
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        context.push('/profile');
      },
      child: Container(
        width: AppSizes.avatarSize.w,
        height: AppSizes.avatarSize.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteWithOpacity(0.2),
          border: Border.all(
            color: Colors.white, // ✅ BRANCA
            width: 1.0, // ✅ GROSSA (antes era 1.5)
          ),
          image: widget.userImagePath != null
              ? DecorationImage(
                  image: AssetImage(widget.userImagePath!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: widget.userImagePath == null
            ? Icon(
                Icons.person,
                color: AppColors.white,
                size: 30.sp,
              )
            : null,
      ),
    );
  }

  /// 🏢 Logo da empresa
  Widget _buildLogo() {
    if (widget.logoPath == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: AppSizes.eyeIconContainer.w,
      height: AppSizes.eyeIconContainer.w,
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        //shape: BoxShape.circle,
      ),
      //child: ClipOval(
        //child: Transform.scale(
          //scale: 2.0
          //, // ✅ ZOOM: aumenta o logo em 30% (ajuste conforme necessário)
          //child: Image.asset(
            //widget.logoPath!,
            //fit: BoxFit.cover, // ✅ cover para preencher todo o círculo
            //errorBuilder: (context, error, stackTrace) {
              // Se der erro ao carregar o logo, mostra um ícone placeholder
              //return Icon(
                //Icons.business,
                //color: AppColors.primary,
                //size: AppSizes.eyeIconContainer.sp,
             // );
            //},
          //),
        //),
      );
    
  }

  /// 💵 Valor do saldo
  Widget _buildBalanceValue() {
    final isNegative = widget.remaining < 0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        showBalance
            ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
            : "R\$ ••••••",
        key: ValueKey(showBalance),
        style: TextStyle(
          color: isNegative
              ? const Color(0xFFFF6B6B) // vermelho quando saldo abaixo de zero
              : const Color.fromARGB(255, 255, 255, 255),
          fontSize: AppSizes.balanceValue.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  /// 👁️ Botão toggle (COM círculo editável)
  Widget _buildEyeToggle() {
    // 🎯 AJUSTE O TAMANHO DO CÍRCULO AQUI:
    final double circleSize = 20.w; // ← MUDE ESTE VALOR (ex: 24.w, 30.w, 35.w)
    final double iconSize = 18.sp;  // ← MUDE O TAMANHO DO ÍCONE (ex: 14.sp, 18.sp, 20.sp)
    
    return Padding(
      // 🎯 AJUSTE A POSIÇÃO DO OLHINHO AQUI:
      // 
      // left: move para DIREITA (valores positivos) ou ESQUERDA (valores negativos)
      // top: move para BAIXO (valores positivos) ou CIMA (valores negativos)
      // right: espaço à direita
      // bottom: espaço embaixo
      //
      // EXEMPLOS:
      // - EdgeInsets.only(left: 8.w) → move 8px para DIREITA
      // - EdgeInsets.only(left: -4.w) → move 4px para ESQUERDA (mais perto do valor)
      // - EdgeInsets.only(top: 2.h) → move 2px para BAIXO
      // - EdgeInsets.only(top: -2.h) → move 2px para CIMA
      // - EdgeInsets.only(left: 8.w, top: -2.h) → 8px DIREITA + 2px CIMA
      //
      padding: EdgeInsets.only(
        left: 8.w,  // Espaço à esquerda (distância do valor)
        top: 0.h,   // Ajuste vertical (negativo = sobe, positivo = desce)
      ),
      child: GestureDetector(
        onTap: () => setState(() => showBalance = !showBalance),
        child: Container(
          width: circleSize,   // ← TAMANHO DO CÍRCULO (width)
          height: circleSize,  // ← TAMANHO DO CÍRCULO (height)
          decoration: BoxDecoration(
            color: AppColors.whiteWithOpacity(0.2), // ← COR DO FUNDO (pode mudar a opacidade)
            shape: BoxShape.circle,
          ),
          child: Icon(
            showBalance 
                ? Icons.visibility_outlined 
                : Icons.visibility_off_outlined,
            color: const Color.fromARGB(255, 255, 255, 255),
            size: iconSize, // ← TAMANHO DO ÍCONE
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 ESTRUTURA DO HEADER (ATUALIZADA!)
// ═══════════════════════════════════════════════════════════════
//
// Row (horizontal):
//   - Avatar (40x40) com BORDA BRANCA GROSSA (3.0)
//   - Spacing (12px)
//   - Column (vertical) - TEXTOS COLADOS:
//       - Row: "Olá, Israel" + Logo 🏢
//       - Spacing = 0 ← SEM ESPAÇO
//       - "Saldo"
//       - Spacing = 0 ← SEM ESPAÇO
//       - Row: "R$ 500,00" + Olhinho 👁️
//
// ═══════════════════════════════════════════════════════════════
//
// 🎯 AJUSTES DISPONÍVEIS NO OLHINHO:
//
// No método _buildEyeToggle() (linha ~215):
//
// ✅ circleSize = 28.w  ← Tamanho do CÍRCULO (aumente/diminua)
// ✅ iconSize = 16.sp   ← Tamanho do ÍCONE dentro do círculo
// ✅ color: AppColors.whiteWithOpacity(0.2) ← Cor de fundo (mude opacidade)
// ✅ left: 8.w  ← Distância do valor R$
// ✅ top: 0.h   ← Posição vertical
//
// EXEMPLOS DE TAMANHOS:
// - Círculo PEQUENO: circleSize = 24.w, iconSize = 14.sp
// - Círculo MÉDIO: circleSize = 28.w, iconSize = 16.sp (atual)
// - Círculo GRANDE: circleSize = 35.w, iconSize = 20.sp
//
// ═══════════════════════════════════════════════════════════════
//
// 📸 COMO USAR:
//
// TopBarWidget(
//   userName: 'Israel',
//   remaining: 500.00,
//   userImagePath: 'assets/images/user.png', // opcional
//   logoPath: 'assets/images/logo.png', // seu logo!
// )
//
// ═══════════════════════════════════════════════════════════════
