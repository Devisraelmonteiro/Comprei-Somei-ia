// lib/shared/widgets/top_bar_widget.dart

import 'package:flutter/material.dart';

class TopBarWidget extends StatefulWidget {
  final double height;
  final EdgeInsets? padding;
  final String userName;
  final double remaining;

  const TopBarWidget({
    super.key,
    this.height = 130, // ← Altura ajustada
    this.padding,
    required this.userName,
    required this.remaining,
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
        image: DecorationImage(
          image: AssetImage("assets/images/top_bar_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        minimum: EdgeInsets.zero,
        child: Container(
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 12), // ← Padding reduzido
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // ← Importante!
            children: [
              // ROW: Avatar + Olá + Olhinho
              Row(
                children: [
                  // AVATAR (abre sidebar)
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Olá, Nome
                  Expanded(
                    child: Text(
                      "Olá, ${widget.userName}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  // OLHINHO
                  GestureDetector(
                    onTap: () => setState(() => showBalance = !showBalance),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        showBalance 
                            ? Icons.visibility_outlined 
                            : Icons.visibility_off_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 10), // ← Reduzido de 12
              
              // SALDO
              const Text(
                "Saldo Restante",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // VALOR
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  showBalance
                      ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
                      : "R\$ ••••••",
                  key: ValueKey(showBalance),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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