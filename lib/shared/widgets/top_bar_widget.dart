// lib/shared/widgets/top_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

/// 🔝 TopBar - Header COMPACTO igual segunda imagem
/// 
/// Características:
/// - Fonte do saldo MENOR (metade)
/// - Layout compacto em ROW (horizontal)
/// - 70% do scanner dentro do laranja
/// 
/// 📝 COMO AJUSTAR:
/// - Altura total: padding top + bottom
/// - Tamanho avatar: _buildAvatar() → width/height
/// - Fonte "Olá, Israel": linha 72 → fontSize
/// - Fonte "Saldo": linha 82 → fontSize
/// - Fonte "R$ 500,00": linha 144 → fontSize
/// - Tamanho olhinho: _buildEyeToggle() → width/height
class TopBarWidget extends StatefulWidget {
  final String userName;
  final double remaining;
  final String? userImagePath;

  const TopBarWidget({
    super.key,
    required this.userName,
    required this.remaining,
    this.userImagePath,
  });

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(
          // 📐 BORDA INFERIOR DO HEADER
          // Aumentar = mais arredondado
          // Diminuir = menos arredondado
          bottom: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          // 📏 PADDING DO HEADER (controla altura total)
          // LTRB = Left, Top, Right, Bottom
          // Top: espaço no topo
          // Bottom: espaço embaixo (afeta onde scanner começa)
          padding: EdgeInsets.fromLTRB(
            16.w,  // 🔹 Margem esquerda
            4.h,   // 🔹 Margem topo (DIMINUIR = header mais compacto)
            16.w,  // 🔹 Margem direita
            100.h,  // 🔹 Margem fundo (AUMENTAR = mais espaço para scanner)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 AVATAR
              _buildAvatar(),
              
              // 📏 ESPAÇO ENTRE AVATAR E TEXTOS
              // Aumentar = mais espaço
              // Diminuir = mais compacto
              SizedBox(width: 12.w),
              
              // 📝 TEXTOS (Olá, Israel + Saldo + Valor)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👋 "Olá, Israel"
                    Text(
                      AppStrings.greeting(widget.userName),
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        // 📝 FONTE "OLÁ, ISRAEL"
                        // Aumentar = texto maior
                        // Diminuir = texto menor
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    // 📏 ESPAÇO ENTRE "OLÁ" E "SALDO"
                    // Aumentar = mais espaço vertical
                    // Diminuir = mais compacto
                    SizedBox(height: 1.h),
                    
                    // 💼 "Saldo"
                    Text(
                      AppStrings.balanceLabel,
                      style: TextStyle(
                        color: AppColors.whiteWithOpacity(0.9),
                        // 📝 FONTE "SALDO"
                        // Aumentar = texto maior
                        // Diminuir = texto menor
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    // 💵 "R$ 500,00"
                    _buildBalanceValue(),
                  ],
                ),
              ),
              
              // 👁️ OLHINHO (toggle visibilidade)
              _buildEyeToggle(),
            ],
          ),
        ),
      ),
    );
  }

  /// 👤 Avatar do usuário
  /// 
  /// 📝 COMO AJUSTAR:
  /// - Tamanho: width/height (linha 120)
  /// - Borda: width na linha 127
  /// - Ícone: size na linha 140
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Container(
        // 📐 TAMANHO DO AVATAR
        // Aumentar = avatar maior
        // Diminuir = avatar menor
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteWithOpacity(0.2),
          border: Border.all(
            color: AppColors.whiteWithOpacity(0.3),
            // 📏 ESPESSURA DA BORDA DO AVATAR
            // Aumentar = borda mais grossa
            // Diminuir = borda mais fina
            width: 1.5,
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
                // 📐 TAMANHO DO ÍCONE (quando não tem foto)
                // Aumentar = ícone maior
                // Diminuir = ícone menor
                size: 30.sp,
              )
            : null,
      ),
    );
  }

  /// 💵 Valor do saldo com animação
  /// 
  /// 📝 COMO AJUSTAR:
  /// - Fonte: fontSize na linha 144
  /// - Peso: fontWeight na linha 145
  Widget _buildBalanceValue() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        showBalance
            ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
            : "R\$ ••••••",
        key: ValueKey(showBalance),
        style: TextStyle(
          // 📝 FONTE "R$ 500,00" (PRINCIPAL!)
          // Aumentar = número maior
          // Diminuir = número menor
          // VALOR ATUAL: 18sp (metade do original)
          fontSize: 15.sp,
          // 📝 PESO DA FONTE
          // w800 = extra bold (negrito forte)
          // w600 = semi bold
          // w400 = normal
          fontWeight: FontWeight.w800,
          color: AppColors.white,
        ),
      ),
    );
  }

  /// 👁️ Botão para mostrar/ocultar saldo
  /// 
  /// 📝 COMO AJUSTAR:
  /// - Tamanho botão: width/height na linha 207
  /// - Tamanho ícone: size na linha 218
  Widget _buildEyeToggle() {
    return GestureDetector(
      onTap: () => setState(() => showBalance = !showBalance),
      child: Container(
        // 📐 TAMANHO DO CÍRCULO DO OLHINHO
        // Aumentar = botão maior
        // Diminuir = botão menor
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: AppColors.whiteWithOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          showBalance 
              ? Icons.visibility_outlined 
              : Icons.visibility_off_outlined,
          color: AppColors.white,
          // 📐 TAMANHO DO ÍCONE DO OLHINHO
          // Aumentar = ícone maior
          // Diminuir = ícone menor
          size: 16.sp,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 RESUMO DE AJUSTES RÁPIDOS
// ═══════════════════════════════════════════════════════════════
//
// 🎯 ALTURA DO HEADER:
// - Linha 62: padding top (8.h) - DIMINUIR = mais compacto
// - Linha 64: padding bottom (20.h) - AUMENTAR = mais espaço
//
// 🎯 TAMANHOS DE FONTE:
// - Linha 72: "Olá, Israel" = 16.sp
// - Linha 82: "Saldo" = 12.sp
// - Linha 144: "R$ 500,00" = 18.sp ← PRINCIPAL!
//
// 🎯 TAMANHOS DE COMPONENTES:
// - Linha 120: Avatar = 50x50
// - Linha 207: Olhinho = 36x36
//
// 🎯 ESPAÇAMENTOS:
// - Linha 68: Avatar ↔️ Textos = 12.w
// - Linha 78: "Olá" ↕️ "Saldo" = 2.h
//
// ═══════════════════════════════════════════════════════════════