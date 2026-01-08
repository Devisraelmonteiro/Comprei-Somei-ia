// lib/shared/widgets/top_bar_widget.dart

import 'package:flutter/material.dart';

class TopBarWidget extends StatefulWidget {
  final double height;
  final EdgeInsets? padding;
  final String userName;
  final double remaining;
  final String? userImagePath;
  
  // ✅ CONTROLES INDIVIDUAIS DE PADDING (EdgeInsets completo)
  final EdgeInsets? avatarInsets;
  final EdgeInsets? greetingInsets;
  final EdgeInsets? balanceLabelInsets;  // ← NOVO: para "Saldo"
  final EdgeInsets? balanceValueInsets;  // ← NOVO: para "R$ 485.51"
  final EdgeInsets? eyeInsets;
  
  // ✅ TAMANHOS CUSTOMIZÁVEIS
  final double? avatarSize;
  final double? greetingFontSize;
  final double? balanceLabelFontSize;
  final double? balanceValueFontSize;
  final double? eyeIconSize;
  
  // ✅ ESPAÇAMENTO ENTRE ELEMENTOS
  final double? spaceBetweenAvatarAndText;
  final double? spaceBetweenGreetingAndBalance;
  final double? spaceBetweenBalanceLabelAndValue;

  const TopBarWidget({
    super.key,
    this.height = 400,
    this.padding,
    required this.userName,
    required this.remaining,
    this.userImagePath,
    
    // Padding individual
    this.avatarInsets,
    this.greetingInsets,
    this.balanceLabelInsets,
    this.balanceValueInsets,
    this.eyeInsets,
    
    // Tamanhos
    this.avatarSize,
    this.greetingFontSize,
    this.balanceLabelFontSize,
    this.balanceValueFontSize,
    this.eyeIconSize,
    
    // Espaçamentos
    this.spaceBetweenAvatarAndText,
    this.spaceBetweenGreetingAndBalance,
    this.spaceBetweenBalanceLabelAndValue,
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 202, 95, 1), Color.fromARGB(255, 232, 145, 63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        minimum: EdgeInsets.zero,
        child: Container(
          height: widget.height,
          padding: widget.padding ?? 
                   const EdgeInsets.fromLTRB(20, 5, 22, 60),
          alignment: Alignment.topCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 AVATAR (abre sidebar)
              Padding(
                padding: widget.avatarInsets ?? EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    width: widget.avatarSize ?? 32,
                    height: widget.avatarSize ?? 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      image: widget.userImagePath != null
                          ? DecorationImage(
                              image: AssetImage(widget.userImagePath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: widget.userImagePath == null
                        ? Icon(
                            Icons.person,
                            color: Colors.white,
                            size: (widget.avatarSize ?? 32) * 0.875,
                          )
                        : null,
                  ),
                ),
              ),
              
              SizedBox(width: widget.spaceBetweenAvatarAndText ?? 10),
              
              // 📝 COLUNA: Nome + Saldo
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 👋 SAUDAÇÃO "Olá, Israel"
                    //Padding(
                      //padding: widget.greetingInsets ?? EdgeInsets.zero,
                      //child: Text(
                        //"Olá, ${widget.userName}",
                        //style: TextStyle(
                         // color: Colors.white,
                          //fontSize: widget.greetingFontSize ?? 14,
                          //fontWeight: FontWeight.w600,
                        //),
                      //),
                    //),
                    
                    SizedBox(height: widget.spaceBetweenGreetingAndBalance ?? 4),
                    
                    // 💰 LABEL "Saldo"
                    Padding(
                      padding: widget.balanceLabelInsets ?? EdgeInsets.zero,
                      child: Text(
                        "Saldo",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 7, 7, 7),
                          fontSize: widget.balanceLabelFontSize ?? 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: widget.spaceBetweenBalanceLabelAndValue ?? 0),
                    
                    // 💵 VALOR "R$ 485.51"
                    Padding(
                      padding: widget.balanceValueInsets ?? EdgeInsets.zero,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          showBalance
                              ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
                              : "R\$ ••••••",
                          key: ValueKey(showBalance),
                          style: TextStyle(
                            fontSize: widget.balanceValueFontSize ?? 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 👁️ OLHINHO (toggle saldo)
              Padding(
                padding: widget.eyeInsets ?? EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () => setState(() => showBalance = !showBalance),
                  child: Container(
                    width: widget.eyeIconSize ?? 20,
                    height: widget.eyeIconSize ?? 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      showBalance 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                      size: (widget.eyeIconSize ?? 25) * 0.8,
                    ),
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
