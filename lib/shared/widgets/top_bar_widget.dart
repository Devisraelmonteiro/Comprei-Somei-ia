// lib/shared/widgets/top_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

/// 🔝 TopBar - Header COMPACTO com olhinho na altura do "Saldo"
/// 
/// Layout:
/// ┌─────────────────────────┐
/// │ 👤  Olá, Israel         │
/// │     Saldo          👁️   │  ← Olhinho aqui!
/// │     R$ 500,00           │
/// └─────────────────────────┘
/// 
/// 📝 COMO AJUSTAR CORES:
/// - "Olá, Israel": linha 85
/// - "Saldo": linha 103
/// - "R$ 500,00": linha 186
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
          bottom: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.w,   // Margem esquerda
            4.h,    // Margem topo
            16.w,   // Margem direita
            100.h,  // Margem fundo (espaço para scanner)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 AVATAR
              _buildAvatar(),
              
              SizedBox(width: 12.w),
              
              // 📝 TEXTOS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👋 "Olá, Israel"
                    Text(
                      AppStrings.greeting(widget.userName),
                      style: TextStyle(
                        // 🎨 COR "OLÁ, ISRAEL" ← EDITE AQUI (linha 85)!
                        color: Colors.yellow,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: 1.h),
                    
                    // 💼 "SALDO" + 👁️ OLHINHO (mesma linha, alinhado à direita)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // "Saldo"
                        Text(
                          AppStrings.balanceLabel,
                          style: TextStyle(
                            // 🎨 COR "SALDO" ← EDITE AQUI (linha 103)!
                            color: const Color.fromARGB(183, 255, 255, 255),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        // 👁️ Olhinho (alinhado à direita)
                        _buildEyeToggle(),
                      ],
                    ),
                    
                    // 💵 "R$ 500,00"
                    _buildBalanceValue(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 👤 Avatar
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Container(
        // 📐 TAMANHO AVATAR ← EDITE AQUI (linha 134)!
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteWithOpacity(0.2),
          border: Border.all(
            color: AppColors.whiteWithOpacity(0.3),
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
                size: 30.sp,
              )
            : null,
      ),
    );
  }

  /// 💵 Valor do saldo
  Widget _buildBalanceValue() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        showBalance
            ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
            : "R\$ ••••••",
        key: ValueKey(showBalance),
        style: TextStyle(
          // 🎨 COR "R$ 500,00" ← EDITE AQUI (linha 186)!
          color: const Color.fromARGB(255, 255, 255, 255),
          
          // 📝 FONTE "R$ 500,00" ← EDITE AQUI (linha 189)!
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  /// 👁️ Botão toggle
  Widget _buildEyeToggle() {
    return GestureDetector(
      onTap: () => setState(() => showBalance = !showBalance),
      child: Container(
        // 📐 TAMANHO OLHINHO ← EDITE AQUI (linha 205)!
        width: 25.w,
        height: 25.w,
        decoration: BoxDecoration(
          color: AppColors.whiteWithOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          showBalance 
              ? Icons.visibility_outlined 
              : Icons.visibility_off_outlined,
          color: AppColors.white,
          // 📐 ÍCONE OLHINHO ← EDITE AQUI (linha 218)!
          size: 18.sp,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 📋 GUIA RÁPIDO - ONDE EDITAR
// ═══════════════════════════════════════════════════════════════
//
// 🎨 CORES:
// 
// Linha 85:  "Olá, Israel" = Colors.yellow
// Linha 103: "Saldo"       = Color.fromARGB(183, 255, 255, 255)
// Linha 186: "R$ 500,00"   = Color.fromARGB(255, 255, 255, 255)
//
// ─────────────────────────────────────────────────────────────
//
// 📐 TAMANHOS:
// 
// Linha 134: Avatar    = 40x40
// Linha 189: Fonte R$  = 15.sp
// Linha 205: Olhinho   = 25x25
// Linha 218: Ícone     = 18.sp
//
// ─────────────────────────────────────────────────────────────
//
// 📍 POSIÇÃO DO OLHINHO:
// 
// O olhinho está na MESMA LINHA do "Saldo"
// Alinhado à DIREITA (mainAxisAlignment: spaceBetween)
//
// Para ajustar o alinhamento, veja linha 96:
//   mainAxisAlignment: MainAxisAlignment.spaceBetween
//
// Outras opções:
//   - .start  (esquerda)
//   - .end    (direita)
//   - .center (centro)
//
// ═══════════════════════════════════════════════════════════════
//
// 💡 EXEMPLOS DE CORES:
//
// Amarelo brilhante:
//   color: Colors.yellow,
//
// Amarelo suave:
//   color: Color(0xFFFFE082),
//
// Branco 80%:
//   color: Colors.white.withOpacity(0.8),
//
// Preto:
//   color: Colors.black,
//
// Cinza:
//   color: Colors.grey.shade600,
//
// ═══════════════════════════════════════════════════════════════